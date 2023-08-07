<?php
include "utils.php";

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] !== "POST")
{
    send_response(false, "Invalid request method.");
}

// Get the data from the request body
$data = json_decode(file_get_contents("php://input") , true);

// Check if the required parameters are provided
if (!isset($data["slot_id"]) || !isset($data["vehicle_id"]) || !isset($data["parking_lot_id"]) || !isset($data["exit_datetime"]))
{
    send_response(false, "Missing required parameters");
}

// Get the slot_id, vehicle_id, and parking_lot_id from the query parameters
$slot_id = intval($data["slot_id"]);
$vehicle_id = intval($data["vehicle_id"]);
$parking_lot_id = intval($data["parking_lot_id"]);
$exit_datetime = $data["exit_datetime"];

// Validate and format entry datetime
date_default_timezone_set("Asia/Manila");
$exit_datetime_format = "Y-m-d H:i:s";
$exit_datetime_obj = DateTime::createFromFormat("U", intval($exit_datetime / 1000));
if ($exit_datetime_obj === false)
{
    send_response(false, "Invalid exit datetime format");
}
$exit_datetime_obj->setTimezone(new DateTimeZone("Asia/Manila")); // Set the desired timezone
$exit_datetime_formatted = $exit_datetime_obj->format($exit_datetime_format);

$conn = connect_to_db();

try
{
    // Getting the latest valid parking record
    $sql_record = "SELECT
                        ps.slot_id,
                        ps.parking_lot_id,
                        sz.min_hours,
                        sz.fixed_rate,
                        sz.additional_rate,
                        sz.day_rate,
                        v.vehicle_id,
                        v.vehicle_name,
                        pr.record_id,
                        pr.entry_datetime
                    FROM parking_slots ps
                    LEFT JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
                    LEFT JOIN parking_records pr ON v.record_id = pr.record_id
                    LEFT JOIN sizes sz ON ps.size_id = sz.size_id
                    WHERE ps.slot_id = ?
                        AND ps.parking_lot_id = ?
                        AND ps.vehicle_id IS NOT NULL
                        AND ps.vehicle_id = ?
                        AND v.record_id IS NOT NULL
                        AND pr.entry_datetime < ?
                        AND pr.exit_datetime IS NULL
                    LIMIT 1";

    $stmt_record = $conn->prepare($sql_record);
    $stmt_record->bind_param("iiis", $slot_id, $parking_lot_id, $vehicle_id, $exit_datetime_formatted);
    $stmt_record->execute();
    $result_record = $stmt_record->get_result();

    if ($result_record->num_rows === 0)
    {
        throw new Exception("No valid parking record found with the given exit time. Check for time travel.");
    }

    $row_record = $result_record->fetch_assoc();
    $record_id = $row_record["record_id"];

    // Select charges associated with the record
    $sql_charges = "SELECT charge_id, charge_value, total_hours, entry_datetime, exit_datetime, size_id
                    FROM charges
                    WHERE record_id = ?
                    ORDER BY entry_datetime";

    $stmt_charges = $conn->prepare($sql_charges);
    $stmt_charges->bind_param("i", $record_id);
    $stmt_charges->execute();
    $result_charges = $stmt_charges->get_result();

    if ($result_charges->num_rows === 0)
    {
        throw new Exception("No charge records found.");
    }

    $charges = [];
    while ($row_charge = $result_charges->fetch_assoc())
    {
        $charges[] = $row_charge;
    }

    // Find the latest charge with exit_datetime NULL (if not found, there's an issue)
    $latest_charge = null;
    $previous_charge_values = 0;
    $previous_hours = 0;
    foreach ($charges as $charge)
    {
        if ($charge["exit_datetime"] === null)
        {
            if ($latest_charge === null)
            {
                $latest_charge = $charge;
            }
            else
            {
                // Error: Multiple charges with exit_datetime NULL
                throw new Exception("Multiple charges with exit_datetime NULL found.");
            }
        }
        else
        {
            $previous_charge_values += $charge["charge_value"];
            $previous_hours += $charge["total_hours"];
        }
    }
    if ($latest_charge === null)
    {
        // Error: No charge with exit_datetime NULL found
        throw new Exception("No charge with exit_datetime NULL found.");
    }

    // Calculate breakdown using the latest charge's entry datetime and given exit datetime
    $breakdown = get_breakdown($latest_charge["entry_datetime"], $exit_datetime_formatted);
    if ($breakdown == false)
    {
        // Error: No time traveling allowed
        throw new Exception("No time traveling allowed.");
    }

    // Calculate charge value.
    $charge_value = set_estimated_total($breakdown, $row_record, $previous_hours, $previous_charge_values);
    if ($charge_value < 0)
    {
        // Error: No free parking
        throw new Exception("Charge value should not be negative.");
    }

    // Begin a transaction
    $conn->begin_transaction();

    // Update the latest charge's total_hours, exit_datetime, and charge_value in the charges table
    $sql_update_charge = "UPDATE charges SET total_hours = ?, exit_datetime = ?, charge_value = ? WHERE charge_id = ?";
    $stmt_update_charge = $conn->prepare($sql_update_charge);
    $stmt_update_charge->bind_param("isii", $breakdown["total_hours"], $exit_datetime_formatted, $charge_value, $latest_charge["charge_id"]);
    if (!$stmt_update_charge->execute())
    {
        throw new Exception("Error updating charge: " . $stmt_update_charge->error);
    }

    // Update parking record with the exit datetime in the parking_records table
    $sql_update_record = "UPDATE parking_records SET exit_datetime = ? WHERE record_id = ?";
    $stmt_update_record = $conn->prepare($sql_update_record);
    $stmt_update_record->bind_param("si", $exit_datetime_formatted, $record_id);
    if (!$stmt_update_record->execute())
    {
        throw new Exception("Error updating parking record: " . $stmt_update_record->error);
    }

    // Set the slot's vehicle_id to null in the parking_slots table
    $sql_clear_slot = "UPDATE parking_slots SET vehicle_id = NULL WHERE slot_id = ?";
    $stmt_clear_slot = $conn->prepare($sql_clear_slot);
    $stmt_clear_slot->bind_param("i", $slot_id);
    if (!$stmt_clear_slot->execute())
    {
        throw new Exception("Error clearing slot: " . $stmt_clear_slot->error);
    }

    // Update parking lot's total_earnings
    $sql_update_earnings = "UPDATE parking_lots SET total_earnings = total_earnings + ? WHERE parking_lot_id = ?";
    $stmt_update_earnings = $conn->prepare($sql_update_earnings);
    $stmt_update_earnings->bind_param("ii", $charge_value, $parking_lot_id);
    if (!$stmt_update_earnings->execute())
    {
        throw new Exception("Error updating parking lot earnings: " . $stmt_update_earnings->error);
    }

    // Commit the transaction
    $conn->commit();

    // Send success response
    send_response(true, "Vehicle successfully unparked and charged.");
}
catch(Exception $e)
{
    // Roll back the transaction on error
    $conn->rollback();

    // Send error response
    send_response(false, "An error occurred: " . $e->getMessage());
}

// Close the database connection
$conn->close();
?>
