#include "MqttCredentials.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <SoftwareSerial.h>
#include <time.h>
#include <TZ.h>
#include <FS.h>
#include <LittleFS.h>
#include <CertStoreBearSSL.h>
#include <Servo.h>

#define RX_PIN D6
#define TX_PIN D7

#define SERVO_PIN D2
#define SERVO_LOCKED_ANGLE 180
#define SERVO_UNLOCKED_ANGLE 0

#define IS_LOCKED_PIN D4
#define LOCKED_TOPIC "dagames/armarios/1/locked"
#define LOCKED_MESSAGE "locked"
#define UNLOCKED_MESSAGE "unlocked"

#define IS_BLOCKED_PIN D3
#define BLOCKED_TOPIC "dagames/armarios/1/blocked"
#define BLOCKED_MESSAGE "blocked"
#define UNBLOCKED_MESSAGE "unblocked"

#define VERIFY_TOPIC "dagames/armarios/1/verify"
#define VERIFY_OPCODE 'v'

#define MODIFY_TOPIC "dagames/armarios/1/modify"
#define MODIFY_OPCODE 'm'

#define OP_TO_PASS_DELAY 200

#define BAUD_RATE 9600

const char *ssid = WIFI_SSID;
const char *password = WIFI_PASS;
const char *mqtt_server = MQTT_HOST;

BearSSL::CertStore certStore;

Servo servo;
WiFiClientSecure espClient;
PubSubClient client(espClient);
SoftwareSerial softSerial(RX_PIN, TX_PIN);

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE (500)
char msg[MSG_BUFFER_SIZE];
int value = 0;

void openLock();
void closeLock();
void verifyPassword();
void modifyPassword();
void setup_wifi();
void setDateTime();
void callback(char *topic, byte *payload, unsigned int length);
void reconnect();

class PinStateNotifier
{
private:
    int pin;
    String topic;
    String truthyMessage;
    String falsyMessage;
    unsigned long debounceDelay;
    unsigned long lastDebounceTime;
    int lastState;

    bool isDebounceTimePassed() {
      return (millis() - lastDebounceTime) > debounceDelay;
    }

    void updateLastDebounceTime() {
      lastDebounceTime = millis();
    }

public:
    PinStateNotifier(int _pin, String _topic, String _truthyMessage, String _falsyMessage, unsigned long _debounceDelay = 200)
    {
        pin = _pin;
        topic = _topic;
        truthyMessage = _truthyMessage;
        falsyMessage = _falsyMessage;
        debounceDelay = _debounceDelay;
        lastDebounceTime = 0;
        lastState = LOW;
    }

    virtual void onFalseToTrue()
    {
        // Default implementation for the high state
        Serial.print("Sending truthy message: ");
        Serial.println(truthyMessage);
    }

    virtual void onTrueToFalse()
    {
        // Default implementation for the low state
        Serial.print("Sending falsy message: ");
        Serial.println(falsyMessage);
    }

    void begin()
    {
        pinMode(pin, INPUT);
    }

    void update()
    {
        int currentState = digitalRead(pin);
        Serial.println(currentState);

        if (isDebounceTimePassed())
        {            
            if (currentState != lastState)
            {
                updateLastDebounceTime();

                if (currentState == HIGH)
                {
                    Serial.print("Sending truthy message: ");
                    Serial.println(truthyMessage);
                    onFalseToTrue();
                }
                else
                {
                    // Send falsy message
                    Serial.print("Sending falsy message: ");
                    Serial.println(falsyMessage);
                    onTrueToFalse();
                }
            }
        }

        lastState = currentState;
    }
};

class LockedPinStateNotifier : public PinStateNotifier
{
public:
    LockedPinStateNotifier(int _pin, String _topic, String _truthyMessage, String _falsyMessage, unsigned long _debounceDelay = 50)
        : PinStateNotifier(_pin, _topic, _truthyMessage, _falsyMessage, _debounceDelay) {}

    void onTrueToFalse() override
    {
        Serial.println("Unlocked!!");
        openLock();
    }

    void onFalseToTrue() override
    {
        Serial.println("Locked!!");
        closeLock();
    }
};

LockedPinStateNotifier lockedPinStateNotifier(IS_LOCKED_PIN, LOCKED_TOPIC, LOCKED_MESSAGE, UNLOCKED_MESSAGE);
PinStateNotifier blockedPinStateNotifier(IS_BLOCKED_PIN, BLOCKED_TOPIC, BLOCKED_MESSAGE, UNBLOCKED_MESSAGE);

void setup()
{
    delay(500);
    servo.attach(SERVO_PIN, 500, 2400);

    Serial.begin(BAUD_RATE);
    delay(500);

    lockedPinStateNotifier.begin();
    blockedPinStateNotifier.begin();

    LittleFS.begin();
    setup_wifi();
    setDateTime();

    int numCerts = certStore.initCertStore(LittleFS, PSTR("/certs.idx"), PSTR("/certs.ar"));
    Serial.printf("Number of CA certs read: %d\n", numCerts);
    if (numCerts == 0)
    {
        Serial.printf("No certs found. Did you run certs-from-mozilla.py and upload the LittleFS directory before running?\n");
        return;
    }

    BearSSL::WiFiClientSecure *bear = new BearSSL::WiFiClientSecure();
    bear->setCertStore(&certStore);

    client = *(new PubSubClient(*bear));

    client.setServer(mqtt_server, MQTT_PORT);
    client.setCallback(callback);
}

void loop()
{
    if (!client.connected())
    {
        reconnect();
    }
    client.loop();
    lockedPinStateNotifier.update();
    blockedPinStateNotifier.update();
}

void setDateTime()
{
    // You can use your own timezone, but the exact time is not used at all.
    // Only the date is needed for validating the certificates.
    configTime(TZ_Europe_Berlin, "pool.ntp.org", "time.nist.gov");

    Serial.print("Waiting for NTP time sync: ");
    time_t now = time(nullptr);
    while (now < 8 * 3600 * 2)
    {
        delay(100);
        Serial.print(".");
        now = time(nullptr);
    }
    Serial.println();

    struct tm timeinfo;
    gmtime_r(&now, &timeinfo);
    Serial.printf("%s %s", tzname[0], asctime(&timeinfo));
}

void openLock()
{
    servo.write(SERVO_UNLOCKED_ANGLE);
    delay(200);
}

void closeLock()
{
    servo.write(SERVO_LOCKED_ANGLE);
    delay(200);
}

void setup_wifi()
{
    delay(10);
    // We start by connecting to a WiFi network
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }

    randomSeed(micros());

    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void callback(char *topic, byte *payload, unsigned int length)
{
    String password = "";
    for (int i = 0; i < length; i++)
    {
        password += (char)payload[i];
    }
    Serial.print("Password received on topic: ");
    Serial.println(topic);
    Serial.print("Password: ");
    Serial.println(password);

    if (strcmp(topic, VERIFY_TOPIC) == 0)
    {
        verifyPassword(password);
    }
    else if (strcmp(topic, MODIFY_TOPIC) == 0)
    {
        modifyPassword(password);
    }
}

void reconnect()
{
    // Loop until we’re reconnected
    while (!client.connected())
    {
        Serial.print("Attempting MQTT connection…");
        String clientId = "ESP8266Client -123123";
        // Attempt to connect
        // Insert your password
        if (client.connect(clientId.c_str(), MQTT_USER, MQTT_PASS))
        {
            Serial.println("connected");
            client.publish("testTopic", "hello world");
            client.subscribe("dagames/led");
            client.subscribe(MODIFY_TOPIC);
            client.subscribe(VERIFY_TOPIC);
        }
        else
        {
            Serial.print("failed, rc = ");
            Serial.print(client.state());
            Serial.println(" try again in 5 seconds");
            // Wait 5 seconds before retrying
            delay(5000);
        }
    }
}

void modifyPassword(const String &password)
{
    Serial.println("modifying password!");
    softSerial.write(MODIFY_OPCODE);
    delay(OP_TO_PASS_DELAY);
    softSerial.write(password.c_str(), password.length());
}

void verifyPassword(const String &password)
{
    if (digitalRead(IS_BLOCKED_PIN) == HIGH)
    {
        return;
    }
    Serial.println("verifying password!");
    softSerial.write(VERIFY_OPCODE);
    delay(OP_TO_PASS_DELAY);
    softSerial.write(password.c_str(), password.length());
}