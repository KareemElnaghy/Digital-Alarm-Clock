# Digital Alarm Clock Project

Group 3 Members: Arwa Abdelkarim, Jana Elfeky, Kareem Elnaghy

## Introduction
Welcome to the Digital Alarm Clock project! This project is implemented on the BASYS3 FPGA board using Verilog HDL on Vivado software. The clock features time display, alarm functionality, and adjustable settings through the board's push buttons, LEDs, and a buzzer. This project highlights fundamental digital design concepts, including counters and finite state machines (FSM).

## Objectives
- **Time Display:** Display the current time in hours and minutes on a 7-segment display.
- **Alarm Functionality:** Allow setting of an alarm time, which activates a buzzer and a blinking LED when the set time is reached.
- **Adjustable Settings:** Enable user adjustments for both the current time and the alarm time using push buttons.
- **Mode Operation:** Switch between "clock/alarm" mode and "adjust" mode, with visual and audible indicators (LEDs and buzzer).

## Components
- **BASYS3 FPGA Board:** Primary hardware platform.
- **Vivado** Software used for HDL designs.
- **7-Segment Display:** Used for displaying hours and minutes.
- **LEDs (LD0, LD12, LD13, LD14, LD15):** Indicators for different states and modes.
- **Push Buttons (BTNC, BTNU, BTND, BTNL, BTNR):** Used for mode switching and adjusting time.

## Operating Modes
### Clock/Alarm Mode
- **Default Operating Mode.**
- **LD0:** Off.
- **Decimal Point Blinking:** The second decimal point from the left blinks at 1Hz to indicate the clock is running.
- **Alarm Activation:** When the current time matches the alarm time, LD0 blinks and the buzzer sounds until any button is pressed.

### Adjust Mode
- **Activated by pressing BTNC.**
- **LD0:** On.
- **Decimal Point:** Does not blink.
- **Push Buttons Functionality:**
  - **BTNR:** Cycle through parameters in the order: "alarm minute", "alarm hour", "time minute", "time hour".
  - **BTNL:** Cycle backward through the parameters.
  - **BTNU:** Increment the selected parameter.
  - **BTND:** Decrement the selected parameter.
- **LED Indicators:** LD12 (time hour), LD13 (time minute), LD14 (alarm hour), LD15 (alarm minute).
- **Exit Adjust Mode:** Press BTNC again to return to "clock/alarm" mode.

## User Guide
### Hardware Setup
1. **Power Up:** Connect the BASYS3 board to a power source and turn it on.
2. **Initial Display:** The 7-segment display shows the time in HH:MM format, starting from 00:00 up to 23:59.

### Operating the Clock
1. **Clock/Alarm Mode:**
   - **Default State:** The clock shows the current time. LD0 is off.
   - **Blinking Decimal Point:** Blinks at a 1Hz frequency.
   - **Alarm Trigger:** When the current time matches the alarm time, LD0 blinks at 1Hz and the buzzer sounds at 5Hz. Press any button to stop the blinking.
   
2. **Adjusting the Time and Alarm:**
   - **Press BTNC:** Switch to "adjust" mode. LD0 turns on and the blinking decimal point stops.
   - **Selecting Parameters:** Use BTNL and BTNR to cycle through parameters.
   - **Adjusting Parameters:** Use BTNU to increment and BTND to decrement the selected parameter.
   - **Exiting Adjust Mode:** Press BTNC to return to "clock/alarm" mode.

## Code Overview
The Verilog code is divided into multiple modules, with key modules including:

1. **counter_x_bit:** Simulates an up-down counter.
2. **pushButtonDetector:** Ensures reliable and debounced input signals from push buttons.
3. **clockDivider:** Divides the input clock frequency.
4. **alarmHourMinCounter:** Handles the alarm time display and adjustments.
5. **minSecHourCount:** Manages counting seconds, minutes, and hours.
6. **SevenSegDecWithEn:** Drives the seven-segment display.
7. **digitalClock:** Main module integrating all functionalities including finite state machine.

## Implementation Bugs and Validation Activities
### Implementation Bugs
- **Random Counter Increments:** Fixed by correcting enable signal assignments.
- **Clock Counter Changes During Alarm Adjustment:** Introduced a flag to differentiate between adjusting the alarm and normal clock.
- **Unable to Exit Alarm State Immediately:** Adjusted conditions for entering the alarm state.
- **Incorrect Display Switching:** Redesigned multiplexor outputs to ensure proper data display.

### Validation Activities
- **Functional Simulation:** Using Logisim Evolution.
- **Incremental Testing:** Of individual components and real-time testing on the BASYS3 FPGA board.
- **Boundary Testing:** Verified correct time transitions and alarm functionality.
- **User Interface Validation:** Tested push buttons for correct mode switches and parameter adjustments.
- **Debugging Sessions:** Identified and fixed potential issues.
- **Clock Accuracy Verification:** Compared the FPGA clock against a reference digital clock over a prolonged period.

## Contributions
- [Arwa Abdelkarim](https://github.com/arwaabdelkarim) Logisim simulation, SevenSegDecWithEn module, minSecHourCount, alarmHourMinCounter, LED assignments.
- [Jana ElFeky](https://github.com/JanaElfeky) Alarm-related functionalities, state transitions, debugging.
- [Kareem Elnaghy](https://github.com/KareemElnaghy)  Datapath and control unit design, FSM states, constraint file development, up/down counter module, debugging.



