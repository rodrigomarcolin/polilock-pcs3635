#include "BlynkCredentials.h"
#include <SoftwareSerial.h>
#include <BlynkSimpleEsp8266.h>

#define verifyLedPin D2
#define modifyLedPin D3

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
  softSerial.begin(9600);
  Serial.begin(9600);
  Blynk.begin(BLYNK_AUTH_TOKEN, WIFI_SSID, WIFI_PASS, "blynk.cloud", 80);
  setupLeds();
}

void loop()
{
  Blynk.run();
}

void modifyPassword()
{
  softSerial.write(MODIFY_OPCODE);
  delay(200);
  softSerial.write(passwordToModify);
}

void verifyPassword()
{
  softSerial.write(VERIFY_OPCODE);
  delay(200);
  softSerial.write(passwordToVerify);
}

void blinkLed(int pin)
{
  digitalWrite(pin, HIGH);
  delay(500);
  digitalWrite(pin, LOW);
}

void setupLeds() {
  pinMode(verifyLedPin, OUTPUT);
  pinMode(modifyLedPin, OUTPUT);
}

BLYNK_WRITE(V0)
{
  int verifyFlag = param.asInt();
  if (verifyFlag == 255)
  {
    verifyPassword();
    blinkLed(verifyLedPin);
  }
}

BLYNK_WRITE(V1)
{
  int modifyFlag = param.asInt();
  if (modifyFlag == 255)
  {
    modifyPassword();
    blinkLed(modifyLedPin);
  }
}
