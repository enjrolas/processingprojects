#ifndef TIMING_H
#define TIMING_H
int milliseconds, seconds, minutes;

ISR(TIMER2_COMPA_vect)    //timer2 compare match
{
  milliseconds += 33;
  if(milliseconds > 1000)
  {
    milliseconds -= 1000;
    seconds++;
  }
  if(seconds > 60)
  {
    seconds -= 60;
    minutes++;
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

#endif
