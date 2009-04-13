#ifndef TIMING_H
#define TIMING_H

#include "helpers.h"
int multiplyingFactorArray[] = {1, 7, 24, 60, 60, 1000, 1};

int milliseconds, seconds, minutes, hours, days, weeks, months;
 
ISR(TIMER2_COMPA_vect)    //timer2 compare match
{
  milliseconds += 33;
  if(milliseconds >= 1000)
  {
    milliseconds = milliseconds % 1000;
    ++seconds;
  }
  if(seconds >= 60)
  {
    seconds = seconds % 60;
    ++minutes;
  }
  if(minutes >= 60){
    minutes = minutes % 60;
    ++hours;
  }
  if(hours >= 24){
    hours = hours % 24;
    ++days;
  }
  if(days >= 7){
    days = days % 7;
    ++weeks;
  }
  if(weeks >= 4){
   weeks = weeks % 4;
   ++months;
  }
}

void timer2_init()
{
  logMsg("Initializing interrupt timer2 . . .", "DEBUG");
  TCCR2A=0;
  TCCR2B=(1<<CS22) | (1<<CS21) | (1<<CS20);  //set the clock prescaler to 1024.  slow it down as much as possible.
  OCR2A=255;    //we're going to check the counter and throw an interrupt when it's equal to OCR2A.  We can tweak this value later to give us sooper-accurate timing, 
                //but for now it's essentially an overflow.  Each overflow is 33 ms.
  TIMSK2=0;     //keep interrupts off for now, to keep things clean
  logMsg("Interrupt timer2 initialized.", "DEBUG");
}

void timer2_start()
{
  logMsg("Starting interrupt timer2. . .", "DEBUG");
  TIMSK2=(1<<OCIE2A);  //enable an interrupt on a OCR2A compare match
  sei();     //enable global interrupts;
  logMsg("Interrupt timer2 started.", "DEBUG");
}

void timer2_stop()
{
  logMsg("Stopping interrupt timer2. . .", "DEBUG");
  TIMSK2=0;   //get rid of that interrupt
  cli();      //kill global interrupts
  logMsg("Interrupt timer2 stopped.", "DEBUG");
}

// Set all the variables for interrupt based timing and begin the timer
void initializeTiming() {
  logMsg("Resetting clock. . .", "DEBUG");
  milliseconds = 0;
  seconds = 0;
  minutes = 0;  
  timer2_init();
  logMsg("Clock reset.", "DEBUG");
}

int** now(){
 int timeArray[] = {months, weeks, days, hours, minutes, seconds, milliseconds};
 int* time[] = {timeArray, multiplyingFactorArray};
 return time;
}

char* getTime(){
  logMsg("Parsing current time. . .", "DEBUG");
  int** time = now();
  char* msString = itoa(milliseconds, msString, 10);
  char* sString = itoa(seconds, sString, 10);
  char* mString = itoa(minutes, mString, 10);
  char* hString = itoa(hours, hString, 10);
  char* dString = itoa(days, dString, 10);
  char* wString = itoa(weeks, wString, 10);
  char* mthString =itoa(months, mthString, 10);

  char* timeSubstrings[] = {mthString, " months, ", wString, " weeks, ", dString, " days, ", hString, ":", mString,":", sString, ":", msString, "."};
  char* timeString = concatStrings(timeSubstrings, sizeof(timeSubstrings)/sizeof(timeSubstrings[0]));

 return timeString;
}

float numSeconds(int** time){
 logMsg("Computing total seconds passed. . .", "DEBUG");
 int timeSize = sizeof(time[0])/sizeof(time[0][0]);
 //Multiplying factors at each step to get to seconds. (e.g. seven days in a week)
 int factorSize = sizeof(time[1])/sizeof(time[1][0]);
 
 if(timeSize != factorSize){
   logMsg("Time vector and time factor vector have different number of elements.", "CRITICAL");
 }
 else{
   float numSeconds = 0.0;
   for(int i = 0; i < timeSize && i < factorSize; ++i){
    numSeconds += time[0][i]*time[1][i];
   }
   return numSeconds;
 }
 return -1;
}

boolean isEarlier(int** firstTime, int** secondTime){
  logMsg("Finding if a time is earlier. . .", "DEBUG");
  int firstTimeSeconds = numSeconds(firstTime);
  int secondTimeSeconds = numSeconds(secondTime);
  
  if(firstTimeSeconds < secondTimeSeconds){
    return true;
  }
  else{
    return false; 
  }
  
  return false;
}

boolean isLater(int** firstTime, int** secondTime){
 logMsg("Finding if a time is later. . .", "DEBUG");
 boolean _isEarlier = isEarlier(firstTime, secondTime);
 return !_isEarlier;
}

int** timeDifference(int** firstTime, int** secondTime){
 int firstTimeSize = sizeof(firstTime[0])/sizeof(firstTime[0][0]);
 //Multiplying factors at each step to get to seconds. (e.g. seven days in a week)
 int secondTimeSize = sizeof(secondTime[0])/sizeof(secondTime[0][0]);
 
 if(firstTimeSize != secondTimeSize){
   logMsg("Time arrays different number of elements.", "CRITICAL");
 }
 else{
   int** timeDifference;
   for(int i = 0; i < firstTimeSize && i < secondTimeSize; ++i){
    timeDifference[0][i] = firstTime[i]-secondTime[i];
   }
   timeDifference[1] = multiplyingFactorArray;
   
   return timeDifference;
 }
  
}

#endif
