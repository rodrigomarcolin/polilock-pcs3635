This firmware is designed for an ESP8266-based device that connects to a WiFi network and an MQTT broker. Its main features and behaviors are\*\*:

1. **WiFi and MQTT Connection**: The firmware connects to a specified WiFi network and an MQTT broker using the credentials defined in WIFI_SSID, WIFI_PASS, MQTT_HOST, MQTT_USER, and MQTT_PASS.

1. **MQTT Subscription**: It subscribes to two MQTT topics (VERIFY_TOPIC and MODIFY_TOPIC) to receive messages containing passwords.

1. **Message Handling**: When a message is received on either of the subscribed MQTT topics, the firmware processes the message as a password and calls corresponding functions (verifyPassword() for the VERIFY_TOPIC and modifyPassword() for the MODIFY_TOPIC), which then send a UART Serial message to the FPGA, which will validate or modify the password accordingly.

1. **Servo Control**: The firmware controls a servo motor attached to pin SERVO_PIN. It can move the servo to specific angles (SERVO_LOCKED_ANGLE and SERVO_UNLOCKED_ANGLE). The FPGA, after receiving the password, can set the IS_LOCKED_PIN to high or low, indicating whether the lock is open or closed. The ESP monitors this pin and moves the servo accordingly.

1. **Debounced Pin Monitoring**: It continuously monitors the state of two pins (IS_LOCKED_PIN and IS_BLOCKED_PIN) for any changes. These pins are inputs from the FPGA indicating whether the lock is locked and whether it's blocked and shouldn't verify anymore.

1. **Feedback via Serial Monitor**: The firmware provides feedback via the Serial Monitor, printing messages indicating the device's status, such as WiFi connection status, MQTT connection status, received passwords, and servo control actions.

1. **Reconnection Mechanism**: It includes a reconnection mechanism for both WiFi and MQTT in case the connection is lost. The device attempts to reconnect periodically until successful.
