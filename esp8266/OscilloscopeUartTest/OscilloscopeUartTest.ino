#include <SoftwareSerial.h>

#define BAUD_RATE 9600
#define RX_PIN D5
#define TX_PIN D6

SoftwareSerial softSerial(RX_PIN, TX_PIN);

char CHAR_TO_WRITE = 'w';
char STRING_TO_WRITE[] = "abc";

void setup()
{
  softSerial.begin(BAUD_RATE);
  Serial.begin(BAUD_RATE);
  pinMode(TX_PIN, OUTPUT);
}

void loop()
{
  softSerial.print(CHAR_TO_WRITE);
  delay(1000);
}
