<?php
include "utils.php";

$conn = connect_to_db();

// Fetch available vehicles that are not in any slots
$sql = "SELECT vehicle_id, vehicle_name, vehicle_length, vehicle_width FROM vehicles
        WHERE vehicle_id NOT IN (SELECT DISTINCT vehicle_id FROM parking_slots WHERE vehicle_id IS NOT NULL)";
$result = $conn->query($sql);

// Store the data in an array
$data = [];
if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
        $data[] = $row;
    }
}

// Close the database connection
$conn->close();

// Return the data as JSON
header("Content-Type: application/json");
echo json_encode($data);
?>
