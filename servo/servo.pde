import processing.serial.*;



Serial myPort;    // The serial port:

// ================================================== 
// setup() 
// ================================================== 
void setup() 
{ 
	// Size of applet 

 	// Capture 

  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 19200);
  move_servo(0,279);

} 
 
// ================================================== 
// draw() 
// ================================================== 

 
    
void move_servo(int address, int value)
{
   myPort.write(Integer.toString(address));   
   myPort.write(13);
   myPort.write(Integer.toString(value));   
   myPort.write(13);
   
   
}

void keyPressed()
{

}
