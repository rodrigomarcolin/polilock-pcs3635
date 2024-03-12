#include "BlynkCredentials.h"
#include <SoftwareSerial.h>
#include <BlynkSimpleEsp8266.h>

#define BUTTON_PRESSED_VALUE 255

#define verifyLedPin D2
#define modifyLedPin D3

#define OP_TO_PASS_DELAY 200
#define LED_BLINK_DELAY 500

#define BAUD_RATE 9600
#define RX_PIN D5
#define TX_PIN D6

SoftwareSerial softSerial(RX_PIN, TX_PIN);

char VERIFY_OPCODE = 'v';
char MODIFY_OPCODE = 'm';

char passwordToVerify[] = "abcdefghij";
char passwordToModify[] = "jihgfedcba";

void verifyPassword();
void modifyPassword();
void blinkLed(int pin);
void setupLeds();

void setup()
{
  softSerial.begin(BAUD_RATE);
  Serial.begin(BAUD_RATE);

  pinMode(TX_PIN, output);
  setupLeds();

  Blynk.begin(BLYNK_AUTH_TOKEN, WIFI_SSID, WIFI_PASS, "blynk.cloud", 80);
}

void loop()
{
  Blynk.run();
}

void modifyPassword()
{
  softSerial.write(MODIFY_OPCODE);
  delay(OP_TO_PASS_DELAY);
  softSerial.write(passwordToModify);
}

void verifyPassword()
{
  softSerial.write(VERIFY_OPCODE);
  delay(OP_TO_PASS_DELAY);
  softSerial.write(passwordToVerify);
}

void blinkLed(int pin)
{
  digitalWrite(pin, HIGH);
  delay(LED_BLINK_DELAY);
  digitalWrite(pin, LOW);
}

void setupLeds()
{
  pinMode(verifyLedPin, OUTPUT);
  pinMode(modifyLedPin, OUTPUT);
}

BLYNK_WRITE(V0)
{
  int verifyButtonValue = param.asInt();
  if (verifyButtonValue == BUTTON_PRESSED_VALUE)
  {
    verifyPassword();
    blinkLed(verifyLedPin);
  }
}

BLYNK_WRITE(V1)
{
  int modifyButtonValue = param.asInt();
  if (modifyButtonValue == BUTTON_PRESSED_VALUE)
  {
    modifyPassword();
    blinkLed(modifyLedPin);
  }
}
