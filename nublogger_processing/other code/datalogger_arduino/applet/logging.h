#ifndef LOGGING_H
#define LOGGING_H
#define LOGGING_LEVEL "DEBUG"

#include <string.h>
#include "WConstants.h"
/*
int calculateLoggingLevel(char* levelName){
  char* availableLogLevels[] = {"CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"};
  int numLoggingLevels = sizeof(availableLogLevels)/sizeof(availableLogLevels[0]);
  for(int i = 0; i < numLoggingLevels; ++i){
    
    if(strcmp(availableLogLevels[i], levelName) == 0){
     return i;
    } 
  }  
  return -1;
}

boolean worthLogging(char* logLevel){ 
 int currentLoggingLevel = loggingLevel(LOGGING_LEVEL);
 int levelToCompare = loggingLevel(logLevel);
 
 if(levelToCompare <= currentLoggingLevel){
   return true;
 }
 return false;
 return true;
}
*/
void logMsg(char* message, char* logLevel){
//  if(worthLogging(logLevel)){
   delay(100);
   Serial.print(logLevel);
   delay(100);
   Serial.print(":  ");
   delay(100);
   Serial.println(message);
//  }
}
#endif
