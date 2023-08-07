<?php
include "utils.php";

// Get parking lot ID from query parameter
$parking_lot_id = $_GET["parking_lot_id"];

$conn = connect_to_db();

// Select charges for the given parking lot, sorted by exit_datetime
$sql_charges = "SELECT v.vehicle_name, ch.entry_datetime, ch.exit_datetime, ch.total_hours, ch.charge_value
                FROM charges ch
                INNER JOIN parking_records pr ON ch.record_id = pr.record_id
                INNER JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
                WHERE pr.parking_lot_id = ?
                ORDER BY ch.exit_datetime IS NULL DESC, ch.exit_datetime DESC";

$stmt_charges = $conn->prepare($sql_charges);
$stmt_charges->bind_param("i", $parking_lot_id);
$stmt_charges->execute();
$result_charges = $stmt_charges->get_result();

$charges = [];
while ($row_charge = $result_charges->fetch_assoc())
{
    $charges[] = $row_charge;
}

// Send charges data as JSON response
send_response(true, "Charges retrieved successfully.", $charges);

// Close the database connection
$conn->close();
?>
