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
  myPort = new Serial(this, Serial.list()[0], 115200);
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
  println("enabling PWM output");
  myPort.write("ATP12");
  myPort.write(13);
  myPort.write("ATWR");
  myPort.write(13);
  println("saving changes to non-volatile memory");
  myPort.write("ATCN");
  myPort.write(13);
  println("leaving command mode");
  delay(2000);
  myPort.write("+++");
  delay(2000);
  myPort.write("ATM10x01FF");
  myPort.write(13);
  myPort.write("ATAC");
  myPort.write(13);
  myPort.write("ATCN");
  myPort.write(13);
  exit();
}
