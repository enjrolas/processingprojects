import processing.serial.*;

class logobot_waypoint{
  float r, theta;
  logobot_waypoint(float a, float b)
  {
    r=a;
    theta=b;
  }
}


Serial myPort;  // The serial port
PFont myFont;
PrintWriter output;
int x, y;
int servo=200;
LinkedList myPoints, myWaypoints;
int margin=10;
boolean logging=false;
boolean target_mode=false;
int target=222;
Point myPoint, myOtherPoint;
void setup() {
  size(screen.width, screen.height);
  myFont=createFont("AcademyEngravedLetPlain",18);
  textFont(myFont);
  output=createWriter("log.csv");
  x=0;
  y=0;
  myPoints=new LinkedList();
  myWaypoints = new LinkedList();
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void update_x()
{
  myPort.write(7);
  while(myPort.available()==0)
    ;
  int num=myPort.read();
  if(num>127)
    num-=256;
  x=num;
}

void update_y()
{
  myPort.write(8);
  while(myPort.available()==0)
    ;
  int num=myPort.read();
  if(num>127)
    num-=256;
  y=num;
}

void draw()
{
  background(0);
  update_x();
  update_y();
  /*if(logging)
   {
   output.println(x+" "+y);
   
   }*/
  float angle=(float)x*(float)360/(float)11245;
  text(x,600,20);
  text(y,600,40);
  text(angle,600,60);
  if(target_mode)
  { 
    if(y>(target+margin))
      myPort.write(0);
    if(y<(target-margin))
      myPort.write(1);
    else
    {
      myPort.write(6);
      target_mode=false;
    }
  }
  myWaypoints.add(new logobot_waypoint((float)y, (float)x*(float)360/(float) 9000));
  /*int xmax=1;
   int ymax=1;
   for(int i=0;i<myPoints.size();i++)
   {
   Point a=(Point)myPoints.get(i);
   if(abs(a.x)>xmax)
   xmax=abs(a.x);
   if(abs(a.y)>ymax)
   ymax=abs(a.y);
   }
   myOtherPoint=(Point)myPoints.get(myPoints.size()-1);
   */
  float pointx=screen.width/2;
  float pointy=screen.height/2;
  float theta=0;
  for(int i=0;i<myWaypoints.size()-1;i++)
  {
    logobot_waypoint a=(logobot_waypoint)myWaypoints.get(i);
    theta+=a.theta;
    pointx+=a.r*cos(radians(theta))/10;
    pointy+=a.r*sin(radians(theta))/10;
    //fill(255*i/myPoints.size(),(myPoints.size()-i)*255/myPoints.size(),0);
    fill(255);
    ellipse(pointx,pointy,5,5);
    println(x+" "+y+" "+pointx+" "+pointy+" "+a.theta+" "+myWaypoints.size());
  }  

  stroke(0,255,0);
  fill(255,0,0);

  //ellipse((myOtherPoint.x*screen.width/(2*xmax))+screen.width/2,( myOtherPoint.y*screen.height/(2*ymax)) +screen.height/2, 10,10);

  //  byte a=0;
}

void keyPressed()
{
  if(keyCode==UP)
  {
    myPort.write(1);
    x=0;
    y=0;
  }
  if(keyCode==DOWN)
  {
    myPort.write(0);
    x=0;
    y=0;
  }
  if(keyCode==LEFT)
  {
    x=0;
    y=0;
    myPort.write(2);
    logging=true;
  }
  if(keyCode==RIGHT)
  {
    myPort.write(3);  
    x=0;
    y=0;
  }
  if(key=='u')
    myPort.write(4);
  if(key=='d')
    myPort.write(5);
  if(key==' ')
  {
    myPort.write(6);
    output.flush();
    logging=false;
  }
  if(key=='f')
  {
    target_mode=true;
    target=1000;

  }  
  if(key=='z')
  {
    x=0;
    y=0;
    myPoints.clear();
    myWaypoints.clear(); 
  }
  if(key=='q')
  {
    exit();
    output.close();
  }
  if(key=='a')
  {
    servo+=10;
    myPort.write(9);
    println(servo);
  }
  if(key=='s')
  {
    servo-=10;
    myPort.write(10);
    println(servo);
  }
}
