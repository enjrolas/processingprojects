Point p1,p2;

void setup()
{
  size(800,600);
  p1=new Point(width/2,height/3);
  p2=new Point(width/2,2*height/3);
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
