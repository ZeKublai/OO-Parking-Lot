<?php
include "utils.php";

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] !== "POST")
{
    send_response(false, "Invalid request method.");
}

// Get the parking_lot_id from the request body
$data = json_decode(file_get_contents("php://input") , true);
$parking_lot_id = intval($data["parking_lot_id"]);

// Connect to the database
$conn = connect_to_db();

try
{
    // Start a transaction
    $conn->begin_transaction();

    // Delete all parking records for the given parking lot
    $sql_delete_records = "DELETE FROM parking_records WHERE parking_lot_id = ?";
    $stmt_delete_records = $conn->prepare($sql_delete_records);
    $stmt_delete_records->bind_param("i", $parking_lot_id);
    if (!$stmt_delete_records->execute())
    {
        throw new Exception("Error deleting parking records: " . $stmt_delete_records->error);
    }

    // Reset the parking lot's total earnings to 0
    $sql_reset_earnings = "UPDATE parking_lots SET total_earnings = 0 WHERE parking_lot_id = ?";
    $stmt_reset_earnings = $conn->prepare($sql_reset_earnings);
    $stmt_reset_earnings->bind_param("i", $parking_lot_id);
    if (!$stmt_reset_earnings->execute())
    {
        throw new Exception("Error resetting total earnings: " . $stmt_reset_earnings->error);
    }

    // Set the vehicle_id of parking slots to NULL
    $sql_reset_slots = "UPDATE parking_slots SET vehicle_id = NULL WHERE parking_lot_id = ?";
    $stmt_reset_slots = $conn->prepare($sql_reset_slots);
    $stmt_reset_slots->bind_param("i", $parking_lot_id);
    if (!$stmt_reset_slots->execute())
    {
        throw new Exception("Error resetting parking slots: " . $stmt_reset_slots->error);
    }

    // Commit the transaction
    $conn->commit();

    // Send success response
    send_response(true, "Parking records reset successfully.");
}
catch(Exception $e)
{
    // Rollback the transaction on error
    $conn->rollback();

    // Send error response
    send_response(false, "An error occurred: " . $e->getMessage());
}
?>
