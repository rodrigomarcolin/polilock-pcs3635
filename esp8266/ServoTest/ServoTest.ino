#include <Servo.h>

const int potPin = A0;

Servo myServo;

void setup() {
  myServo.attach(9, 500, 2400);
}

void loop() {
  int potValue = analogRead(potPin);
  int servoAngle = map(potValue, 0, 1023, 0, 180);
  
  myServo.write(servoAngle);
  delay(15);
}
