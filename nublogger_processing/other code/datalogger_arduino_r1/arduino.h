//Arduino ----------------------------------------

#ifndef ARDUINO_H
#define ARDUINO_H
#include "arduino_config.h"
#include "wiring.h"
#include "logging.h"

void arduino_initialize(){
  pinMode(ARDUINO_LED_PIN, OUTPUT);  
}

void arduino_sleep(){
  logMsg("Putting Arduino to sleep. . .", "DEBUG");
  set_sleep_mode(SLEEP_MODE_PWR_SAVE);   //put it to sleep but keep a clock running
  sleep_enable();
  //attachInterrupt(0, Arduino_wake, LOW);  no good--this is an external interrupt
  //we want to set up compare matches and prescalers on timer2, put it in PWR_SAVE mode (which kills everything except timer2)
  //and then just put it to sleep.  The interrupt vector for timer2 overflow will wake it up.
  sleep_mode();
  //Actually sleeps now
 
  sleep_disable();
}

void arduino_wake(){
  logMsg("Waking arduino. . .", "DEBUG");
  // Wakes up
}

void blinkLED(int targetPin, int numBlinks, int blinkInterval) {
  logMsg("Blinking indicator LED. . .", "DEBUG");
   // this function blinks the an LED light as many times as requested
   for (int i=0; i<numBlinks; i++) {
    digitalWrite(targetPin, HIGH); // sets the LED on
    delay(blinkInterval); // waits for a second
    digitalWrite(targetPin, LOW); // sets the LED off
    delay(blinkInterval);
   }
}
#endif
