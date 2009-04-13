import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class xbee_config_from_9600_to_19200 extends PApplet {




Serial myPort;  // The serial port
float t=0;
float f=2000;
float x=0;
float inc=.1f;
boolean lin=false;

public void setup() {
  size(200,200);
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  noLoop();
}

public void draw()
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
public void keyPressed()
{
   myPort.write(key);
}



  static public void main(String args[]) {
    PApplet.main(new String[] { "xbee_config_from_9600_to_19200" });
  }
}
