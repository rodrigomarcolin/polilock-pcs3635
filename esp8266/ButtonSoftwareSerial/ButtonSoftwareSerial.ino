#include <SoftwareSerial.h>

#define verifyButtonPin D2
#define modifyButtonPin D3

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

void verifyPassword();
void modifyPassword();

void setup()
{
  softSerial.begin(9600);
  Serial.begin(9600);
  pinMode(TX_PIN, output);
  setupButtons();
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
  bool isRequired = isButtonPressed(button) && !button.pressed;
  if (isRequired && isDebounceTimePassed(button))
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