<?php
include "utils.php";

// Check if the request is a GET request
if ($_SERVER["REQUEST_METHOD"] !== "GET")
{
    send_response(false, "Invalid request method.");
}

// Get the slot_id, vehicle_id, and parking_lot_id from the query parameters
$slot_id = intval($_GET["slot_id"]);
$vehicle_id = intval($_GET["vehicle_id"]);
$parking_lot_id = intval($_GET["parking_lot_id"]);

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
                        AND pr.exit_datetime IS NULL
                    LIMIT 1";

    $stmt_record = $conn->prepare($sql_record);
    $stmt_record->bind_param("iii", $slot_id, $parking_lot_id, $vehicle_id);
    $stmt_record->execute();
    $result_record = $stmt_record->get_result();

    if ($result_record->num_rows === 0)
    {
        send_response(false, "No valid parking record found.");
    }

    $row_record = $result_record->fetch_assoc();

    // Select charges associated with the record
    $sql_charges = "SELECT charge_id, charge_value, total_hours, entry_datetime, exit_datetime, size_id
                    FROM charges
                    WHERE record_id = ?
                    ORDER BY entry_datetime";

    $stmt_charges = $conn->prepare($sql_charges);
    $stmt_charges->bind_param("i", $row_record["record_id"]);
    $stmt_charges->execute();
    $result_charges = $stmt_charges->get_result();

    if ($result_charges->num_rows === 0)
    {
        send_response(false, "No charge records found.");
    }

    $charges = [];
    while ($row_charge = $result_charges->fetch_assoc())
    {
        $charges[] = $row_charge;
    }

    // Add charges to the response data
    $row_record["charges"] = $charges;
    send_response(true, "Parking records retrieved successfully.", $row_record);
}
catch(Exception $e)
{
    send_response(false, "An error occurred: " . $e->getMessage());
}

// Close the database connection
$conn->close();
