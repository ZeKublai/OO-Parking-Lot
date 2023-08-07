# Object-Oriented Mall Parking Allocation System

![Object-Oriented Mall](mall_image.jpg)

## Introduction

Welcome to the Object-Oriented Mall Parking Allocation System, a project developed for Ayala Corp. to streamline parking management for their new malling complex, the Object-Oriented Mall. This system allows efficient allocation of parking spaces, convenient vehicle entry and exit, and accurate tracking of parking records.

## Setup

- XAMPP 8.2.4-0 via xampp-windows-x64-8.2.4-0-VS16-installer.exe
- Processing 4.3 via p5.js
- PHP Version 8.2.4
- Tested on Windows 10

## Features

- Manage up to 5 parking lots with customizable entry points and slot sizes.
- Provides small, medium, and large parking slots.
- Supports virtually unlimited entry points within the grid limit.
- Park and unpark vehicles using a simulated date and time.
- Integrated database implementation for accurate record-keeping.
- Nearest slot viewer assists with parking allocation decisions.
- Basic p5.js UI enhanced with Bootstrap theming.

## Installation

1. Clone the repository: `git clone https://github.com/ZeKublai/OO-Parking-Lot.git`
2. Set up your XAMPP environment and ensure Apache and MySQL services are running.
3. Import the provided SQL database backup (`db_export/db_backup.sql`) into your MySQL database.
4. Configure the database connection settings in `utils.php`.

## Usage

1. Access the project through your web browser: `http://localhost/OOPark/`.
2. Home Page:
   - Edit Mode: Customize parking lot's entry points, slots, or rename the parking lot.
   - Play Mode: Park and unpark vehicles using simulated time.
   - Reset Records: Wipe parking lot's records and reset total earnings to 0 (entry points and slots remain).

3. Play Mode:
   - Simulated Time: Input the date and time to override simulated time. Play/pause button controls time progression. Clock speed slider adjusts simulation speed.
   - Show Nearest Vacant Slot: Set vehicle dimensions to visualize the nearest available slot.
   - Parking: Click on an entry point to park a vehicle. Select existing vehicle from the database or add a new one (with a cool name!).
   - Unparking: Click on a parked vehicle to view estimated costs and parking duration. Unpark to receive fictional currency.

## Limitations and Possible Improvements

- The parking lot size is currently limited to 15x15 due to UI constraints, but the database can handle larger sizes.
- Potential UI enhancements and functionalities, such as adding/deleting parking lots, vehicle management, and comprehensive parking record viewing.
- Backend script complexity could be improved with OOP data containers, especially if more features are added in the future.

Feel free to explore and contribute to make this parking allocation system even better!