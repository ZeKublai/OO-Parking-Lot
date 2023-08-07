class Parking_Lot {
    constructor(data) {
        this.id = data.parking_lot.parking_lot_id;
        this.name = data.parking_lot.parking_lot_name;
        this.total_earnings = data.parking_lot.total_earnings;
        this.entry_points = data.entry_points.map(entry_point_data => new Entry_Point(entry_point_data));
        this.slots = data.parking_slots.map(slot_data => new Slot(slot_data));

        // Set distances for entry points
        this.entry_points.forEach(entry_point => {
            entry_point.distances = data.distances.filter(distance_data => distance_data.entry_point_id === entry_point.id);
        });
    }

    // Function to update Parking Lot based on grid data
    GRID(grid) {

        // Delete existing entry points and slots
        let grid_entry_points = [];
        let grid_slots = [];
        for (let i = 0; i < grid.length; i++) {
            for (let j = 0; j < grid[i].length; j++) {
                const cell = grid[i][j];
                if (cell instanceof Entry_Point) {

                    // Add new Entry_Point object to the entry_points array
                    cell.id = j + (i * grid.length);
                    grid_entry_points.push(cell);
                } else if (cell instanceof Slot) {

                    // Add new Slot object to the slots array
                    cell.id = j + (i * grid.length);
                    grid_slots.push(cell);
                }
            }
        }

        // Set distances for entry points
        grid_entry_points.forEach(entry_point => {
            entry_point.distances = grid_slots.map(slot => ({
                entry_point_id: entry_point.id,
                slot_id: slot.id,
                distance: this.calculate_distance(entry_point, slot)
            }));
        });
        this.entry_points = grid_entry_points;
        this.slots = grid_slots;
    }
    calculate_distance(entry_point, slot) {

        // Calculate the distance between the entry point and slot using the Euclidean distance formula
        const dx = entry_point.x - slot.x;
        const dy = entry_point.y - slot.y;
        const distance = Math.sqrt(dx ** 2 + dy ** 2);
        return distance;
    }
}

class Entry_Point {
    constructor(data) {
        this.id = data.entry_point_id;
        this.x = data.entry_point_x;
        this.y = data.entry_point_y;
        this.distances = []; // Empty array to store distances, will be populated in the Parking_Lot constructor
    }

    // Static function to create Entry_Point object with x and y
    static XY(x, y) {
        return new Entry_Point({
            entry_point_x: x,
            entry_point_y: y
        });
    }

    // Function to draw lines to the closest slots
    draw_distances(parking_lot, index) {
        if (index < 0) {
            return;
        }

        const slot_draw = parking_lot.slots.find(slot => slot.id === this.distances[index].slot_id);
        if (slot_draw) {

            strokeWeight(4)
            stroke(200, 200, 0); // Red color for the lines
            line(this.x * CELL_SIZE + CELL_SIZE / 2, this.y * CELL_SIZE + CELL_SIZE / 2,
                slot_draw.x * CELL_SIZE + CELL_SIZE / 2, slot_draw.y * CELL_SIZE + CELL_SIZE / 2);
            noStroke();

            // Calculate the midpoint to display the distance
            const mid_x = (this.x + slot_draw.x) / 2 * CELL_SIZE;
            const mid_y = (this.y + slot_draw.y) / 2 * CELL_SIZE;

            // Set the highlight color and draw a rectangle behind the text
            fill(0, 0, 0); // Dark color for the highlight

            // Set the font size before calling the text() function
            textSize(12);
            const padding = 5;
            const text_height = textAscent() + textDescent();
            const text_width = textWidth(this.distances[index].distance.toFixed(2));
            rect(mid_x - (text_width / 2) - (padding / 2), mid_y - (text_height / 2), text_width + (padding * 2), text_height);
            fill(255, 255, 255); // Red color for the text
            text(this.distances[index].distance.toFixed(2), mid_x, mid_y);
            noFill();
        }
    }
    get_nearest_slot_index(parking_lot, vehicle_length, vehicle_width) {

        // Initialize counters.
        let min_distance = Infinity;
        let nearest_slot_index = -1;

        // Check if vacant slots exist.
        const vacant_slots = parking_lot.slots.filter(slot => slot.vehicle_id === null);
        if (vacant_slots.length === 0) {
            return nearest_slot_index; // No vacant slots, nothing to draw
        }

        // Loop through distances
        for (let i = 0; i < this.distances.length; i++) {
            const distance_info = this.distances[i];
            const slot = parking_lot.slots.find(slot => slot.id === distance_info.slot_id);

            if (slot && slot.max_length >= vehicle_length && slot.max_width >= vehicle_width) {
                const distance = distance_info.distance;
                if (distance < min_distance && vacant_slots.includes(slot)) {
                    min_distance = distance;
                    nearest_slot_index = i;
                }
            }
        }
        return nearest_slot_index;
    }
}

class Slot {
    constructor(data) {
        this.id = data.slot_id;
        this.x = data.slot_x;
        this.y = data.slot_y;
        this.size_id = data.size_id;
        this.vehicle_id = data.vehicle_id;

        // Set vehicle
        if (data.vehicle_id) {
            this.vehicle = new Vehicle(data);
        }

        // Additional size-related fields
        this.max_length = data.max_length;
        this.max_width = data.max_width;
        this.min_hours = data.min_hours;
        this.fixed_rate = data.fixed_rate;
        this.additional_rate = data.additional_rate;
        this.day_rate = data.day_rate;
    }

    // Static function to create Entry_Point object with x and y
    static XY_Size(x, y, size_id) {
        return new Slot({
            slot_x: x,
            slot_y: y,
            size_id: size_id
        });
    }
    draw_vehicle() {
        if (this.vehicle) {
            let vehicle_img;
            const length = this.vehicle.vehicle_length;
            const width = this.vehicle.vehicle_width;

            if (this.vehicle.vehicle_length > 2 || this.vehicle.vehicle_width > 2) {
                vehicle_img = vehicle_l_img;
            } else if (this.vehicle.vehicle_length > 1 || this.vehicle.vehicle_width > 1) {
                vehicle_img = vehicle_m_img;
            } else {
                vehicle_img = vehicle_s_img;
            }

            // Draw the selected vehicle image
            image(vehicle_img, this.x * CELL_SIZE, this.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
        }
    }
}

class Vehicle {
    constructor(data) {
        this.id = data.vehicle_id;
        this.name = data.vehicle_name;
        this.vehicle_length = data.vehicle_length;
        this.vehicle_width = data.vehicle_width;
        this.record_id = data.record_id;

        // Record data.
        this.entry_datetime = data.entry_datetime;
        this.exit_datetime = data.exit_datetime;

        // Initialize an empty array to store charges
        this.charges = [];

        // Add charges to the vehicle if provided in the data
        if (data.charges && Array.isArray(data.charges)) {
            data.charges.forEach(charge_data => {
                this.add_charge(charge_data);
            });
        }
    }

    // Add a charge to the vehicle
    add_charge(charge_data) {
        const charge = new Charge(charge_data);
        this.charges.push(charge);
    }

    // Function to get the total of all charges' total_hours
    get_total_hours() {
        return this.charges.reduce((total, charge) => total + charge.total_hours, 0);
    }

    // Function to get the total of all charges' charge_value
    get_total_charge_values() {
        return this.charges.reduce((total, charge) => total + charge.charge_value, 0);
    }

    // Function to get the most recent charge with exit_datetime as null
    get_current_charge() {
        return this.charges
            .filter(charge => charge.exit_datetime === null)
            .reduce((current_charge, charge) => {
                if (!current_charge) {
                    return charge;
                }
                return charge.entry_datetime > current_charge.entry_datetime ? charge : current_charge;
            }, null);
    }
}

class Charge {
    constructor(data) {
        this.charge_value = data.charge_value;
        this.total_hours = data.total_hours;
        this.entry_datetime = data.entry_datetime;
        this.exit_datetime = data.exit_datetime;
    }
}
