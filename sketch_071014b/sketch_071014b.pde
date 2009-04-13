import processing.opengl.*;

 	

 	

// Example by Tom Igoe

import processing.serial.*;


Serial myPort;    // The serial port:
PFont myFont;     // The display font:
String inString;  // Input string from serial port:
int lf = 10;      // ASCII linefeed
float[] gyro;
float[] accelerometer;
float angleX=0;
float angleY=0;
float angleZ=0;
float velX=0,posX=0,velY=0,posY=0,velZ=0,posZ=0;
float t=0;
float avgX,avgY,avgZ,accumX,accumY,accumZ=0;
float accum_accelerometerX,accum_accelerometerY,accum_accelerometerZ,avg_accelerometerX,avg_accelerometerY,avg_accelerometerZ=0;
int frames=0;
boolean averaging=true;
boolean offset=true;
boolean position=false;
boolean line=true;
boolean box=false;

void setup() {
  size(600,400,OPENGL);
  gyro=new float[]{0,0,0};
  accelerometer=new float[]{0,0,0};
  // Make your own font. It's fun!
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont, 18);
  // List all the available serial ports:
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[2], 57600);
  myPort.write(7);
  myPort.buffer(100);
  myPort.bufferUntil(lf);
  println("woowii");
}

void draw() {
  background(190,60,150);
    if(inString!= null)
    {
    String[] myString = split(inString, " ");
    for(int i=0;i<myString.length;i++)
    {
    myString[i]=myString[i].trim();
    }   
    if(myString.length>12)
    {
      if(myString[12].indexOf("Z")==-1)
      {
      if(myString[1].compareTo("")>0)
    gyro[0]=(Integer.parseInt(myString[1])-512);
      if(myString[4].compareTo("")>0)
    gyro[1]=(Integer.parseInt(myString[4])-512);
      if(myString[7].compareTo("")>0)
    gyro[2]=(Integer.parseInt(myString[7])-512);
      if(myString[10].compareTo("")>0)
    accelerometer[0]=(Integer.parseInt(myString[10])-512);
      if(myString[11].compareTo("")>0)
    accelerometer[1]=(Integer.parseInt(myString[11])-512);
      if(myString[12].compareTo("")>0)
    accelerometer[2]=(Integer.parseInt(myString[12])-512);
      }
    }
  text("received: " + inString, 10,50);
  text(gyro[0]+" "+gyro[1]+" "+gyro[2]+" "+accelerometer[0]+" "+accelerometer[1]+" "+accelerometer[2],10,70);
    if(averaging)
  {
    frames++;
    accumX+=gyro[0];
    accumY+=gyro[1];
    accumZ+=gyro[2];
    avgX=accumX/frames;
    avgY=accumY/frames;
    avgZ=accumZ/frames;
    
    accum_accelerometerX+=accelerometer[0];
    accum_accelerometerY+=accelerometer[1];
    accum_accelerometerZ+=accelerometer[2];
    avg_accelerometerX=accum_accelerometerX/frames;
    avg_accelerometerY=accum_accelerometerY/frames;
    avg_accelerometerZ=accum_accelerometerZ/frames;
    
    text("averaging:  "+avgX+" "+avgY+" "+avgZ,10,90);
  }
  if(offset)
  {
    gyro[0]-=avgX;
    gyro[1]-=avgY;
    gyro[2]-=avgZ;
    
/*    accelerometer[0]-=avg_accelerometerX;
    accelerometer[1]-=avg_accelerometerY;
    accelerometer[2]-=avg_accelerometerZ;
    */
    
  }
  velX+=(float)accelerometer[0]/(float)1000;
  posX+=velX/10;
  velY+=(float)accelerometer[1]/(float)1000;
  posY+=velY/10;
  velZ+=(float)accelerometer[2]/(float)1000;
  posZ+=velZ/10; 

  
//  translate(100*sin(t)+width/2,50*sin(2*t)+height/2,100*cos(.5*t));
//  translate(width/2,height/2);

if(line)
{
  line(width/2,height/2,0,width/2,height/2+accelerometer[1],accelerometer[0]);
  text(accelerometer[2] + " " + accelerometer[1] + " " + accelerometer[0],10,150);
}
if(box)
{
    if(position)
    translate(posX+width/2,posY+height/2,posZ);
  else
    translate(width/2,height/2);
  angleX+=(float)gyro[0]/(float)100;
  rotateX(radians(angleY));
  angleY+=(float)gyro[1]/(float)100;
  rotateY(radians(angleZ));
  angleZ+=(float)gyro[2]/(float)100;
  rotateZ(-1*radians(angleX));
  box(100,50,100);
}
  t+=.01;
    }
}
    
void serialEvent(Serial p) {
  inString = (myPort.readString());
  println(inString);
}

void keyPressed() {
  if (key == ' ') {
  averaging=!averaging;  
  }
  if(key=='o'){
  offset=!offset;  
  } 
  if(key=='z'){
    angleX=0;
    angleY=0;
    angleZ=0;
    frames=0;
    accumX=0;
    accumY=0;
    accumZ=0;
    println("zero");
  }
  if(key=='p'){
    position=!position;
  }
  if(key=='b')
    box=!box;
  if(key=='l')
   line=!line; 
}
