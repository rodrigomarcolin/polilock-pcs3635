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

#define RESET_PIN D0
#define INICIAR_PIN D1
#define TX_PIN D2
#define IS_BLOCKED_PIN D3
#define IS_LOCKED_PIN D4
#define SERVO_PIN D5
#define GREEN_LED_PIN D6
#define RED_LED_PIN D7
#define BUZZER_PIN D8

#define RX_PIN 255

#define SERVO_LOCKED_ANGLE 180
#define SERVO_UNLOCKED_ANGLE 0

#define LOCKED_TOPIC "dagames/armarios/1/locked"
#define LOCKED_MESSAGE "locked"
#define UNLOCKED_MESSAGE "unlocked"

#define BLOCKED_TOPIC "dagames/armarios/1/blocked"
#define BLOCKED_MESSAGE "blocked"
#define UNBLOCKED_MESSAGE "unblocked"

#define VERIFY_TOPIC "dagames/armarios/1/verify"
#define VERIFY_OPCODE 'v'

#define MODIFY_TOPIC "dagames/armarios/1/modify"
#define MODIFY_OPCODE 'm'

#define INICIA_TOPIC "dagames/armarios/1/start"
#define RESET_TOPIC "dagames/armarios/1/reset"

#define INICIAR_TOPIC "da"
#define OP_TO_PASS_DELAY 200

#define BUZZER_LOCK_TONE 480
#define BUZZER_LOCK_REPEAT 2
#define BUZZER_LOCK_DELAY 1000

#define BUZZER_UNLOCK_TONE 1046
#define BUZZER_UNLOCK_REPEAT 2
#define BUZZER_UNLOCK_DELAY 500

#define BUZZER_BLOCK_TONE 440
#define BUZZER_BLOCK_REPEAT 4
#define BUZZER_BLOCK_DELAY 1000


#define LOGS_TOPIC "dagames/armarios/1/logs"
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
void mandaIniciar();
void mandaResetar();
void callback(char *topic, byte *payload, unsigned int length);
void reconnect();
void apitaDestrancar();
void apitaTrancar();
void apitaBloquear();
void logger(String log);

class PinStateNotifier
{
protected:
    String topic;
    String truthyMessage;
    String falsyMessage;
private:
    int pin;
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
        if (client.connected()) {
          client.publish(topic.c_str(), truthyMessage.c_str());
        }
        Serial.println(truthyMessage);
        digitalWrite(RED_LED_PIN, HIGH);
        logger("Error: Armário " + truthyMessage);
    }

    virtual void onTrueToFalse()
    {
        // Default implementation for the low state
        Serial.print("Sending falsy message: ");
        if (client.connected()) {
          client.publish(topic.c_str(), falsyMessage.c_str());
        }
        Serial.println(falsyMessage);
        digitalWrite(RED_LED_PIN, LOW);
        logger("Info: Armário " + falsyMessage);   
    }

    void begin()
    {
        pinMode(pin, INPUT);
    }

    void update()
    {
        int currentState = digitalRead(pin);
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
        Serial.println("Locked!!");
        if (client.connected()) {
          client.publish(topic.c_str(), truthyMessage.c_str());
        }
        digitalWrite(GREEN_LED_PIN, LOW);
        apitaDestrancar();
        closeLock();
        logger("Info: Trancando o armário!");
    }

    void onFalseToTrue() override
    {
      Serial.println("Unlocked!!");
        if (client.connected()) {
          client.publish(topic.c_str(), falsyMessage.c_str());
        }
        digitalWrite(RED_LED_PIN, LOW);
        digitalWrite(GREEN_LED_PIN, HIGH);
        apitaDestrancar();
        openLock();
        logger("Info: Senha correta inserida. Destrancando...");
    }
};

LockedPinStateNotifier lockedPinStateNotifier(IS_LOCKED_PIN, LOCKED_TOPIC, LOCKED_MESSAGE, UNLOCKED_MESSAGE);
PinStateNotifier blockedPinStateNotifier(IS_BLOCKED_PIN, BLOCKED_TOPIC, BLOCKED_MESSAGE, UNBLOCKED_MESSAGE);

void logger(String log) {
    client.publish(LOGS_TOPIC, log.c_str());
}

void setup()
{
    delay(500);
    servo.attach(SERVO_PIN, 500, 2400);

    softSerial.begin(BAUD_RATE);
    Serial.begin(BAUD_RATE);
    delay(500);

    lockedPinStateNotifier.begin();
    blockedPinStateNotifier.begin();

    LittleFS.begin();
    setup_wifi();
    setDateTime();

    pinMode(GREEN_LED_PIN, OUTPUT);
    pinMode(RED_LED_PIN, OUTPUT);
    pinMode(BUZZER_PIN, OUTPUT);
    pinMode(INICIAR_PIN, OUTPUT);
    pinMode(RESET_PIN, OUTPUT);

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
    Serial.print("Message received on topic: ");
    Serial.println(topic);
    Serial.print("Message: ");
    Serial.println(password);

    if (strcmp(topic, VERIFY_TOPIC) == 0)
    {
        verifyPassword(password);
    }
    else if (strcmp(topic, MODIFY_TOPIC) == 0)
    {
        modifyPassword(password);
    }
    else if (strcmp(topic, INICIA_TOPIC) == 0)
    {

        mandaIniciar();
    }
    else if (strcmp(topic, RESET_TOPIC  ) == 0)
    {
        mandaResetar();
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
            client.subscribe(MODIFY_TOPIC);
            client.subscribe(INICIA_TOPIC);
            client.subscribe(RESET_TOPIC);
            client.subscribe(VERIFY_TOPIC);
        }
        else
        {
            Serial.print("failed, rc = ");
            Serial.print(client.state());
            Serial.println(" try again in 5 seconds");
            delay(5000);
        }
    }
}

void modifyPassword(const String &password)
{
    Serial.println("modifying password!");
    logger("Info: Modificando para a senha " + password);
    softSerial.write(MODIFY_OPCODE);
    delay(OP_TO_PASS_DELAY);
    softSerial.write(password.c_str(), password.length());
}

void verifyPassword(const String &password)
{
    if (digitalRead(IS_BLOCKED_PIN) == HIGH)
    {
        Serial.println("Couldn't verify password. System is blocked.");
        return;
    }
    Serial.println("verifying password!");
    logger("Info: Verificando a senha");
    softSerial.write(VERIFY_OPCODE);
    delay(OP_TO_PASS_DELAY);
    softSerial.write(password.c_str(), password.length());
}

void mandaIniciar() {
    logger("Warning: Mandando sinal de início...");
    digitalWrite(INICIAR_PIN, HIGH);
    delay(50);
    digitalWrite(INICIAR_PIN, LOW);
}

void mandaResetar() {
    logger("Warning: Resetando o sistema...");
    digitalWrite(RESET_PIN, HIGH);
    delay(50);
    digitalWrite(RESET_PIN, LOW);
}

void apitaTrancar() {
    for (int i = 0; i < BUZZER_LOCK_REPEAT; i++) {
        tone(BUZZER_PIN, BUZZER_LOCK_TONE);
        delay(BUZZER_LOCK_DELAY);
        noTone(BUZZER_PIN);
        delay(200);
    }
}

void apitaDestrancar() {
    for (int i = 0; i < BUZZER_UNLOCK_REPEAT; i++) {
        tone(BUZZER_PIN, BUZZER_UNLOCK_TONE);
        delay(BUZZER_UNLOCK_DELAY);
        noTone(BUZZER_PIN);
        delay(200);
    }
}

void apitaBloquear() {
    for (int i = 0; i < BUZZER_BLOCK_REPEAT; i++) {
        tone(BUZZER_PIN, BUZZER_BLOCK_TONE);
        delay(BUZZER_BLOCK_DELAY);
        noTone(BUZZER_PIN);
        delay(200);
    }
}
