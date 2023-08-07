// Base Game_State class
class Game_State {
    constructor() {
        this.ready = false;
        this.show_distances = false;
    }

    // Default Behaviors
    start() {}
    execute() {}
    end() {}
    mouse_pressed() {}

    // Shared Utility Functions
    initialize_parking_lot(parking_lot) {
        grid = [];
        for (let i = 0; i < ROWS; i++) {
            let row = [];
            for (let j = 0; j < COLS; j++) {
                row.push(null); // NULL represents an empty cell
            }
            grid.push(row);
        }

        // Add Entry_Point objects to the grid
        for (const entry_point of parking_lot.entry_points) {
            const {
                x,
                y
            } = entry_point;
            grid[y][x] = entry_point;
        }

        // Add Slot objects to the grid
        for (const slot of parking_lot.slots) {
            const {
                x,
                y
            } = slot;
            grid[y][x] = slot;
        }
    }
    draw_parking_lot() {
        background(86);
        for (let i = 0; i < ROWS; i++) {
            for (let j = 0; j < COLS; j++) {
                const cell = grid[i][j];
                if (cell instanceof Entry_Point) {

                    // Entry point
                    image(entry_point_img, j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
                } else if (cell instanceof Slot) {

                    // Parking slots
                    if (cell.size_id === 1) {
                        image(slot_s_img, j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
                    } else if (cell.size_id === 2) {
                        image(slot_m_img, j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
                    } else if (cell.size_id === 3) {
                        image(slot_l_img, j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
                    }
                } else {

                    // Empty
                    image(empty_img, j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
                }
            }
        }
    }
    set_loading_button(button, loading) {
        if (loading) {
            button.disabled = true;
            button.innerHTML = `
        <span class="spinner-border spinner-border-sm"></span>
        <span role="status">Loading...</span>
      `;
        } else {
            button.disabled = false;
            button.innerHTML = button.getAttribute('data-original-text');
        }
    }
    toggle_distances() {
        this.show_distances = !this.show_distances;
        this.set_distances_button();
    }
    set_distances_button() {

        // Check the value of this.show_distances and update the class accordingly
        if (this.show_distances) {
            this.distance_toggle.classList.remove('btn-outline-info');
            this.distance_toggle.classList.add('btn-info');
            this.distance_toggle.innerHTML = `<img src="./sprites/distance_lines_enabled.svg" class="icon-link icon-link-hover" style="color: white;" width="25" height="25">`;
        } else {
            this.distance_toggle.classList.remove('btn-info');
            this.distance_toggle.classList.add('btn-outline-info');
            this.distance_toggle.innerHTML = `<img src="./sprites/distance_lines_disabled.svg" class="icon-link icon-link-hover" style="color: white;" width="25" height="25">`;
        }
    }
}
