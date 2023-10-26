/*
 * Blink
 * Turns on an LED on for one second, then off for one second, repeatedly.
 *
 * This example code is in the public domain.
 */

#include<Arduino.h>

// Pin 13 has an LED connected on most Arduino boards, except
// on the Sparkfun Pro Micro where we need to use the RX LED instead.
// give it a name:
#ifndef HAVE_PRO_MICRO
int led = 13;
#else
int led = 17;
#endif

// the setup routine runs once when you press reset:
void setup() {
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);               // wait for a second
  digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);               // wait for a second
}
