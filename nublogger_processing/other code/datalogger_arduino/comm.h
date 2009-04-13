#ifndef COMM_H
#define COMM_H
//Protocol (0-25)
#define MESSAGE_START 0
#define MESSAGE_END 1
#define MESSAGE_DELIMITER ","

//Messages from dongle
#define OK 2
#define DISCOVERY_CONFIRMED

//States (51-100)
#define TURNING_ON 50
#define INITIALIZED 51
#define WAITING_FOR_CONFIG 52
#define CONFIGURED 53
#define SAMPLING 54
#define TURNING_OFF 55
#define BROKEN 56

//Message IDs (101 - 150)
#define WHOAMI_IDENTIFIER 101
#define CHECKSUM_IDENTIFIER 102
#define CONFIGURATION_IDENTIFIER 103
#define LOGGING_IDENTIFIER 104
#define REQUEST_IDENTIFIER 105
#define ERROR_IDENTIFIER 106

//Error Messages (151 - 200)
#define MALFORMED_MESSAGE_ERROR 101
#define MISSING_MESSAGE_START_ERROR 102
#define MISSING_MESSAGE_END_ERROR 103
#define TIMEOUT_ERROR 104
#define WRONG_CHECKSUM_ERROR 105
#define NO_DATA_ERROR 106

//Request messages (201 - 250)
#define PLEASE_RESEND 151
#define PLEASE_CONFIGURE_ME 152
#define PLEASE_DISCOVER_ME 153

//Commands (251 - 300)
#define WAIT_FOR_CONFIGURATION 201
#define RESEND_MESSAGE 202
#define SLEEP 203
#define WAKE 204

//
#include "XBee.h"
#include "arduino.h"
#include "datalogger_config.h"
#include "helpers.h"
#include "logging.h"
//

void transmitter_wake(){
  XBee_wake();
  logMsg("Woke XBee...", "INFO");
}

void transmitter_sleep(){
  logMsg("Putting XBee to sleep...", "INFO");
  XBee_sleep();
}

byte calculateChecksum(char* message){
  byte chk = 0;
  logMsg("Calculating checksum for message . . .", "DEBUG"); 
  for(int i = 0 ; i < strlen(message); ++i){
    chk += atoi((char*)message[i]);
  }
  return chk;
}

void sendMessage(char* message, int messageIdentifier){
  blinkLED(13, 2, 250);
  int checksum = calculateChecksum(messageIdentifier + message);
  logMsg("Beginning to send message . . .", "DEBUG");
  Serial.print(MESSAGE_START, DEC);
  Serial.print(messageIdentifier, DEC);
  Serial.print(message);
  Serial.print(CHECKSUM_IDENTIFIER, DEC);
  Serial.print(checksum, DEC);
  Serial.print(MESSAGE_END, DEC);  
  logMsg("Sent message.", "DEBUG");
}

void timeout(){
  logMsg("Communication with dongle timed out", "ERROR");
  sendMessage((char*)TIMEOUT_ERROR, ERROR_IDENTIFIER);
}

char* receiveMsg(){
  char* data;
  int index = 0;
  logMsg("Receiving data. . .", "DEBUG");
  while(Serial.available() > 0){
    data[index] = Serial.read();
    ++index;
  }
  logMsg("Data received.", "DEBUG");
  return data;
}

boolean receivedMsg(char* msg){
  int startTime = millis();
  logMsg("Waiting to receive message . . .", "DEBUG");
  while(millis() - startTime > MY_TIMEOUT ){
      char* message = receiveMsg();
      if (strstr(message, msg) == NULL) {
        logMsg("No message received.", "DEBUG");
        return false;
      }
      else {
        logMsg("Message received.", "DEBUG");
        return true;
      }
    }
  timeout();
  return false;  
}

void request(char* request){
  logMsg("Making request . . ", "DEBUG");
  sendMessage(request, REQUEST_IDENTIFIER);
}

boolean findDongle(){
  boolean foundDongle = false;
  int startTime = millis();
  logMsg("Searching for dongle . . .", "INFO");
  while(millis() - startTime < MY_TIMEOUT && foundDongle == false){
    request((char*)PLEASE_DISCOVER_ME);
    delay(MY_COMM_DELAY);
    char discoveryString[1] = {DISCOVERY_CONFIRMED};
    boolean weWereDiscovered = receivedMsg(discoveryString);
    if(weWereDiscovered){
     logMsg("Dongle found.", "INFO");
     return true; 
    }
  }
  logMsg("Dongle not found, timed out.", "ERROR");
  return false;
}

#endif
