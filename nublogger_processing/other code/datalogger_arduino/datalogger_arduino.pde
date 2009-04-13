#include <EEPROM.h>

#include <avr/power.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>

#include <string.h> 
#include <stdlib.h>

#include "comm.h"
#include "arduino.h"
#include "XBee.h"
#include "datalogger_config.h"
#include "timing.h"
#include "helpers.h"
#include "logging.h"

void setup(){  
  //blinkLED(13, 3, 500);
  //initializeTiming();
  //findDongle();  //look for a dongle and send it my details so it can log me.
//  delay(3000);
//  Serial.begin(19200);
//  logMsg("Starting up. . .", "INFO");
}

void loop(){
  Serial.begin(19200);
  delay(500);
  Serial.print("MOO");
  //blinkLED(13, 3, 500);
//  float* readings = updateValues();
//  Serial.println(floatToString(readings[0]));
  //char* units[] = {"degrees C", "degrees C"};
  //broadcastReadings(readings, units); 
}

//Get configuration and apply configuration to datalogger
void configureMe(){
  logMsg("Configuring datalogger. . .", "INFO");
  XBee_changeBaudRate(9600, 19200);
  //defineDefaultConfig();
  logMsg("Datalogger configured", "INFO");
}

//Convert resistance to temperature, per details of thermistor TODO: document thermistor model
float resistanceToTemp(float resistance){
 return float(B/log(resistance/(R0*exp(-1*B/T0))) - 273);
}

//Updates readings
float* updateValues()
{
  logMsg("Updating sensor values . . .", "DEBUG");
  float* sensorReadings[MY_NUM_SENSORS];
  float sensorRatios[MY_NUM_SENSORS], resistances[MY_NUM_SENSORS], readings[MY_NUM_SENSORS];

  // Step through available sensors and record a top and bottom value for each
  for(int i = 0; i < 2*MY_NUM_SENSORS; i += 2){
    //Steps through numSensors times
    float topReading = (float)analogRead(i);
    float bottomReading = (float)analogRead(i+1);
    float topBottom[] = {topReading, bottomReading};
    sensorReadings[i] = topBottom;
    sensorRatios[i/2] = sensorReadings[i][0]/sensorReadings[i][1];
    resistances[i/2] = (sensorRatios[i/2] - 1)*RBOTTOM;
    readings[i/2] = resistanceToTemp(resistances[i/2]);
  }    
  logMsg("Sensor values updated.", "DEBUG");
  
  return readings;
}

//Broadcasts readings
void broadcastReadings(float* rawReadings, char** units)
{
  logMsg("Broadcasting readings. . .", "INFO");
  //Requires an array of readings and an array of units
  int readingsLength = sizeof(rawReadings)/sizeof(rawReadings[0]);
  int unitsLength = sizeof(units)/sizeof(units[0]);
  if(readingsLength == unitsLength){
    char* formattedReadings[] = {""};
    for(int j = 0; j < readingsLength && j < unitsLength; ++j){
      formattedReadings[j] = floatToString(rawReadings[j]);
    }
    char* messageToBroadcast = "";
    for(int i = 0; i < readingsLength && i < unitsLength; ++i){
      //Put reading/unit pairs into message
      char* toAdd[] = {formattedReadings[i], MESSAGE_DELIMITER, units[i], MESSAGE_DELIMITER};
      strcat(messageToBroadcast, concatStrings(toAdd));
    }
    Serial.print(messageToBroadcast);
    Serial.println();
  }
  else{
   logMsg("Readings and units vectors different lengths; they need to be the same size.", "ERROR"); 
  }
}
