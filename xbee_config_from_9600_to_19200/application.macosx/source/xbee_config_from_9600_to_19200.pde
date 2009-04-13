
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
  noLoop();
}

void draw()
{


  myPort.write("+++");
  print("entering command mode...");
  delay(2000);
    while(myPort.available()>0)
  {
    char a=(char)myPort.read();
    print(a);
  }
  myPort.write("ATBD4");
  myPort.write(13);
  println("set baudrate to 19200 baud");
  myPort.write("ATWR");
  myPort.write(13);
  println("saving changes to non-volatile memory");
  myPort.write("ATCN");
  myPort.write(13);
  println("leaving command mode");
  delay(2000);
  myPort.stop();
  myPort = new Serial(this, Serial.list()[0], 19200);
  println("changing baudrate to 19200");
  myPort.write("+++");
  println("trying to enter command mode at 19200 baud");

  delay(3000);
    while(myPort.available()>0)
  {
    char a=(char)myPort.read();
    print(a);
  }

  myPort.write("ATCN");
  myPort.write(13);
  while(myPort.available()>0)
  {
    char a=(char)myPort.read();
    print(a);
  }
  println("ok, you're good");
  exit();
}
void keyPressed()
{
   myPort.write(key);
}


