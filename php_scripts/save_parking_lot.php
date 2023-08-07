<?php
include "utils.php";

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] !== "POST")
{
    send_response(false, "Invalid request method.");
}

// Get the data from the request body
$data = json_decode(file_get_contents("php://input") , true);

// Validate input
if (empty($data["parking_lot_name"]))
{
    send_response(false, "Parking lot name cannot be empty.");
}

// Validate entry points
$entry_points = json_decode($data["entry_points"], true);
if (count($entry_points) < 3)
{
    send_response(false, "There must be at least 3 entry points.");
}

foreach ($entry_points as $entry_point)
{
    if (!($entry_point["x"] >= 0 && $entry_point["x"] <= 15 && $entry_point["y"] >= 0 && $entry_point["y"] <= 15))
    {
        send_response(false, "Invalid entry point coordinates.");
    }
}

// Validate slots
$slots = json_decode($data["slots"], true);
if (count($slots) <= 0)
{
    send_response(false, "There must be at least 1 slot.");
}

foreach ($slots as $slot)
{
    if (!($slot["x"] >= 0 && $slot["x"] <= 15 && $slot["y"] >= 0 && $slot["y"] <= 15))
    {
        send_response(false, "Invalid slot coordinates.");
    }
}

// Connect to the database
$conn = connect_to_db();

// Sanitize the input
$parking_lot_id = intval($data["parking_lot_id"]);
$parking_lot_name = $conn->real_escape_string(sanitize_input($data["parking_lot_name"]));

// Check if any vehicle is parked in the slots
$sql_check_slots = "SELECT COUNT(*) AS parked_vehicles FROM parking_slots WHERE parking_lot_id = ? AND vehicle_id IS NOT NULL";
$stmt_check_slots = $conn->prepare($sql_check_slots);
$stmt_check_slots->bind_param("i", $parking_lot_id);
$stmt_check_slots->execute();
$result_check_slots = $stmt_check_slots->get_result();
$row_check_slots = $result_check_slots->fetch_assoc();
$parked_vehicles = intval($row_check_slots["parked_vehicles"]);
$stmt_check_slots->close();

// If any vehicle is still parked, send an error response
if ($parked_vehicles > 0)
{
    send_response(false, "Cannot edit parking lot. There are still parked vehicles in the slots.");
}

// Update parking lot name using prepared statement
$sql_update_name = "UPDATE parking_lots SET parking_lot_name = ? WHERE parking_lot_id = ?";
$stmt_update_name = $conn->prepare($sql_update_name);
$stmt_update_name->bind_param("si", $parking_lot_name, $parking_lot_id);
if (!$stmt_update_name->execute())
{
    send_response(false, "Error updating parking lot name: " . $conn->error);
}
$stmt_update_name->close();

// Delete existing entry points and slots for the parking lot using prepared statements
$sql_delete_entry_points = "DELETE FROM entry_points WHERE parking_lot_id = ?";
$stmt_delete_entry_points = $conn->prepare($sql_delete_entry_points);
$stmt_delete_entry_points->bind_param("i", $parking_lot_id);
if (!$stmt_delete_entry_points->execute())
{
    send_response(false, "Error deleting existing entry points: " . $conn->error);
}
$stmt_delete_entry_points->close();

$sql_delete_slots = "DELETE FROM parking_slots WHERE parking_lot_id = ?";
$stmt_delete_slots = $conn->prepare($sql_delete_slots);
$stmt_delete_slots->bind_param("i", $parking_lot_id);
if (!$stmt_delete_slots->execute())
{
    send_response(false, "Error deleting existing slots: " . $conn->error);
}
$stmt_delete_slots->close();

// Insert new entry points and slots using prepared statements
$sql_insert_entry_point = "INSERT INTO entry_points (entry_point_x, entry_point_y, parking_lot_id) VALUES (?, ?, ?)";
$stmt_insert_entry_point = $conn->prepare($sql_insert_entry_point);
$stmt_insert_entry_point->bind_param("iii", $x, $y, $parking_lot_id);

$sql_insert_slot = "INSERT INTO parking_slots (slot_x, slot_y, size_id, parking_lot_id) VALUES (?, ?, ?, ?)";
$stmt_insert_slot = $conn->prepare($sql_insert_slot);
$stmt_insert_slot->bind_param("iiii", $x, $y, $size_id, $parking_lot_id);

$sql_insert_distance = "INSERT INTO distances (entry_point_id, slot_id, distance) VALUES (?, ?, ?)";
$stmt_insert_distance = $conn->prepare($sql_insert_distance);
$stmt_insert_distance->bind_param("iid", $entry_point_id, $slot_id, $distance);

foreach ($entry_points as $entry_point_key => $entry_point)
{
    $x = intval($entry_point["x"]);
    $y = intval($entry_point["y"]);
    if (!$stmt_insert_entry_point->execute())
    {
        send_response(false, "Error adding new entry points: " . $conn->error);
    }

    // Get the entry point ID of the last inserted entry point
    $entry_point_id = $conn->insert_id;
    $entry_points[$entry_point_key]["insert_id"] = $entry_point_id;
}

foreach ($slots as $slot)
{
    $x = intval($slot["x"]);
    $y = intval($slot["y"]);
    $size_id = intval($slot["size_id"]);
    if (!$stmt_insert_slot->execute())
    {
        send_response(false, "Error adding new slots: " . $conn->error);
    }

    // Get the slot ID of the last inserted slot
    $slot_id = $conn->insert_id;
    foreach ($entry_points as $entry_point)
    {
        // Calculate the distance between the entry point and slot (you need to implement this part)
        $entry_point_id = $entry_point["insert_id"];
        $distance = calculate_distance($entry_point, $slot);

        // Insert the distance into the distances table
        if (!$stmt_insert_distance->execute())
        {
            send_response(false, "Error adding new distance: " . $conn->error);
        }
    }
}

$stmt_insert_entry_point->close();
$stmt_insert_slot->close();
$stmt_insert_distance->close();

// Close the database connection
$conn->close();

// Send success response
send_response(true, "Parking lot saved successfully.");
?>
