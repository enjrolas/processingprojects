import processing.serial.*;

Serial myPort;  // The serial port
int[][]voltage =new int[1000][2];
  int data[]=new int[100];
  int index;
int vindex;

void setup() {
  size(screen.width, screen.height);
  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
for(int i=0;i<100;i++)
  for(int j=0;j<2;j++)
    voltage[i][j]=0;

  vindex=0;
}

void draw()
{


  myPort.write('0');
  index=0;
  delay(100);
  while(myPort.available()>0)
  {
      data[index]=myPort.read();
      index++;
  }
  if(data[1]=='0')
  {
    voltage[vindex][0]=data[0];
    println(data[0]);
  }

  myPort.write('1');
  index=0;
  delay(100);
  while(myPort.available()>0)
  {
      data[index]=myPort.read();
      index++;
  }
  if(data[1]=='1')
  {
    voltage[vindex][1]=data[0];
    println(data[0]);
  }
  vindex++;
    if(vindex==1000)
      vindex=0;
  myPort.clear();
  
  background(0);
  stroke(0,255,0);
  for(int i=0;i<999;i++)
  {
     stroke(0,255,0);
     line(i,3*voltage[i][0],i+1,3*voltage[i+1][0]);
     stroke(0,0,255);
     line(i,3*voltage[i][1],i+1,3*voltage[i+1][1]);

  }
       fill(255,0,0);
     ellipse(vindex,3*voltage[vindex][0],5,5);
     ellipse(vindex,3*voltage[vindex][1],5,5);
}
