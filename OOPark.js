let ROWS = 15;
let COLS = 15;
let CELL_SIZE = 50;
let grid = [];
let state; // Variable to store the current state object

// Initialize error message container
let error_div;
let success_div;

function preload() {

    // Load the PNG images
    empty_img = loadImage('sprites/empty.png');
    entry_point_img = loadImage('sprites/entry_point.png');
    slot_s_img = loadImage('sprites/slot_s.png');
    slot_m_img = loadImage('sprites/slot_m.png');
    slot_l_img = loadImage('sprites/slot_l.png');
    vehicle_s_img = loadImage('sprites/vehicle_s.png');
    vehicle_m_img = loadImage('sprites/vehicle_m.png');
    vehicle_l_img = loadImage('sprites/vehicle_l.png');
    cursor_img = loadImage('sprites/cursor.png');
    home_gif = loadImage('sprites/home.gif');
}

function setup() {
    createCanvas(COLS * CELL_SIZE, ROWS * CELL_SIZE).parent('canvas-container');
    frameRate(30); // Set FPS to 30

    // Initialize error message container
    error_div = document.getElementById('error_output');
    success_div = document.getElementById('success_output');

    // Initialize the current State to Home_State
    state = new Home_State();
    state.start();
    state.ready = true;
}

function draw() {

    // Call the execute method of the current state
    if (state.ready) {
        state.execute();
    } else {
        draw_loading();
    }
}

function mousePressed() {
    if (!(state === undefined) && state.ready) {
        state.mouse_pressed();
    }
}

function load_form(form_name, callback, output_id = 'output') {
    clear_messages();
    fetch(form_name)
        .then((response) => response.text())
        .then((html) => {
            document.getElementById(output_id).innerHTML = html;
            callback(); // Call the callback function once the form is loaded
        })
        .catch((error) => {
            console.error('Error loading form:', error);
            set_error('Error loading form: ' + error);
        });
}

// Function to change the state
function set_state(new_state) {
    state.ready = false;
    state.end(); // Call the end method of the current state
    state = new_state; // Change the current state to the new state
    state.start(); // Call the start method of the new state
}

function home() {
    set_state(new Home_State());
}

// Update the error's text value
function set_error(message) {
    error_div.innerText = message;
    error_div.style.display = message ? 'block' : 'none';
    if (message) {
        set_success();
    }
}

function clear_messages() {
    set_error();
}

function set_success(message) {
    success_div.innerText = message;
    success_div.style.display = message ? 'block' : 'none';
    if (message) {
        set_error();
    }
}

let loading_angle = 0;
let loading_text = "Loading...";

function draw_loading() {
    translate(width / 2, height / 2);
    rotate(loading_angle);
    stroke(255);
    strokeWeight(4);
    line(0, 0, 40, 0);
    loading_angle += 0.1;

    textSize(24);
    textAlign(CENTER, CENTER);
    text(loading_text, 0, 60);

    if (frameCount % 60 === 0) {
        loading_text += ".";
        if (loading_text.length > 15) {
            loading_text = "Loading.";
        }
    }
}
