import processing.serial.*;

Serial myPort;  // The serial port
float t=0;
float f=2000;
float x=0;
float inc=.1;
boolean lin=false;

void setup() {
  size(200,200);
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw()
{
  lin=false;
  while(myPort.available()>0)
  {
    print(myPort.read()+" ");
    lin=true;
  }
  if(lin)
    println();
}


