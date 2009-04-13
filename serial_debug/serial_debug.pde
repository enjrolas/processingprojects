import processing.serial.*;






int WAITING =1;
int MSG_START =2;
int COMMAND =3;
int FORWARD =4;
int BACKWARD =5;
int left =6;
int right =7;
int MSG_END =8;
int ACK =9;
int ACTION_COMPLETE =10;
int PARAMETER1 =11;
int PARAMETER2 =12;
int REPORTING =13;
int GET_X =14;
int GET_Y =15;
int GET_BATT =16;
int DATA_IN =17;
int LISTENING_FOR_THE_END =19;
int WTF =20;
int LISTENING_FOR_A_CHECKSUM= 21;
int LISTENING =22;

Serial myPort;

void setup()
{
  size(200,200);
    println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 19200);
  //  myPort.write(2);
    myPort.clear();
    
}

void draw()
{
    while(myPort.available()>0)
    {
      print((char)myPort.read());
    }
    //println();
}

void keyPressed()
{
// exit();
}
    
