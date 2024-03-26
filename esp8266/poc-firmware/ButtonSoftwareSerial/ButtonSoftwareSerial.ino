#include <SoftwareSerial.h>

#define verifyButtonPin D2
#define modifyButtonPin D3

#define verifyLedPin D6
#define modifyLedPin D7
#define LED_BLINK_DELAY 500

#define DEBOUNCE_DELAY 800
#define OP_TO_PASS_DELAY 200

#define RX_PIN 5
#define TX_PIN 6

typedef struct
{
  bool pressed;
  int pin;
  unsigned long lastDebounceTime;
} Button;

Button verifyButton = {false, verifyButtonPin, 0};
Button modifyButton = {false, modifyButtonPin, 0};
SoftwareSerial softSerial(RX_PIN, TX_PIN);

char VERIFY_OPCODE = 'v';
char MODIFY_OPCODE = 'm';

char passwordToVerify[] = "abcdefghij";
char passwordToModify[] = "jihgfedcba";

void setupButtons();
void updateState(Button &button);
bool isButtonPressed(Button &button);
bool isActionRequired(Button &button);
bool isDebounceTimePassed(Button &button);
void blinkLed(int pin);
void setupLeds();

void verifyPassword();
void modifyPassword();

void setup()
{
  softSerial.begin(9600);
  Serial.begin(9600);
  pinMode(TX_PIN, OUTPUT);
  setupButtons();
  setupLeds();
}

void loop()
{
  if (isActionRequired(verifyButton))
  {
    verifyPassword();
  }

  if (isActionRequired(modifyButton))
  {
    modifyPassword();
  }

  updateState(verifyButton);
  updateState(modifyButton);
}

void setupButtons()
{
  pinMode(verifyButtonPin, INPUT_PULLUP);
  pinMode(modifyButtonPin, INPUT_PULLUP);
}

bool isActionRequired(Button &button)
{
  bool isRequired = isButtonPressed(button) && !button.pressed && isDebounceTimePassed(button);
  if (isRequired)
  {
    button.lastDebounceTime = millis();
  }
  return isRequired;
}

void updateState(Button &button)
{
  button.pressed = isButtonPressed(button);
}

bool isButtonPressed(Button &button)
{
  return digitalRead(button.pin) == LOW;
}

bool isDebounceTimePassed(Button &button)
{
  return (millis() - button.lastDebounceTime) > DEBOUNCE_DELAY;
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

void modifyPassword()
{
  softSerial.write(MODIFY_OPCODE);
  delay(OP_TO_PASS_DELAY);
  softSerial.write(passwordToModify);

  blinkLed(modifyLedPin);
}

void verifyPassword()
{
  softSerial.write(VERIFY_OPCODE);
  delay(OP_TO_PASS_DELAY);
  softSerial.write(passwordToVerify);

  blinkLed(verifyLedPin);
}
