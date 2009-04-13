import processing.serial.*;

Serial myPort;  // The serial port
float t=0;
float f=2000;
float x=0;
float inc=.1;
boolean lin=false;
float frequency=100;

void setup() {
  size(200,200);
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
}
void draw()
{
  while(true)
  {
    myPort.write((char)(128*(sin(frequency*t)+1)));
    t+=.01;
  }
}
void keyPressed()
{
  if(keyCode==UP)
    frequency++;
  if(keyCode==DOWN)
    frequency--;
  println(frequency);
}


