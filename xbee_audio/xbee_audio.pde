import processing.serial.*;

Serial port1, port2;

char []dataPoints;
int index;

void setup()
{
  dataPoints=new char[1000];
  size(1000,600);
  background(0);
  stroke(255,0,0);
  println(Serial.list());
  port1 = new Serial(this, Serial.list()[0], 115200);
  port2 = new Serial(this, Serial.list()[2], 115200);
  for(index=0;index<1000;index++)
    dataPoints[index]=0;
  for(float i=0;i<1000;i++)
  {
    port1.write((char)(128*(sin(degrees(i/1000))+1)));
  }
  index=0;
}
void draw()
{
  while(port2.available()>0)
  {
    dataPoints[index]=(char)port2.read();
    index++;
    if(index>1000)
      index=0;
  }
  for(int i=0;i<999;i++)
  {
    line(i,dataPoints[i],i+1,dataPoints[i+1]);
  }
}


