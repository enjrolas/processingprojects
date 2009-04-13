Point p1,p2;
float deltaT=.01;
float k=10;
PFont myFont;
int relax;
void setup()
{
  size(800,600);
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont, 18);
  p1=new Point(width/2,height/3);
  p2=new Point(width/2,2*height/3);
  relax=height/4;
}
void draw()
{
  background(0);
  stroke(0);
  fill(255,0,0);
  ellipse(p1.x,p1.y,5,5);
  fill(0,255,0);
  ellipse(p2.x,p2.y,5,5);
  stroke(0,0,255);
  line(p1.x,p1.y,p2.x,p2.y);
  
  p1.forceY=k*((p2.y-p1.y)-relax);
  p2.forceY=-1*k*((p2.y-p1.y)-relax);

  
  p1.aY=p1.forceY/p1.m;
  p2.aY=p2.forceY/p2.m;
  p1.vY+=p1.aY*deltaT;
  p2.vY+=p2.aY*deltaT;
  p1.y+=p1.vY*deltaT;
  p2.y+=p2.vY*deltaT;
  text(p1.forceY+" "+p2.forceY,0,40);
}
class Point{
  float x, y;
  float forceX, forceY, aX, aY, vX, vY;
  float k,m;
  Point(int a, int b)
  {
    x=a;
    y=b;
    forceX=0;
    forceY=0;
    k=.001;
    m=1;
    aX=0;
    aY=0;
    vX=0;
    vY=0;
  }
}
