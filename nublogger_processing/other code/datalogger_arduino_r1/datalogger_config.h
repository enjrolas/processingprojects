#ifndef DATALOGGER_CONFIG_H
#define DATALOGGER_CONFIG_H
// Attributes
#define MY_DIGITS_OF_PRECISION 2
#define MY_NAME "gretchen"
#define MY_SERIAL_NUMBER 1
#define MY_GUARD_TIME 1000
#define MY_TIMEOUT 500
#define MY_COMM_DELAY 50
#define MY_NUM_SENSORS 1

//Thermistor sensor constants
float RBOTTOM=1000.0;
float B=3950.0;
float R0=10000.0;
float T0=298.0; 
int myDelay[] = {0, 0, 0, 0, 0, 10, 0};

#include "timing.h"

//Get configuration and apply configuration to datalogger
void configureMe(){
  logMsg("Configuring datalogger. . .", "INFO");
  XBee_changeBaudRate(9600, 19200);
  logMsg("Datalogger configured", "INFO");
}

boolean shouldWeUpdate(int** lastUpdateTime){
  int** nowTime = now();
  int** timeSinceLastUpdate = timeDifference(nowTime, lastUpdateTime);
  float secondsPassed = numSeconds(timeSinceLastUpdate);
  int* delayArray[] = {myDelay, multiplyingFactorArray};
  float secondsToDelay = numSeconds(delayArray);
  
  if (secondsPassed >= secondsToDelay){
   return true;
  } 
  else{
    return false;
  }
  
  return false;
}
#endif
