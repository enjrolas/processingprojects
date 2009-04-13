#ifndef LOGGING_H
#define LOGGING_H
#define LOGGING_LEVEL "OFF"

#include <string.h>
#include "WConstants.h"

int calculateLoggingLevel(char* levelName){
  char* availableLogLevels[] = {
    "OFF", "CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"  };
  int numLoggingLevels = sizeof(availableLogLevels)/sizeof(availableLogLevels[0]);
  for(int i = 0; i < numLoggingLevels; ++i){

    if(strcmp(availableLogLevels[i], levelName) == 0){
      return i;
    } 
  }  
  return -1;
}

boolean worthLogging(char* logLevel){ 
  int currentLoggingLevel = calculateLoggingLevel(LOGGING_LEVEL);
  int levelToCompare = calculateLoggingLevel(logLevel);

  if(levelToCompare <= currentLoggingLevel){
    return true;
  }
  return false;
  return true;
}

void logMsg(char* message, char* logLevel){
  /*
  if(worthLogging(logLevel)){
    Serial.print(logLevel);
    Serial.print(":  ");
    Serial.println(message);
  }
  */
}
#endif
