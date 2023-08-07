<?php
include "utils.php";

// Check if the parking_lot_id parameter is provided
if (!isset($_GET["parking_lot_id"]))
{
    http_response_code(400);
    echo json_encode(["error" => "Missing parking_lot_id parameter"]);
    exit();
}

$parking_lot_id = $_GET["parking_lot_id"];
$conn = connect_to_db();

// Check if the parking lot has at least 3 entry points
$sql_check_entry_points = "SELECT COUNT(*) AS num_entry_points FROM entry_points WHERE parking_lot_id = ?";
$stmt_check_entry_points = $conn->prepare($sql_check_entry_points);
$stmt_check_entry_points->bind_param("i", $parking_lot_id);
$stmt_check_entry_points->execute();
$result_check_entry_points = $stmt_check_entry_points->get_result();
$row_check_entry_points = $result_check_entry_points->fetch_assoc();
$num_entry_points = intval($row_check_entry_points["num_entry_points"]);
$stmt_check_entry_points->close();

// Check if the parking lot has at least 1 slot
$sql_check_slots = "SELECT COUNT(*) AS num_slots FROM parking_slots WHERE parking_lot_id = ?";
$stmt_check_slots = $conn->prepare($sql_check_slots);
$stmt_check_slots->bind_param("i", $parking_lot_id);
$stmt_check_slots->execute();
$result_check_slots = $stmt_check_slots->get_result();
$row_check_slots = $result_check_slots->fetch_assoc();
$num_slots = intval($row_check_slots["num_slots"]);
$stmt_check_slots->close();

// If conditions are not met, send an error response
if ($num_entry_points < 3)
{
    send_response(false, "Cannot open parking lot. It should have at least 3 entry points.");
}

if ($num_slots < 1)
{
    send_response(false, "Cannot open parking lot. It should have at least 1 slot.");
}

// Close the database connection
$conn->close();

// Send success response
send_response(true, "Success!");
?>
