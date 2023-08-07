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
if (!isset($data["entry_point_id"]) || !isset($data["entry_datetime"]))
{
    send_response(false, "Missing required parameters");
}

$entry_point_id = intval($data["entry_point_id"]);
$entry_datetime = $data["entry_datetime"];

// Validate and format entry datetime
date_default_timezone_set("Asia/Manila");
$entry_datetime_format = "Y-m-d H:i:s";
$entry_datetime_obj = DateTime::createFromFormat("U", intval($entry_datetime / 1000));
if ($entry_datetime_obj === false)
{
    send_response(false, "Invalid entry datetime format");
}
$entry_datetime_obj->setTimezone(new DateTimeZone("Asia/Manila")); // Set the desired timezone
$entry_datetime_formatted = $entry_datetime_obj->format($entry_datetime_format);

$conn = connect_to_db();

// Check if the entry point exists and get its parking lot ID
$sql_entry_point = "SELECT parking_lot_id FROM entry_points WHERE entry_point_id = ?";
$stmt_entry_point = $conn->prepare($sql_entry_point);
$stmt_entry_point->bind_param("i", $entry_point_id);
$stmt_entry_point->execute();
$result_entry_point = $stmt_entry_point->get_result();

if ($result_entry_point->num_rows === 0)
{
    send_response(false, "Entry point does not exist");
}

$row_entry_point = $result_entry_point->fetch_assoc();
$parking_lot_id = $row_entry_point["parking_lot_id"];

// Check if the parking lot has at least 1 slot and at least 3 entry points
$sql_check_slots = "SELECT COUNT(*) AS slot_count FROM parking_slots WHERE parking_lot_id = ?";
$sql_check_entry_points = "SELECT COUNT(*) AS entry_point_count FROM entry_points WHERE parking_lot_id = ?";
$stmt_check_slots = $conn->prepare($sql_check_slots);
$stmt_check_entry_points = $conn->prepare($sql_check_entry_points);
$stmt_check_slots->bind_param("i", $parking_lot_id);
$stmt_check_entry_points->bind_param("i", $parking_lot_id);

$stmt_check_slots->execute();
$result_check_slots = $stmt_check_slots->get_result();
$stmt_check_entry_points->execute();
$result_check_entry_points = $stmt_check_entry_points->get_result();

$row_check_slots = $result_check_slots->fetch_assoc();
$row_check_entry_points = $result_check_entry_points->fetch_assoc();

if ($row_check_slots["slot_count"] === 0 || $row_check_entry_points["entry_point_count"] < 3)
{
    send_response(false, "Parking conditions not met");
}

// Check if the vehicle exists (for existing vehicles)
if (isset($data["vehicle_id"]))
{
    $vehicle_id = intval($data["vehicle_id"]);

    $sql_vehicle = "SELECT vehicle_length, vehicle_width, record_id FROM vehicles WHERE vehicle_id = ?";
    $stmt_vehicle = $conn->prepare($sql_vehicle);
    $stmt_vehicle->bind_param("i", $vehicle_id);
    $stmt_vehicle->execute();
    $result_vehicle = $stmt_vehicle->get_result();

    if ($result_vehicle->num_rows === 0)
    {
        send_response(false, "Vehicle does not exist");
    }

    $row_vehicle = $result_vehicle->fetch_assoc();
    $vehicle_length = $row_vehicle["vehicle_length"];
    $vehicle_width = $row_vehicle["vehicle_width"];
    $record_id = $row_vehicle["record_id"];

    // Check if the parking record exists and is valid
    $sql_record = "SELECT
                        record_id,
                        entry_datetime,
                        exit_datetime
                    FROM parking_records
                    WHERE vehicle_id = ? AND parking_lot_id = ? AND exit_datetime IS NOT NULL
                    ORDER BY
                        exit_datetime DESC,
                        entry_datetime DESC LIMIT 1";
    $stmt_record = $conn->prepare($sql_record);
    $stmt_record->bind_param("ii", $vehicle_id, $parking_lot_id);
    $stmt_record->execute();
    $result_record = $stmt_record->get_result();

    if ($result_record->num_rows > 0)
    {
        $row_record = $result_record->fetch_assoc();
        $record_id = $row_record["record_id"];
        $entry_datetime_record = strtotime($row_record["entry_datetime"]);
        $exit_datetime_record = strtotime($row_record["exit_datetime"]);

        // Check for time-traveling
        if ($entry_datetime_obj->getTimestamp() < $entry_datetime_record || ($exit_datetime_record !== null && $entry_datetime_obj->getTimestamp() < $exit_datetime_record))
        {
            send_response(false, "Invalid entry datetime check for time travel");
        }
        elseif ($exit_datetime_record !== null)
        {
            $one_hour_later = $exit_datetime_record + 3600; // 3600 seconds = 1 hour
            if ($entry_datetime_obj->getTimestamp() >= $one_hour_later)
            {
                $record_id = null;
            }
        }
    }
    else
    {
        // Record is invalid if it is a different parking lot.
        if ($record_id != null)
        {
            send_response(false, "Vehichle is parked in another parking lot");
        }
    }

    // Check if the vehicle is parked in any slot
    $sql_check_parked = "SELECT slot_id FROM parking_slots WHERE vehicle_id = ?";
    $stmt_check_parked = $conn->prepare($sql_check_parked);
    $stmt_check_parked->bind_param("i", $vehicle_id);
    $stmt_check_parked->execute();
    $result_check_parked = $stmt_check_parked->get_result();

    if ($result_check_parked->num_rows > 0)
    {
        send_response(false, "Vehicle is already parked");
    }
}
elseif (isset($data["vehicle_name"], $data["vehicle_width"], $data["vehicle_length"]))
{
    // Check if the vehicle is new
    $vehicle_id = null;
    $vehicle_name = $data["vehicle_name"];
    $vehicle_width = floatval($data["vehicle_width"]);
    $vehicle_length = floatval($data["vehicle_length"]);
    $record_id = null;

    // Validate vehicle name
    if (empty($vehicle_name))
    {
        send_response(false, "Vehicle name cannot be empty");
    }

    // Validate vehicle width and length
    if (!is_numeric($vehicle_width) || !is_numeric($vehicle_length))
    {
        send_response(false, "Invalid vehicle width or length");
    }

    // Ensure vehicle width and length are within valid range (0 to 3)
    if ($vehicle_width <= 0 || $vehicle_width > 3 || $vehicle_length <= 0 || $vehicle_length > 3)
    {
        send_response(false, "Vehicle width and length must be a non-zero between 0 and 3");
    }
}
else
{
    send_response(false, "Invalid input parameters");
}

// Check for available slots that meet the size requirements
$sql_available_slots = "SELECT ps.slot_id, ps.slot_x, ps.slot_y, sz.size_id, sz.max_length, sz.max_width FROM parking_slots ps
                        INNER JOIN sizes sz ON ps.size_id = sz.size_id
                        WHERE ps.parking_lot_id = ? AND ps.vehicle_id IS NULL
                        AND sz.max_length >= ? AND sz.max_width >= ?
                        ORDER BY
                        (SELECT distance FROM distances d
                        WHERE d.entry_point_id = ? AND d.slot_id = ps.slot_id) ASC
                        LIMIT 1";
$stmt_available_slots = $conn->prepare($sql_available_slots);
$stmt_available_slots->bind_param("iddi", $parking_lot_id, $vehicle_length, $vehicle_width, $entry_point_id);
$stmt_available_slots->execute();
$result_available_slots = $stmt_available_slots->get_result();

if ($result_available_slots->num_rows === 0)
{
    send_response(false, "No available slots that meet size requirements");
}

$row_available_slots = $result_available_slots->fetch_assoc();
$selected_slot_id = $row_available_slots["slot_id"];
$selected_size_id = $row_available_slots["size_id"];

// Begin a transaction
$conn->begin_transaction();

try
{
    // Check if the vehicle is new
    if (isset($data["vehicle_name"], $data["vehicle_width"], $data["vehicle_length"]) && $vehicle_id == null)
    {
        // Sanitize and validate input data here
        $vehicle_name = $conn->real_escape_string(sanitize_input($vehicle_name));

        // Insert the new vehicle into the database
        $sql_insert_vehicle = "INSERT INTO vehicles (vehicle_name, vehicle_length, vehicle_width) VALUES (?, ?, ?)";
        $stmt_insert_vehicle = $conn->prepare($sql_insert_vehicle);
        $stmt_insert_vehicle->bind_param("sdd", $vehicle_name, $vehicle_length, $vehicle_width);

        if (!$stmt_insert_vehicle->execute())
        {
            throw new Exception("Error inserting vehicle: " . $stmt_insert_vehicle->error);
        }

        // Use the newly inserted vehicle's ID
        $vehicle_id = $stmt_insert_vehicle->insert_id;
    }

    // Park the vehicle in the selected slot
    $sql_park_vehicle = "UPDATE parking_slots SET vehicle_id = ? WHERE slot_id = ?";
    $stmt_park_vehicle = $conn->prepare($sql_park_vehicle);
    $stmt_park_vehicle->bind_param("ii", $vehicle_id, $selected_slot_id);
    if (!$stmt_park_vehicle->execute())
    {
        throw new Exception("Error parking the vehicle: " . $stmt_park_vehicle->error);
    }

    // Insert a new parking record
    if ($record_id === null)
    {
        $sql_insert_record = "INSERT INTO parking_records (vehicle_id, entry_datetime, parking_lot_id) VALUES (?, ?, ?)";
        $stmt_insert_record = $conn->prepare($sql_insert_record);
        $stmt_insert_record->bind_param("isi", $vehicle_id, $entry_datetime_formatted, $parking_lot_id);

        if (!$stmt_insert_record->execute())
        {
            throw new Exception("Error inserting parking record: " . $stmt_insert_record->error);
        }

        // Get the newly inserted record ID
        $record_id = $stmt_insert_record->insert_id;
    }
    else
    {
        // Update the existing record by setting exit_datetime to NULL
        $sql_update_record = "UPDATE parking_records SET exit_datetime = NULL WHERE record_id = ?";
        $stmt_update_record = $conn->prepare($sql_update_record);
        $stmt_update_record->bind_param("i", $record_id);

        if (!$stmt_update_record->execute())
        {
            throw new Exception("Error updating parking record: " . $stmt_update_record->error);
        }
    }

    // Insert charge
    $sql_insert_charges = "INSERT INTO charges (charge_value, total_hours, entry_datetime, exit_datetime, record_id, size_id) VALUES (?, ?, ?, NULL, ?, ?)";
    $stmt_insert_charges = $conn->prepare($sql_insert_charges);
    $charge_value = 0; // Set the initial charge value
    $total_hours = 0; // Set the initial total hours
    $stmt_insert_charges->bind_param("iisii", $charge_value, $total_hours, $entry_datetime_formatted, $record_id, $selected_size_id);

    if (!$stmt_insert_charges->execute())
    {
        throw new Exception("Error inserting charges: " . $stmt_insert_charges->error);
    }

    // Update the vehicle's record ID
    if ($vehicle_id !== null && $record_id !== null)
    {
        $sql_update_vehicle = "UPDATE vehicles SET record_id = ? WHERE vehicle_id = ?";
        $stmt_update_vehicle = $conn->prepare($sql_update_vehicle);
        $stmt_update_vehicle->bind_param("ii", $record_id, $vehicle_id);

        if (!$stmt_update_vehicle->execute())
        {
            throw new Exception("Error updating vehicle record ID: " . $stmt_update_vehicle->error);
        }
    }
    else
    {
        throw new Exception("Failed to set vehicle's record ID");
    }

    // Commit the transaction
    $conn->commit();

    // Send success response
    send_response(true, "Vehicle parked successfully");
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
