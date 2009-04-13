import processing.serial.*;

Serial myPort;  // The serial port
float t=0;
float f=2000;
float x=0;
float inc=.1;

void setup() {
  size(200,200);
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  noLoop();
}

void draw()
{
  background(0);
//  byte a=0;
  while(true)
  {
   // int a=(int) (128.0 + (127.0 * sin(2*PI*f*t)));
    //myPort.write(a);
    //t+=.009;
  //  delay(500);
 //   println(a+"    "+i);
//    delay(5);
  /*  myPort.write(a+128);
    a++;
    println(a+128);
   // delay(5);*/
   myPort.write(0);
   for(x=0;x<800000;x++)
     ;
   myPort.write(255);
   for(x=0;x<800000;x++)
     ;
  }
}

void keyPressed()
{
  exit();
}
