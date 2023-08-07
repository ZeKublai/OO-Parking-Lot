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

// Check if any vehicle is parked in the slots
$sql_check_slots = "SELECT 1 FROM parking_slots WHERE parking_lot_id = ? AND vehicle_id IS NOT NULL LIMIT 1";
$stmt_check_slots = $conn->prepare($sql_check_slots);
$stmt_check_slots->bind_param("i", $parking_lot_id);
$stmt_check_slots->execute();
$stmt_check_slots->store_result();
$num_parked_vehicles = $stmt_check_slots->num_rows;
$stmt_check_slots->close();

// If any vehicle is still parked, send an error response
if ($num_parked_vehicles > 0)
{
    send_response(false, "Cannot edit parking lot. There are still parked vehicles in the slots.");
}

// Close the database connection
$conn->close();

// Send success response
send_response(true, "Success!");
?>
