

import processing.opengl.*;



LinkedList slices;
float radius=100;
float numLayers=20;

int numPoints=20;
float t=0;
int skip=2;
float c=0;
float d=0;
float theta=0;
float numSlices=5;
float angle_step=360/numPoints;
void setup()
{
  size(1200,700);
  slices=new LinkedList();
    slice a=new slice(0);
    slices.add(a);
  //noLoop();
}


void draw()
{
  background(0);
 // camera1.feed();
  stroke(255,0,255);
  slice homeSlice;
  LinkedList levels;

    homeSlice=(slice)slices.get(0);
    levels=homeSlice.levels;
  for(int count=0;count<numLayers;count++)
  {
  fill(0,120,0);
  LinkedList points, nextPoints;
  level a=(level)levels.get(count);
  if(count<numLayers-1)
  {
    level b=(level)levels.get(count+1);
    nextPoints=b.points;
  }
  else
  {
    nextPoints=a.points;
  }
  points=a.points;
  myPoint point1,point2;

  for(int i=0;i<points.size();i++)
  {
    point1=(myPoint)points.get(i);
    if(i>=1)
      point2=(myPoint)points.get(i-1);
    else
    {
      point2=(myPoint)points.get(points.size()-1);
    }
 // stroke(100);
   stroke(255);
  line(width/2+point1.x,height/2+point1.y,width/2+point2.x,height/2+point2.y);
  if(count<numLayers-1)
  {
  //  fill(255*sin((float)count/5+2*t),255*cos((float)count/5+3*t/21),255*cos((float)count/5+2*t/9));
    myPoint nextPoint;
    if((i-1)>=0)
      nextPoint=(myPoint)nextPoints.get(i-1);
    else
      nextPoint=(myPoint)nextPoints.get(nextPoints.size()-1);
if(c>2*PI)
  c=0;
 if(d>2*PI)
   d=0;
  }
    }
  }
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

class slice{
  LinkedList levels;
  slice(float tilt)
  {
    levels=new LinkedList();
    for(int i=0;i<numLayers;i++)
    { 
      level a;
      if(i==0)   
     {
      a=new level(numPoints, radius, skip,0,tilt);
     }
     else
     {
      level b=(level)levels.get(i-1);
      a=new level(numPoints, b.childRadius, skip,b.angle+angle_step, tilt);
     }
   
      levels.add(a);
    }
  }
}

class level{
  
  int numPoints, skip;
  float radius, childRadius, angle, tilt;
  LinkedList points;
  
  level(int num, float rad, int skype, float angel, float tilty)
  {
    points=new LinkedList();
    numPoints=num;
    radius=rad;
    skip=skype;
    angle=angel;
    tilt=tilty;
    newPoints(angel);
  }
void newPoints(float angle)
{
  points.clear();
  theta=angle;
  for(float phi=angle;phi!=360+angle;phi+=2*angle_step)
  { 
    if(phi>(360+angle))
      phi-=360;
     float c,b;
     c=radius;
     b=radius*cos(radians(tilt));
     float x,y;
     y=c*cos(radians(phi));
     x=b*sin(radians(phi));
    points.add(new myPoint(x,y));  
  }
  float beta_angle=3*angle_step/2;
  float gamma=(180-2*angle_step)/2;
  childRadius=radius*sin(radians(beta_angle))/sin(radians(gamma));
  println(radius+" "+childRadius);
//  childRadius=radius*sin(radians(alpha_angle))/sin(radians(gamma));
}
}
