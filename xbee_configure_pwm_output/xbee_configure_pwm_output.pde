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
  myPort.write("ATP02");
  
  myPort.write("ATWR");
  myPort.write(13);
  println("saving changes to non-volatile memory");
  myPort.write("ATCN");
  myPort.write(13);
  println("leaving command mode");
  delay(2000);
 
  myPort.write("+++");
  delay(2000);
  
  float i=0;
  float frequency=100;
  while(true)
  {
    i+=.01;
    println(i);
    myPort.write("ATM0  "+Integer.toHexString((int)(1023*(sin(frequency*i)+1))));  //tack on the hex string for the PWM value here
    myPort.write("ATAC");
  }
  

}  
  
