<?php
// Function to establish a database connection
function connect_to_db()
{
    $host = "127.0.0.1";
    $username = "root";
    $password = "";
    $dbname = "oopl";

    $conn = new mysqli($host, $username, $password, $dbname);

    if ($conn->connect_error)
    {
        die("Connection failed: " . $conn->connect_error);
    }
    return $conn;
}

// Function to handle errors and return the response
function send_response($success, $message, $data = [])
{
    $response = ["success" => $success, "message" => $message, "data" => $data];
    header("Content-Type: application/json");
    echo json_encode($response);
    exit();
}

// Function to sanitize input data
function sanitize_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

function calculate_distance($entry_point, $slot)
{
    $x1 = $entry_point["x"];
    $y1 = $entry_point["y"];
    $x2 = $slot["x"];
    $y2 = $slot["y"];

    // Calculate the squared differences in x and y coordinates
    $dx = $x2 - $x1;
    $dy = $y2 - $y1;

    // Calculate the square of the distance
    $distance_squared = $dx * $dx + $dy * $dy;

    // Calculate the square root to get the actual distance
    $distance = sqrt($distance_squared);

    return $distance;
}
function get_breakdown($start_datetime, $end_datetime)
{
    // Calculate breakdown using the latest charge's entry datetime and given exit datetime
    $entry_datetime = new DateTime($start_datetime);
    $exit_datetime = new DateTime($end_datetime);
    $interval = $exit_datetime->diff($entry_datetime);

    $breakdown = ["days" => $interval->days, "hours" => $interval->h, "total_hours" => 0, ];

    // Round up hours if there are non-zero minutes or seconds
    if ($interval->i > 0 || $interval->s > 0)
    {
        $breakdown["hours"]++;
    }

    if ($breakdown["hours"] === 24)
    {
        $breakdown["days"]++;
        $breakdown["hours"] = 0;
    }

    // Get total hours.
    $breakdown["total_hours"] = $breakdown["days"] * 24 + $breakdown["hours"];

    // Invalid if 0.
    if ($breakdown["days"] === 0 && $breakdown["hours"] === 0)
    {
        $breakdown = false;
    }
    return $breakdown;
}
function set_estimated_total($breakdown, $row_record, $previous_hours, $previous_charge_values)
{
    $total_cost = 0;
    $fixed_hours = 0;
    $fixed_cost = 0;
    $additional_hours = 0;
    $additional_costs = 0;
    $day_costs = 0;

    // Return 0 if 0 days and 0 hours
    if ($breakdown["hours"] == 0 && $breakdown["days"] == 0)
    {
        return 0;
    }

    // Set cost for the initial min hours
    $fixed_cost = $row_record["fixed_rate"];
    $fixed_hours = $row_record["min_hours"];

    // No need to pay fixed cost if previous hours already paid for it.
    if ($previous_hours >= $row_record["min_hours"])
    {
        $fixed_cost = 0;
        $fixed_hours = 0;
    }
    else
    {
        // Pay for the difference if the fixed rate is higher for the current slot.
        $fixed_cost = max(0, $row_record["fixed_rate"] - $previous_charge_values);
        $fixed_hours = max(0, $row_record["min_hours"] - $previous_hours);
    }

    // Get initial additional hours
    $additional_hours = max(0, $breakdown["days"] * 24 + $breakdown["hours"] - $fixed_hours);

    // Apply penalty if exceeds 24 hours
    if ($breakdown["days"] > 0)
    {
        $day_costs = $breakdown["days"] * $row_record["day_rate"];
    }
    $additional_costs = $additional_hours * $row_record["additional_rate"];
    $total_cost = $day_costs + $additional_costs + $fixed_cost;
    return $total_cost;
}
?>
