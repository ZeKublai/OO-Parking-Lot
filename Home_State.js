// Grid_Edit_State class, extending Game_State
class Home_State extends Game_State {
    constructor() {
        super(); // Call the constructor of the base class (Game_State)
    }

    start() {
        load_form('forms/home.html', () => {

            // This function will be called once the form is loaded
            fetch('php_scripts/get_parking_lots.php').then(response => response.json()).then(data => {

                    // Loop through the data and create list items
                    let list_container = document.getElementById('parking_lot_list');
                    data.forEach(item => {
                        this.add_list_item(list_container, item);
                        this.ready = true;
                    });
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                    set_error('Error fetching data: ' + error);
                });
        });
    }
    execute() {
        background(86);
        
        // Calculate the center coordinates for the GIF
        let x = (canvas.width - home_gif.width) / 2;
        let y = (canvas.height - home_gif.height) / 2;
      
        // Display the GIF at the center
        image(home_gif, x, y);
    }
    mouse_pressed() {

    }
    edit_lot(parking_lot_id) {
        set_state(new Lot_Edit_State(parking_lot_id));
    }
    play_lot(parking_lot_id) {
        set_state(new Lot_Play_State(parking_lot_id));
    }
    reset_records(parking_lot_id) {
        const reset_data = {
            parking_lot_id: parking_lot_id
        };

        fetch('php_scripts/reset_parking_records.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(reset_data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {

                    // Reset successful, perform any UI update if needed
                    console.log('Parking records reset successfully');
                    set_success(data.message);
                    this.start();
                } else {

                    // Reset failed, handle error
                    console.error('Error resetting parking records:', data.message);
                    set_error('Error resetting parking records: ' + error);
                }
            })
            .catch(error => {
                console.error('An error occurred:', error);
                set_error('An error occurred: ' + error);
            });
    }
    add_list_item(list_container, item) {

        // Create list item.
        const list_item = document.createElement('div');
        list_item.className = 'list-group-item list-group-item-action';
        list_item.setAttribute('aria-current', 'true');

        // Check if buttons is allowed.
        let buttons = ``;
        if (item.empty == 'true') {
            buttons += `<button type="button" class="btn btn-info" onclick="state.edit_lot(${item.parking_lot_id})">Edit</button>`;
        }
        if (item.entry_point_count >= 3 && item.slot_count > 0) {
            buttons += `<button type="button" class="btn btn-primary" onclick="state.play_lot(${item.parking_lot_id})">Play</button>`;
        }
        buttons += `
      <button type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
        Reset<br>Records
      </button>
      <ul class="dropdown-menu">
        <li class="dropdown-item" onclick="state.reset_records(${item.parking_lot_id})">Confirm Reset</li>
      </ul>    
    `;

        // Set innerHTML.
        list_item.innerHTML = `
      <div class="row">
        <div class="col">
          <div class="d-flex w-100 justify-content-between">
            <h5 class="mt-1">${item.parking_lot_name}</h5>
          </div>
          <p class="mb-1">Total Earnings: ₱ ${parseInt(item.total_earnings).toLocaleString()}</p>
        </div>
        <div class="col d-flex justify-content-between">
          <div class="btn-group w-100" role="group" aria-label="Basic example">${buttons}</div>
        </div>
      </div>
    `;
        list_container.appendChild(list_item);
    }
}
