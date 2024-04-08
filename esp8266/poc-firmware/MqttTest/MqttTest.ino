#include "MqttCredentials.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <SoftwareSerial.h>

#define BAUD_RATE 9600
#define RX_PIN D5
#define TX_PIN D6
#define LED_PIN D3

WiFiClientSecure espClient;
PubSubClient client(espClient);
SoftwareSerial softSerial(RX_PIN, TX_PIN);

void setup_wifi();

void setup()
{
    pinMode(LED_PIN, OUTPUT);

    Serial.begin(9600);
    while (!Serial) delay(1);
    setup_wifi();

    client.setServer(MQTT_HOST, MQTT_PORT);
    client.setCallback(callback);
}

void loop()
{
  if (!client.connected()) reconnect(); 
  client.loop();
}

void callback(char *topic, byte *payload, unsigned int length)
{
    String message = "";
    for (int i = 0; i < length; i++)
    {
        message += (char)payload[i];
    }
    Serial.print("Message received on topic: ");
    Serial.println(topic);
    Serial.print("Message: ");
    Serial.println(message);

    int value = message.toInt();
    if (value > 127)
    {
        digitalWrite(LED_PIN, HIGH); // Turn on the LED
    }
    else
    {
        digitalWrite(LED_PIN, LOW);
    }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP8266Client";   
    if (client.connect(clientId.c_str(), MQTT_USER, MQTT_PASS)) {
      Serial.println("connected");

      client.subscribe("dagames/led"); 

    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup_wifi() {
  delay(10);
  Serial.print("\nConnecting to ");
  Serial.println(WIFI_SSID);

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  randomSeed(micros());
  Serial.println("\nWiFi connected\nIP address: ");
  Serial.println(WiFi.localIP());
}