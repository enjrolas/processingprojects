#ifndef XBEE_H
#define XBEE_H
#include "XBee_config.h"
#include "HardwareSerial.h"
#include "logging.h"
#include "wiring.h"
#undef round
#include "math.h"
// An alternative to round is defined in wiring.h, this was conflicting with avr-libc's math.h
#undef round

void XBee_wake(){
  digitalWrite(XBEE_SLEEP_PIN, LOW);
  delay(XBEE_COMM_DELAY);
  logMsg("XBee awake.", "DEBUG");
}

void XBee_sleep(){
  logMsg("Putting XBee to sleep. . .", "DEBUG");
  pinMode(XBEE_SLEEP_PIN, OUTPUT);
  digitalWrite(XBEE_SLEEP_PIN, HIGH);
  delay(XBEE_COMM_DELAY);  
}

// The XBee has set values which you append to AT commands to choose baud rates
// This returns the appropriate index to append to the AT command to change the baud rate
int XBee_getBaudRateParameter(int baudRate){
  logMsg("Calculating baud rate parameter. . .", "DEBUG");
  //Available baudRates
  int baudRates[] = {1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200};
  
  int numBaudRates = sizeof(baudRates)/sizeof(baudRates[0]);
  for(int i = 0; i < numBaudRates; ++i){
   if(baudRates[i] == baudRate){
    return i;
   } 
  }
  
  //If baudRate chosen is not available
  return -1;
}

//Reconfigures baudRate
//TODO: add error handling
void XBee_changeBaudRate(int currentBaudRate, int finalBaudRate) {
  logMsg("Changing XBee baud rate. . .", "DEBUG");
  Serial.begin(currentBaudRate);
  delay(XBEE_GUARD_TIME);
  //Enter command mode
  Serial.print("+++");
  delay(XBEE_COMM_DELAY);
  char* finalBaudRateParameter;
  finalBaudRateParameter = itoa(XBee_getBaudRateParameter(finalBaudRate), finalBaudRateParameter, 10); 
  //Change the baud rate
  //itoa returns a char* but we know we're only expecting one char, and we need a char, so we use finalBaudRateParameter[0]
  char baudRateChangeCmd[] = {'A', 'T', 'B', 'D', finalBaudRateParameter[0]};
  Serial.println(baudRateChangeCmd);
  //TODO: document this
  Serial.println("ATWR");
  //Exit command mode
  Serial.println("ATCN");
  Serial.begin(finalBaudRate);
  logMsg("XBee baud rate changed.", "DEBUG");
}

#endif
