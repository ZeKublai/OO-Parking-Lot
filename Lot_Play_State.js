// Lot_Play_State class, extending Game_State
class Lot_Play_State extends Game_State {
    constructor(parking_lot_id, last_state = undefined) {
        super(); // Call the constructor of the base class (Game_State)
        if (last_state === undefined) {
            this.parking_lot_id = parking_lot_id;
            this.simulated_datetime = new Date().getTime();
            this.time_stop = true;
            this.time_speed = 0;
        } else {
            this.parking_lot_id = last_state.parking_lot_id;
            this.show_distances = last_state.show_distances;
            this.simulated_datetime = last_state.simulated_datetime;
            this.time_stop = last_state.time_stop;
            this.time_speed = last_state.time_speed;
            this.last_state = true;
        }
    }

    // Lot_Play_State specific start behavior
    start() {
        if (this.last_state) {
            this.load_data();
            return;
        }
        load_form('forms/lot_play.html', () => {
            this.load_data();
        });
    }
    load_data() {
        // Check if parking lot meets requirements
        fetch(`php_scripts/lot_check.php?parking_lot_id=${this.parking_lot_id}`)
            .then(response => response.json())
            .then(result => {

                // Handle the response from the server (if needed)
                if (result.success) {

                    // Get parking lot data using this.parking_lot_id
                    fetch(`php_scripts/get_parking_lot.php?parking_lot_id=${this.parking_lot_id}`)
                        .then(response => response.json())
                        .then(data => {

                            this.initialize_elements(data);
                            this.update_datetime();

                            load_form('forms/charge_list.html', () => {
                                this.total_earnings = document.getElementById('total_earnings');
                                this.total_earnings.textContent = `₱ ${parseInt(this.parking_lot.total_earnings).toLocaleString()}`;
                                this.set_charges();
                                this.ready = true;
                            }, 'play_output');
                        })
                        .catch(error => {
                            console.error('Error fetching parking lot data:', error);
                            set_error('Error fetching parking lot data: ' + error);
                        });
                } else {
                    set_error(result.message);
                }
            })
            .catch(error => {
                console.error('Error fetching parking lot data:', error);
                set_error('Error fetching parking lot data: ' + error);
            });
    }
    set_charges() {
        fetch(`php_scripts/get_charges.php?parking_lot_id=${this.parking_lot_id}`)
            .then(response => response.json())
            .then(data => {

                // Loop through the data and create list items
                let list_container = document.getElementById('charge_list');
                data.data.forEach(charge => {
                    this.add_charge_item(list_container, charge);
                });
            })
            .catch(error => {
                console.error('Error fetching charges:', error);
                set_error('Error fetching charges: ' + error);
            });
    }
    add_charge_item(container, charge) {
        const list_item = document.createElement('li');
        list_item.className = 'list-group-item';
        const formatted_entry_datetime = new Date(charge.entry_datetime).toLocaleString();

        let formatted_exit_datetime = 'N/A';
        if (charge.exit_datetime) {
            formatted_exit_datetime = new Date(charge.exit_datetime).toLocaleString();
        } else {
            list_item.className += ' text-bg-danger';
        }

        list_item.innerHTML = `
      <h5 class="card-title">${charge.vehicle_name}</h5>
      <h6 class="card-subtitle mb-2">${formatted_entry_datetime} to ${formatted_exit_datetime}</h6>
      <em>
        <div class="row">
          <div class="col">Total Hours:</div>
          <div class="col text-end" id="parking_time_breakdown">${charge.total_hours}</div>
        </div>
      </em>
      <strong>
        <div class="row">
          <div class="col">Total Charge:</div>
          <div class="col text-end">₱ ${charge.charge_value.toLocaleString()}</div>
        </div>
      </strong>
    `;
        container.appendChild(list_item);
    }
    initialize_elements(data) {

        // Create a new Parking_Lot instance with the fetched data
        this.parking_lot = new Parking_Lot(data);

        // Set the dropdown and other UI elements using the parking lot data
        this.initialize_parking_lot(this.parking_lot);

        this.time_output = document.getElementById('time_output');
        this.date_input = document.getElementById('date_input');
        this.time_input = document.getElementById('time_input');

        this.time_speed = document.getElementById('time_speed').value;
        this.time_stop_toggle = document.getElementById('time_stop_toggle');

        this.slot_length = document.getElementById('slot_length');
        this.slot_width = document.getElementById('slot_width');
        this.distance_toggle = document.getElementById('distance_toggle');

        this.set_distances_button();
        this.set_time_stop_button();
    }

    // Lot_Play_State specific execute behavior
    execute() {
        this.draw_parking_lot();
        this.draw_vehicles();
        this.draw_cursor();
        this.draw_distances();

        // Update time.
        this.update_datetime();
    }
    draw_distances() {

        // Show distance if toggled on.
        if (this.show_distances) {

            // Draw distance lines.
            this.parking_lot.entry_points.forEach(entry_point => {

                // Call the draw_distances function to draw lines and distances
                entry_point.draw_distances(this.parking_lot, entry_point.get_nearest_slot_index(
                    this.parking_lot, this.slot_length.value, this.slot_width.value
                ));
            });
        }
    }
    draw_cursor() {
        if (this.entry_point_id) {

            // Entry point
            const entry_point = this.parking_lot.entry_points.find(entry_point => entry_point.id === this.entry_point_id);
            image(cursor_img, entry_point.x * CELL_SIZE, entry_point.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
        }
        if (this.vehicle_id) {

            // Slot
            const slot = this.parking_lot.slots.find(slot => slot.vehicle_id === this.vehicle_id);
            image(cursor_img, slot.x * CELL_SIZE, slot.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
        }
    }
    draw_vehicles() {

        // Loop through slots and access slot and vehicle data
        this.parking_lot.slots.forEach(slot => {
            if (slot.vehicle) {
                slot.draw_vehicle();
            }
        });
    }
    mouse_pressed() {
        let i = floor(mouseY / CELL_SIZE);
        let j = floor(mouseX / CELL_SIZE);
        if (i >= 0 && i < ROWS && j >= 0 && j < COLS) {
            const cell = grid[i][j];
            if (cell instanceof Entry_Point) {
                this.park_vehicle(this.parking_lot_id, cell.id);
            } else if (cell instanceof Slot && cell.vehicle) {
                this.unpark_vehicle(cell.id, cell.vehicle_id);
            } else if (this instanceof Vehicle_Park_State || this instanceof Vehicle_Unpark_State) {
                this.main_state();
            }
        }
    }

    // Time Functions
    set_date_time() {
        let new_datetime = new Date(this.date_input.value + " " + this.time_input.value);

        // Check if the new_datetime is a valid date
        if (isNaN(new_datetime.getTime())) {

            // Set a default date and time
            new_datetime = new Date(); // Current date and time

            // Format the date and time components manually
            const formatted_date = `${new_datetime.getFullYear()}-${(new_datetime.getMonth() + 1).toString().padStart(2, '0')}-${new_datetime.getDate().toString().padStart(2, '0')}`;
            const formatted_time = `${new_datetime.getHours().toString().padStart(2, '0')}:${new_datetime.getMinutes().toString().padStart(2, '0')}`;

            this.date_input.value = formatted_date;
            this.time_input.value = formatted_time;
        }
        new_datetime = new Date(this.date_input.value + " " + this.time_input.value);
        this.simulated_datetime = new_datetime.getTime();
        this.time_output.textContent = new_datetime.toLocaleString();
    }
    set_clock_speed(speed_value) {
        this.time_speed = speed_value;
    }
    toggle_time_stop() {
        this.time_stop = !this.time_stop;
        this.time_stop_toggle.value = this.time_stop;
        this.set_time_stop_button();
    }
    set_time_stop_button() {
        if (this.time_stop) {
            this.time_stop_toggle.classList.remove('btn-danger');
            this.time_stop_toggle.classList.add('btn-light');
            this.time_stop_toggle.innerHTML = `Play`;
        } else {
            this.time_stop_toggle.classList.remove('btn-light');
            this.time_stop_toggle.classList.add('btn-danger');
            this.time_stop_toggle.innerHTML = `Pause`;
        }
    }
    update_datetime() {
        if (this.time_stop == false) {
            this.simulated_datetime += this.time_speed * this.time_speed * 1000;
        }
        const new_datetime = new Date(this.simulated_datetime);
        this.time_output.textContent = new_datetime.toLocaleString();
    }

    // Vehicle State Functions
    park_vehicle(parking_lot_id, entry_point_id) {
        set_state(new Vehicle_Park_State(this, entry_point_id));
    }
    unpark_vehicle(slot_id, vehicle_id) {
        set_state(new Vehicle_Unpark_State(this, slot_id, vehicle_id));
    }
    main_state() {
        set_state(new Lot_Play_State(this.parking_lot_id, this));
    }
}
