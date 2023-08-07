<?php
include "utils.php";

$conn = connect_to_db();

// Fetch data from the database
$sql = "SELECT
            pl.parking_lot_id,
            pl.parking_lot_name,
            pl.total_earnings,
            COUNT(ep.entry_point_id) AS entry_point_count,
            CASE WHEN (
                SELECT COUNT(ps.slot_id) FROM parking_slots ps
                WHERE ps.parking_lot_id = pl.parking_lot_id AND ps.vehicle_id IS NOT NULL
            ) = 0 THEN 'true' ELSE 'false' END AS empty,
            COUNT(ps.slot_id) AS slot_count
        FROM
            parking_lots pl
        LEFT JOIN
            entry_points ep ON pl.parking_lot_id = ep.parking_lot_id
        LEFT JOIN
            parking_slots ps ON pl.parking_lot_id = ps.parking_lot_id
        GROUP BY
            pl.parking_lot_id, pl.parking_lot_name, pl.total_earnings";
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
