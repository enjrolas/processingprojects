import processing.serial.*;

byte linear_parameter1=1;
byte linear_parameter2=0;
byte rotary_parameter1=1;
byte rotary_parameter2=0;
boolean pen = true;
int del=0;


byte WAITING =1;
byte MSG_START =2;
byte COMMAND =3;
byte FORWARD =4;
byte BACKWARD =5;
byte left =6;
byte right =7;
byte MSG_END =8;
byte ACK =9;
byte ACTION_COMPLETE =10;
byte PARAMETER1 =11;
byte PARAMETER2 =12;
byte REPORTING =13;
byte GET_X =14;
byte GET_Y =15;
byte GET_BATT =16;
byte DATA_IN =17;
byte LISTENING_FOR_THE_END =19;
byte WTF =20;
byte LISTENING_FOR_A_CHECKSUM= 21;
byte GET_STATUS=27;
byte PEN_UP=28;
byte PEN_DOWN=29;

//! definitions for byte messages that go back and forth between the computer and the logger
final int ACKNOWLEDGE                    =1;
final int ACKNOWLEDGE_AND_CONFIGURE      =2;
final int LISTENING                      =3;
final int CHECKSUM_ERROR_PLEASE_RESEND   =4;
final int CHECKSUM_ERROR_GIVING_UP       =5;
final int DISCOVER_ME                    =6;
final int TIMEOUT_ERROR                  =7;
final int MALFORMED_MESSAGE_ERROR_PLEASE_RESEND     =   8;
final int MALFORMED_MESSAGE_ERROR_GIVING_UP         =   9;
final int MESSAGE_START =128;
final int MESSAGE_END   =129;

Serial myPort;

void setup()
{
  size(200,200);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 19200);

}

void draw()
{
  background(0);
  char a;
  int b;
  while(myPort.available()>0)
  {
    b=myPort.read();
    a=(char) b;
    println(a+" "+b);
//    print((char)myPort.read());
  }
}


void keyPressed()
{
  if(key=='c')  //configure
  {
    configure();
  }
  
}
void configure()
{
    myPort.write(ACKNOWLEDGE_AND_CONFIGURE);
    myPort.write(128);
    myPort.write(0);
    myPort.write(0);
    myPort.write(0);
    myPort.write(0);
    myPort.write(0);
    myPort.write(1);
    myPort.write(1);
    myPort.write(129);
}
