// Vehicle_Unpark_State class, extending Lot_Play_State
class Vehicle_Unpark_State extends Lot_Play_State {
    constructor(state, slot_id, vehicle_id) {
        super(); // Call the constructor of the base class (Game_State)
        this.parking_lot_id = state.parking_lot_id;
        this.show_distances = state.show_distances;
        this.simulated_datetime = state.simulated_datetime;
        this.time_stop = state.time_stop;
        this.time_speed = state.time_speed;
        this.slot_id = slot_id;
        this.vehicle_id = vehicle_id;
    }

    // Vehicle_Unpark_State specific start behavior
    start() {
        load_form('forms/vehicle_unpark.html', () => {
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
                            this.set_parking_record();
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
    set_parking_record() {
        fetch(`php_scripts/get_parking_record.php?slot_id=${this.slot_id}&vehicle_id=${this.vehicle_id}&parking_lot_id=${this.parking_lot_id}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {

                    // Parking record retrieved successfully, handle as needed
                    console.log('Parking record retrieved successfully');
                    this.button_unpark = document.getElementById('button_unpark');

                    // Create a new Slot object with the retrieved data
                    this.slot = new Slot(data.data);

                    this.vehicle_name = document.getElementById('vehicle_name');
                    this.vehicle_entry_datetime = document.getElementById('vehicle_entry_datetime');
                    this.previous_hours = document.getElementById('previous_hours');
                    this.previous_charges = document.getElementById('previous_charges');
                    this.charge_entry_datetime = document.getElementById('charge_entry_datetime');
                    this.parking_time_breakdown = document.getElementById('parking_time_breakdown');
                    this.estimated_fixed_cost = document.getElementById('fixed_cost');
                    this.estimated_additional_costs = document.getElementById('additional_costs');
                    this.estimated_day_costs = document.getElementById('day_costs');
                    this.estimated_total = document.getElementById('estimated_total');
                    this.update_ui();
                    this.ready = true;
                } else {

                    // Retrieving parking record failed, handle error
                    console.error('Error getting parking record:', data.error);
                }
            })
            .catch(error => {
                console.error('Error getting parking record:', error);
            });
    }
    update_datetime() {
        super.update_datetime();
        this.update_ui();
    }
    update_ui() {

        // Update vehicle name
        this.vehicle_name.textContent = this.slot.vehicle.name;

        // Format entry date & time
        const formatted_entry_datetime = new Date(this.slot.vehicle.entry_datetime).toLocaleString();
        this.vehicle_entry_datetime.textContent = `First Entry Date & Time: ${formatted_entry_datetime}`;

        // Previous data.
        this.previous_hours.textContent = `${this.slot.vehicle.get_total_hours()} Hours`;
        this.previous_charges.textContent = `₱ ${this.slot.vehicle.get_total_charge_values().toLocaleString()}`;

        // Update breakdown and estimated total
        const formatted_charge_entry_datetime = new Date(this.slot.vehicle.get_current_charge().entry_datetime).toLocaleString();
        this.charge_entry_datetime.textContent = `${formatted_charge_entry_datetime}`;
        const breakdown = this.get_breakdown();
        this.parking_time_breakdown.textContent = `${breakdown}`;
        this.set_estimated_total();
        this.estimated_fixed_cost.textContent = `₱ ${this.fixed_cost.toLocaleString()}`;
        this.estimated_additional_costs.textContent = `(${this.additional_hours}×${this.slot.additional_rate.toLocaleString()}) = ₱ ${this.additional_costs.toLocaleString()}`;
        this.estimated_day_costs.textContent = `(${this.days}×${this.slot.day_rate.toLocaleString()}) = ₱ ${this.day_costs.toLocaleString()}`;
        this.estimated_total.textContent = `₱ ${this.total_cost.toLocaleString()}`;
    }
    get_breakdown() {
        const date_entry = new Date(this.slot.vehicle.get_current_charge().entry_datetime);
        const date_exit = new Date(this.simulated_datetime);

        // Check if simulated datetime is before entry datetime
        if (date_exit < date_entry) {
            this.hours = 0;
            this.days = 0;
            return `N/A`; // Return false if the simulated datetime is before entry datetime
        }

        const time_difference = date_exit - date_entry;

        // Calculate the number of days and remaining milliseconds
        this.days = Math.floor(time_difference / (1000 * 60 * 60 * 24));
        const remaining_millis = time_difference % (1000 * 60 * 60 * 24);

        // Calculate the number of hours
        if (remaining_millis === 0) {
            this.hours = 0;
        } else {
            this.hours = Math.ceil(remaining_millis / (1000 * 60 * 60));
            if (this.hours === 24) {
                this.days += 1;
                this.hours = 0;
            }
        }
        return `${this.days} day${this.days !== 1 ? 's' : ''} and ${this.hours} hour${this.hours !== 1 ? 's' : ''}`;
    }
    set_estimated_total() {
        this.total_cost = 0;
        this.fixed_hours = 0;
        this.fixed_cost = 0;
        this.additional_hours = 0;
        this.additional_costs = 0;
        this.day_costs = 0;

        // Return 0 if 0 days and 0 hours
        if (this.hours == 0 && this.days == 0) {
            return 0;
        }

        // Set cost for the initial min hours
        this.fixed_cost = this.slot.fixed_rate;
        this.fixed_hours = this.slot.min_hours;

        // No need to pay fixed cost if previous hours already paid for it.
        if (this.slot.vehicle.get_total_hours() >= this.slot.min_hours) {
            this.fixed_cost = 0;
            this.fixed_hours = 0;
        } else {

            // Pay for the difference if the fixed rate is higher for the current slot.
            this.fixed_cost = Math.max(0, this.slot.fixed_rate - this.slot.vehicle.get_total_charge_values());
            this.fixed_hours = Math.max(0, this.slot.min_hours - this.slot.vehicle.get_total_hours());
        }

        // Get initial addtional hours
        this.additional_hours = Math.max(0, (this.days * 24 + this.hours) - this.fixed_hours);

        // Apply pentaly if exceeds 24 hours
        if (this.days > 0) {
            this.day_costs = this.days * this.slot.day_rate;
        }
        this.additional_costs = this.additional_hours * this.slot.additional_rate;
        this.total_cost = this.day_costs + this.additional_costs + this.fixed_cost;
    }
    eject_vehicle() {

        // Nuke button for safety
        this.set_loading_button(this.button_unpark, true);

        // Prepare the data to be sent in the AJAX request
        const data = {
            slot_id: this.slot_id,
            vehicle_id: this.vehicle_id,
            parking_lot_id: this.parking_lot_id,
            exit_datetime: this.simulated_datetime
        };

        // Make an AJAX request to vehicle_park.php
        fetch('php_scripts/vehicle_unpark.php', {
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
                    console.log('Vehicle exited successfully');
                    set_success(result.message);
                    this.main_state();
                } else {

                    // Parking failed, handle error
                    set_error('Error ejecting vehicle: ' + result.message);
                    console.error('Error ejecting vehicle:', result.message);

                    // Reload with new updated data.
                    this.set_loading_button(this.button_unpark, false);
                    this.load_data();
                }
            })
            .catch(error => {
                console.error('Error ejecting vehicle:', error);
                set_error('Error ejecting vehicle: ' + error);

                // Reload with new updated data.
                this.set_loading_button(this.button_unpark, false);
                this.load_data();
            })
            .finally(() => {

            });
    }
}
