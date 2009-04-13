import processing.opengl.*;


LinkedList levels;

float radius=350;
int numPoints=9;
int skip=2;
float theta=0;
float phi=0;
int layers=1;
float angle_step=360/numPoints;
void setup()
{
  size(1200,700, OPENGL);
  levels=new LinkedList();
  for(int i=0;i<layers;i++)
  { 
    level a;
   if(i==0)   
   {
    a=new level(numPoints, radius, skip,30);
   }
   else
   {
    level b=(level)levels.get(i-1);
    a=new level(numPoints, b.childRadius, skip,b.angle+angle_step/2);
   }
   
    levels.add(a);
  }
}


void draw()
{
  background(0);
  stroke(255,0,255);
  for(int count=0;count<layers;count++)
  {
  fill(0);
  LinkedList intersections, points;
  level a=(level)levels.get(count);
  intersections=a.intersections;
  points=a.points;
  myPoint point1,point2,intersection;
 // ellipse(width/2,height/2,a.radius*2,a.radius*2);
  int i=0;
  phi=0;
  for(int j=0;j<numPoints;j++)
  {
  do{
    point1=(myPoint)points.get(i);
    intersection=(myPoint)intersections.get(i);
    myPoint intersectiona, intersectionb;
    fill(0,0,255);
    if(i>=1)
    {
      intersectionb=(myPoint)intersections.get(i-1);
    }
    else
      intersectionb=(myPoint)intersections.get(i-1+numPoints);
    if(i>=2)
    {
      intersectiona=(myPoint)intersections.get(i-2);
    }
    else
      intersectiona=(myPoint)intersections.get(i-2+numPoints);
   //   println(count);
  // //if(count<3)
  //    triangle(point1.x,point1.y,intersectiona.x,intersectiona.y,intersectionb.x,intersectionb.y); 

    fill(0,0,255);
   // ellipse(intersection.x,intersection.y,5,5);
    i+=skip;
    if(i>=numPoints)
      i-=numPoints;
    point2=(myPoint)points.get(i);
  stroke(255);
 // line(point1.x,point1.y,point2.x,point2.y);
 // line(width/2+a.radius*cos(radians(a.angle+theta)),height/2+a.radius*sin(radians(a.angle+theta)),width/2+a.radius*cos(radians(a.angle+theta+2*angle_step)),a.radius*sin(radians(phi)),height/2+a.radius*sin(radians(a.angle+theta+2*angle_step)),a.radius*sin(radians(phi)));
  line(width/2+a.radius*cos(radians(a.angle+theta))*sin(radians(phi)),height/2+a.radius*sin(radians(a.angle+theta))*cos(radians(phi)),0,width/2+a.radius*cos(radians(a.angle+theta+2*angle_step))*sin(radians(phi)),height/2+a.radius*sin(radians(a.angle+theta+2*angle_step))*cos(radians(phi)),0);
  theta+=angle_step;
  if(theta>360)
    theta-=360;
    
 //   line(width/2+((point1.x-width/2)*cos(theta)),height/2+((point1.y-height/2)*sin(theta)),width/2+((point2.x-width/2)*cos(theta)),height/2+((point2.y-height/2)*sin(theta)));
  //  line(point1.x+a.radius*cos(theta),point1.y+a.radius*sin(theta),point2.x+a.radius*cos(theta),point2.y+a.radius*sin(theta));
  // line(point1.x+a.radius*cos(theta),point1.y,point2.x+a.radius*cos(theta),point2.y);
 // roke(0,0,255);
  //line(width/2,height/2,point1.x,point1.y);
  }while(i!=0);
  phi+=360/numPoints;
  }
  }
  theta+=.05;
}

class myPoint{
  float x,y;
  myPoint(float a, float b)
  {
    x=a;
    y=b;
  }
}

class myLine{
  float a,b;
  myLine(float i, float j)
  {
    a=i;
    b=j;
  }
}

class level{
  
  int numPoints, skip;
  float radius, childRadius, angle;
  LinkedList points, lines, intersections;
  
  level(int num, float rad, int skype, float angel)
  {
    points=new LinkedList();
    lines=new LinkedList();
    intersections=new LinkedList();
    numPoints=num;
    radius=rad;
    skip=skype;
    angle=angel;
    newPoints(angel);
    findLines();
    findIntersections();
  }
void newPoints(float angle)
{
  points.clear();
  float theta=angle;
  for(int i=0;i<numPoints;i++)
  { 
    points.add(new myPoint(width/2+radius*cos(radians(theta)),height/2+radius*sin(radians(theta))));
    theta+=360/numPoints;
  }
}

void findLines()
{
  for(int i=0;i<numPoints;i++)
  {
    myLine liney;
    myPoint point1,point2;
    float a,b;
      point1=(myPoint)points.get(i);
    if(i<=(numPoints-3))
      point2=(myPoint)points.get(i+2);
    else
    {
     // println(i+ " "+(i+2-numPoints));
      point2=(myPoint)points.get(i+2-numPoints);
    }
      b=(point1.y-point2.y)/(point1.x-point2.x);
      a=point1.y-(point1.x*b);
      liney=new myLine(a,b);
     // println(a+" "+b);
      lines.add(liney);
  }
}
void findIntersections()
{
  for(int i=0;i<numPoints;i++)
  {
   float x,y;
   float a1,a2,b1,b2;
   myLine line1,line2;
   myPoint point1;
   point1=(myPoint)points.get(i);
   line1=(myLine)lines.get(i);
   if(i<=(numPoints-2))
     line2=(myLine)lines.get(i+1);
  else
  {
     line2=(myLine)lines.get(i+1-numPoints);
  //  println(i+1-numPoints);
  }
  x=((line1.a-line2.a)/(line2.b-line1.b));
  y=line1.a+line1.b*x;
  intersections.add(new myPoint(x,y));
  }
  myPoint rad;
  rad=(myPoint)intersections.get(0);
  childRadius=sqrt(pow((rad.x-width/2),2)+pow(rad.y-height/2,2));
}
}
