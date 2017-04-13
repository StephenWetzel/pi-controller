pi-controller
=========

## Intro
Uses a Raspberry Pi to control devices.  The idea here is to create a basic API that will relay commands to Raspberry Pis.  The Pis are have their GPIO pins physically wired to perform some task when they receive the command.  None of the code in this project is specific to Pis, its just and API for accepting commands and they broadcasting them out on websockets.

[This is my client project that I run on the actual Pi](https://github.com/StephenWetzel/pi-client).

## Use
You can view a list of available devices at /api/v1/devices.  Find the GUID of the device you want, and then send commands to it by hitting /api/v1/devices/1234/event/GO, where 1234 is the guid, and GO is the command.  Any subscribed clients will receive a payload with that event and will need to respond accordingly.  View /api/v1/event_logs/10 to see recent events, and /api/v1/controllers/connections to see how many active devices are connected.

## Concepts
* **Devices** - Devices are individual objects you want to control.  In my basic use case, it's something with a button that I have wired a transistor to so I can simulate button presses.
* **Controllers** - Controllers are essentially Pis.  They are clients to this API and listen for broadcasted events and trigger devices accordingly.  In theory one controller could controller multiple devices, although in practice it'll generally be 1:1.
* **States** - States represent the current state of a device.  Generally things like on/off.
* **Events** - These represent the trigger to transition between states.  Something as simple as "GO" or "TURN_ON".
* **Workflows** - These combine states and events to form state machines.  State is tracked in the back-end, clients are assumed to be in the correct state.  A more complex version should allow for clients to communicate their actual state back to the back-end.

## Notes
I use basic auth for security.  This is secure if you use https for connections, and has the benefit that username/password can be easily bookmarked to provide a easy link to control devices.  However, the password is just stored in an env file, in plaintext.  My initial plan was to have no security and just rely on obscurity to keep me safe, so this is a big step up from that.  That being said, if you were going to use this to control anything that actually matters at all, please implement proper security first.

There are two migrations.  The first builds the structure, and the second populates some seed data.  You don't have to run the second migration if you don't want the test data.

## Example .env file
```
REDISTOGO_URL=redis://localhost:6379/1
DATABASE_URL=postgres://pi:raspberry@localhost:5432/pi_controller_dev
HTTP_AUTH_USER=username
HTTP_AUTH_PASS=password
```