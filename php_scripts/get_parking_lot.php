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

// Fetch parking lot data
$sql = "SELECT parking_lot_id, parking_lot_name, total_earnings FROM parking_lots WHERE parking_lot_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $parking_lot_id);
$stmt->execute();
$result = $stmt->get_result();

// Check if the parking lot exists
if ($result->num_rows === 0)
{
    http_response_code(404);
    echo json_encode(["error" => "Parking lot not found"]);
    exit();
}

$parking_lot_data = $result->fetch_assoc();

// Fetch parking slots data along with size and vehicle data
$sql = "SELECT ps.slot_id, ps.slot_x, ps.slot_y, ps.size_id, ps.vehicle_id,
               sz.size_id, sz.max_length, sz.max_width, sz.min_hours, sz.fixed_rate,
               sz.additional_rate, sz.day_rate,
               v.vehicle_id, v.vehicle_name, v.vehicle_length, v.vehicle_width, v.record_id
        FROM parking_slots ps
        LEFT JOIN sizes sz ON ps.size_id = sz.size_id
        LEFT JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
        WHERE ps.parking_lot_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $parking_lot_id);
$stmt->execute();
$result = $stmt->get_result();

// Store parking slot data in an array
$parking_slots = [];
while ($row = $result->fetch_assoc())
{
    $parking_slots[] = $row;
}

// Fetch entry points data
$sql = "SELECT entry_point_id, entry_point_x, entry_point_y FROM entry_points WHERE parking_lot_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $parking_lot_id);
$stmt->execute();
$result = $stmt->get_result();

// Store entry point data in an array
$entry_points = [];
while ($row = $result->fetch_assoc())
{
    $entry_points[] = $row;
}

// Fetch distance data
$sql = "SELECT
            entry_point_id,
            slot_id,
            distance
        FROM
            distances
        WHERE
            entry_point_id IN (
                SELECT entry_point_id FROM entry_points
                WHERE parking_lot_id = ?
            ) AND slot_id IN (
                SELECT slot_id FROM parking_slots WHERE parking_lot_id = ?
            )";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ii", $parking_lot_id, $parking_lot_id);
$stmt->execute();
$result = $stmt->get_result();

// Store distance data in an array
$distances = [];
while ($row = $result->fetch_assoc())
{
    $distances[] = $row;
}

// Close the database connection
$conn->close();

// Combine all data and return as JSON
$data = ["parking_lot" => $parking_lot_data, "parking_slots" => $parking_slots, "entry_points" => $entry_points, "distances" => $distances, // Add the distances to the data
];

header("Content-Type: application/json");
echo json_encode($data);
?>
