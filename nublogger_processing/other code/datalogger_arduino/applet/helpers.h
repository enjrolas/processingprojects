#ifndef HELPERS_H
#define HELPERS_H
#include "datalogger_config.h"
#include "math.h"
#undef round

char* concatStrings(char** stringsToConcat){
 int numStrings = sizeof(stringsToConcat)/sizeof(stringsToConcat[0]);
 char* catted = "";
 for(int i = 0; i < numStrings; ++i){
   strcat(catted, stringsToConcat[i]);
 }
 
 return catted;
}

char* floatToString(float a)  //takes in a float and prints it out as a string to the serial port
{
  //cast the float as an int, truncating the precision to two decimal points
  int num = a*pow(10, MY_DIGITS_OF_PRECISION);
  
  char* beforeDecimal = ""; 
  char* afterDecimal = ""; 
  beforeDecimal = itoa((int)float(num)/pow(10, MY_DIGITS_OF_PRECISION), beforeDecimal, 10);
  //if num is negative, this can come out negative, too and that's an easy way to flip out some bits on the computer side 
  afterDecimal = itoa((int)abs(num%10), afterDecimal, 10);
  
  char* strings[] = {beforeDecimal, ".", afterDecimal};
  
  char* string = "";
  string = concatStrings(strings);
  
  return string;
}
#endif
