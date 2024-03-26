// Blynk POC
// Virtual Pins V1 and V0 control LEDS

#include "BlynkCredentials.h"
#include <BlynkSimpleEsp8266.h>

#define v0LedPin D2
#define v1LedPin D3

void setup()
{
  Serial.begin(9600);
  Blynk.begin(BLYNK_AUTH_TOKEN, WIFI_SSID, WIFI_PASS, "blynk.cloud", 80);
  pinMode(v0LedPin, OUTPUT);
  pinMode(v1LedPin, OUTPUT);
}

void loop()
{
  Blynk.run();
}

BLYNK_WRITE(V1)
{
  int pinValue = param.asInt();
  Serial.print(pinValue);
  Serial.println(" V1 \n");

  if (pinValue > 253)
  {
    Serial.println("V1 bigger");
    digitalWrite(v1LedPin, HIGH);
  }
  else
  {
    Serial.println("V1 small");
    digitalWrite(v1LedPin, LOW);
  }
}

BLYNK_WRITE(V0)
{
  int pinValue = param.asInt();
  Serial.print(pinValue);
  Serial.println(" V0 \n");

  if (pinValue > 253)
  {
    Serial.println("V0 bigger");
    digitalWrite(v0LedPin, HIGH);
  }
  else
  {
    Serial.println("V0 small");
    digitalWrite(v0LedPin, LOW);
  }
}