// Lot_Edit_State class, extending Game_State
class Lot_Edit_State extends Game_State {
    constructor(parking_lot_id) {
        super(); // Call the constructor of the base class (Game_State)
        this.parking_lot_id = parking_lot_id;
        this.distance_interval = 15;
        this.current_index = 0;
    }

    // Lot_Edit_State specific start behavior
    start() {
        load_form('forms/lot_edit.html', () => {
            this.load_data();
        });
    }
    load_data() {

        // Get parking lot data using this.parking_lot_id
        fetch(`php_scripts/vehicle_check.php?parking_lot_id=${this.parking_lot_id}`)
            .then(response => response.json())
            .then(result => {

                // Handle the response from the server (if needed)
                if (result.success) {
                    this.set_parking_lot();
                } else {
                    set_error(result.message);
                }
            })
            .catch(error => {
                console.error('Error fetching parking lot data:', error);
                set_error('Error fetching parking lot data: ' + error);
            });
    }
    set_parking_lot() {

        // Get parking lot data using this.parking_lot_id
        fetch(`php_scripts/get_parking_lot.php?parking_lot_id=${this.parking_lot_id}`)
            .then(response => response.json())
            .then(data => {

                // Create a new Parking_Lot instance with the fetched data
                this.parking_lot = new Parking_Lot(data);

                // Set the dropdown and other UI elements using the parking lot data
                this.initialize_parking_lot(this.parking_lot);
                this.radio_buttons = document.getElementsByName('grid_mode');
                this.name_input = document.getElementById('parking_lot_name');
                this.name_input.value = this.parking_lot.name;
                this.distance_toggle = document.getElementById('distance_toggle');
                this.button = document.getElementById('button_save');
                this.ready = true;
            })
            .catch(error => {
                console.error('Error fetching parking lot data:', error);
                set_error('Error fetching parking lot data: ' + error);
            });
    }

    // Lot_Edit_State specific execute behavior
    execute() {
        this.draw_parking_lot();
        this.draw_distances();

    }
    draw_distances() {
        if (this.show_distances) {

            // Draw distance lines.
            this.parking_lot.entry_points.forEach(entry_point => {

                // Call the draw_distances function to draw lines and distances
                entry_point.draw_distances(this.parking_lot, this.current_index);
            });

            // Increment index every interval frames
            if (frameCount % this.distance_interval === 0) {
                this.current_index = (this.current_index + 1) % this.parking_lot.slots.length;
            }
        }
    }
    mouse_pressed() {
        let i = floor(mouseY / CELL_SIZE);
        let j = floor(mouseX / CELL_SIZE);

        if (i >= 0 && i < ROWS && j >= 0 && j < COLS) {

            // Set grid[i][j] with the corresponding object based on the selected option
            if (this.get_selected() === 'E') {
                grid[i][j] = Entry_Point.XY(j, i); // Swap x and y here to match grid indices
            } else if (this.get_selected() === 'S') {
                grid[i][j] = Slot.XY_Size(j, i, 1); // Swap x and y here to match grid indices, and size_id 'S' for Small Slot
            } else if (this.get_selected() === 'M') {
                grid[i][j] = Slot.XY_Size(j, i, 2); // Swap x and y here to match grid indices, and size_id 'M' for Medium Slot
            } else if (this.get_selected() === 'L') {
                grid[i][j] = Slot.XY_Size(j, i, 3); // Swap x and y here to match grid indices, and size_id 'L' for Large Slot
            } else {

                // If none is selected, set grid[i][j] to null to represent an empty cell
                grid[i][j] = null;
            }
        }
        this.current_index = 0;
        this.parking_lot.GRID(grid);
    }
    get_selected() {
        let selected_value = null;
        for (const radio_button of this.radio_buttons) {
            if (radio_button.checked) {
                selected_value = radio_button.value;
                break; // Found the checked value, no need to continue checking
            }
        }
        return selected_value;
    }
    save_lot() {

        // Nuke Button
        this.set_loading_button(this.button, true);

        // Get the updated parking lot name from the input field
        const parking_lot_name = this.name_input.value;
        const entry_points = [];
        const slots = [];
        for (let i = 0; i < ROWS; i++) {
            for (let j = 0; j < COLS; j++) {
                const cell = grid[i][j];
                if (cell instanceof Entry_Point) {

                    // Entry point
                    entry_points.push(cell);
                } else if (cell instanceof Slot) {

                    // Parking slots
                    slots.push(cell);
                }
            }
        }

        // Prepare the data to be sent in the AJAX request
        const data = {
            parking_lot_id: this.parking_lot_id,
            parking_lot_name: parking_lot_name,
            entry_points: JSON.stringify(entry_points),
            slots: JSON.stringify(slots)
        };

        // Make an AJAX request to save_parking_lot.php
        fetch('php_scripts/save_parking_lot.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json()).then(result => {

                // Handle the response from the server (if needed)
                console.log(result);
                if (result.success) {
                    set_success(result.message);
                } else {
                    set_error(result.message);
                }
            })
            .catch(error => {
                console.error('Error saving parking lot:', error);
                set_error('Error saving parking lot: ' + error);
            })
            .finally(() => {
                this.set_loading_button(this.button, false);

                // Reload with new updated data.
                this.load_data();
            });
    }
}
