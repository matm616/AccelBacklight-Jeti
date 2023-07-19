# AccelBacklight
Using the built in accelerometer on some Jeti TXs, such as the DS-12, this script allows you to turn on the backlight just by tilting the TX.

## Requirements
- Jeti TX
- Aceelerometer module
- Space for another user application

## Installation
1. Download `AccelBacklight.lua` from this repo and move it into `/Apps/` on the radio's SD card
2. Go to `Main Menu` > `Applications` > `User Applications` then add the downloaded script

## Configuration
There are 4 configurable settings that can be adjusted under `Main Menu` > `Applications` > `Accel. Backlight Config`
- Activation Angle
  The angle at which the backlight should switch from "idle" to "active" (Turn on)
- Idle Backlight Mode
  The mode the backlight should be on when less than the "Activation Angle"
- Active Backlight Mode
  The mode the backlight should be on when more than the "Activation Angle"
- Print to Console
  Whether to print to console whenever the switching form idle to active and vice versa along with a time stamp. 
  Really just there for testing