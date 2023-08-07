// Vehicle_Park_State class, extending Lot_Play_State
class Vehicle_Park_State extends Lot_Play_State {
    constructor(state, entry_point_id) {
        super(); // Call the constructor of the base class (Game_State)
        this.parking_lot_id = state.parking_lot_id;
        this.show_distances = state.show_distances;
        this.simulated_datetime = state.simulated_datetime;
        this.time_stop = state.time_stop;
        this.time_speed = state.time_speed;
        this.entry_point_id = entry_point_id;
    }

    // Vehicle_Park_State specific start behavior
    start() {
        load_form('forms/vehicle_park.html', () => {
            this.load_data();
        }, 'play_output');
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

                            // Get the selected vehicle name, width, and length
                            this.vehicle_name = document.getElementById('vehicle_name');
                            this.vehicle_length = document.getElementById('vehicle_length');
                            this.vehicle_width = document.getElementById('vehicle_width');

                            // Get the vehicles that are not currently not parked at all.
                            this.button_existing = document.getElementById('button_existing');
                            this.button_new = document.getElementById('button_new');
                            this.set_vehicles();
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
    set_vehicles() {
        fetch('php_scripts/get_vehicles.php')
            .then(response => response.json())
            .then(data => {
                this.vehicle_select = document.getElementById('vehicle_select');
                this.vehicle_select.innerHTML = '';

                // Check if any vehicles are found
                if (data.length === 0) {
                    this.vehicle_select.disabled = true; // Disable the select element
                    this.button_existing.disabled = true;
                } else {
                    data.forEach(vehicle => {
                        const option = document.createElement('option');
                        option.value = vehicle.vehicle_id;
                        option.textContent = vehicle.vehicle_name + ' (' + vehicle.vehicle_length + '×' + vehicle.vehicle_width + ')';
                        this.vehicle_select.appendChild(option);
                    });
                }
                this.ready = true;
            })
            .catch(error => {
                console.error('Error loading vehicle options:', error);
                set_error('Error loading vehicle options: ' + error);
            });
    }
    park_existing() {

        // Nuke both buttons for safety
        this.set_loading_button(this.button_existing, true);
        this.set_loading_button(this.button_new, true);

        // Get the selected vehicle ID and entry point ID
        const selected_vehicle_id = this.vehicle_select.value;

        // Prepare the data to be sent in the AJAX request
        const data = {
            vehicle_id: selected_vehicle_id,
            entry_point_id: this.entry_point_id,
            entry_datetime: this.simulated_datetime
        };

        // Make an AJAX request to vehicle_park.php
        fetch('php_scripts/vehicle_park.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {

                    // Vehicle parked successfully, handle as needed
                    console.log('Vehicle parked successfully');
                    set_success(result.message);
                } else {

                    // Parking failed, handle error
                    set_error('Error parking vehicle: ' + result.message);
                    console.error('Error parking vehicle:', result.message);
                }
            })
            .catch(error => {
                console.error('Error parking vehicle:', error);
                set_error('Error parking vehicle: ' + error);
            })
            .finally(() => {
                this.set_loading_button(this.button_existing, false);
                this.set_loading_button(this.button_new, false);

                // Reload with new updated data.
                this.load_data();
            });
    }
    park_new() {

        // Nuke both buttons for safety
        this.set_loading_button(this.button_existing, true);
        this.set_loading_button(this.button_new, true);

        // Get the selected vehicle name, width, and length
        const new_vehicle_name = this.vehicle_name.value;
        const new_vehicle_width = parseFloat(this.vehicle_width.value);
        const new_vehicle_length = parseFloat(this.vehicle_length.value);

        // Prepare the data to be sent in the AJAX request
        const data = {
            vehicle_name: new_vehicle_name,
            vehicle_width: new_vehicle_width,
            vehicle_length: new_vehicle_length,
            entry_point_id: this.entry_point_id,
            entry_datetime: this.simulated_datetime
        };

        // Make an AJAX request to vehicle_park.php
        fetch('php_scripts/vehicle_park.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {

                    // Vehicle parked successfully, handle as needed
                    console.log('Vehicle parked successfully');
                    set_success(result.message);
                } else {

                    // Parking failed, handle error
                    set_error('Error parking vehicle: ' + result.message);
                    console.error('Error parking vehicle:', result.message);
                }
            })
            .catch(error => {
                set_error('Error parking vehicle: ' + error);
                console.error('Error parking vehicle:', error);
            })
            .finally(() => {
                this.set_loading_button(this.button_existing, false);
                this.set_loading_button(this.button_new, false);

                // Reload with new updated data.
                this.load_data();
            });
    }
}
