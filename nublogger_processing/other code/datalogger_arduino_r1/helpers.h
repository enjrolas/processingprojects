#ifndef HELPERS_H
#define HELPERS_H
#include "datalogger_config.h"
#include "math.h"
#undef round
#include <string.h>

boolean streq(char* string1, char* string2){
  if (strcmp(string1, string2) == 0){
    return true;
  }
  else{
    return false;
  }  
}

char* concatStrings(char** stringsToConcat, int numStrings){ 
  // TODO: What is up with calculating the length of an array of strings?
  //  int numStrings = sizeof(stringsToConcat)/sizeof(stringsToConcat);
  char *catted;
 
  int lenToCat = 0;
  for(int i = 0; i < numStrings; ++i){
    lenToCat += strlen(stringsToConcat[i]);
  }
  //TODO: Document the ridiculous story of catted
  catted = (char *)calloc(lenToCat + 1, sizeof(char));
  for(int i = 0; i < numStrings; ++i){
    strcat(catted, stringsToConcat[i]);
  }
  return catted;
}

char* floatToString(float num)
{
  //cast the float as an int, truncating the precision to two decimal points
  int orderOfPrecision = pow(10, MY_DIGITS_OF_PRECISION);
  
  int digits = num*orderOfPrecision;
 
  int digitsBeforeDecimal = (int)num;
  int digitsAfterDecimal = digits % orderOfPrecision;
  
  char *beforeDecimal;
  int numDigitsBeforeDecimal;
  if(digitsBeforeDecimal == 0){
    numDigitsBeforeDecimal = 1;
  }
  else{
   numDigitsBeforeDecimal = log(abs(digitsBeforeDecimal))/log(10) + 1; 
    if(digitsBeforeDecimal < 0){  
      ++numDigitsBeforeDecimal; //Adds a space for the negative sign 
    }
  }
  beforeDecimal = (char *)calloc(numDigitsBeforeDecimal + 1, sizeof(char *));
  strcpy(beforeDecimal, itoa(digitsBeforeDecimal, beforeDecimal, 10));
  
  char *afterDecimal;
  int numDigitsAfterDecimal;
  if(digitsAfterDecimal == 0){
   numDigitsAfterDecimal = MY_DIGITS_OF_PRECISION; 
  }
  else{
    numDigitsAfterDecimal = log(abs(digitsAfterDecimal))/log(10) + 1;
  }
  afterDecimal = (char *)calloc(numDigitsAfterDecimal + 1, sizeof(char *));
  
  strcpy(afterDecimal, itoa(digitsAfterDecimal, afterDecimal, 10));
  char* strings[] = { beforeDecimal, ".", afterDecimal };
  
  char* result = concatStrings(strings, sizeof(strings)/sizeof(strings[0]));
  
  return result;
}
#endif
