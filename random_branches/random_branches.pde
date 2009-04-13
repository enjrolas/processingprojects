
LinkedList Lines;
float t, s;
float relax=100;
float x,y,theta;
float deltat=.01;
PFont myFont;
int threshhold=50;
int radius=300;
void setup()
{
  Lines=new LinkedList();
  background(0);
  t=0;
  s=1000;
  size(screen.width,screen.height);
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont, 18);
  for(int i=0;i<100;i++)
  {
    x=random(radius);
    theta=acos(x/radius);
    y=random(radius*sin(theta));
    x*=random(2)-1;
    y*=random(2)-1;
    Lines.add(new Point((int)x+width/2,(int)y+height/2));
  }
}

void draw()
{

  background(0);
  fill(0);
  ellipse(width/2,height/2,radius*2,radius*2);
  Point a=new Point(1,1);
  for (int i=0;i<Lines.size();i++)
    {
      a=(Point)Lines.get(i);
    //  a.k=(float)random(100)/100;
      a.vX*=.9;
      a.vY*=.9;
      a.forceX*=.999;  //friction
      a.forceY*=.999;
/*      a.forceX+=a.k*s/a.x;
      a.forceX-=a.k*s/(width-a.x);
      a.forceY+=a.k*s/a.y;
      a.forceY-=a.k*s/(height-a.y);*/
      float phi=atan(abs(a.y-height/2)/abs(a.x-width/2));
      float sideX=width/2+((a.x<width/2)?-1:1)*radius*cos(phi);
      float sideY=height/2+((a.y<height/2)?-1:1)*radius*sin(phi);
      float d=sqrt(pow((sideX-a.x),2)+pow((sideY-a.y),2));
      if(d<50)
      {
 //         line(a.x,a.y,sideX,sideY);
          float f=1*(d-relax);
          a.forceX+=(a.x>sideX?-1:1)*f*cos(phi);
          a.forceY+=(a.y>sideY?-1:1)*f*sin(phi);      
      }
      stroke(255);
      if(i==(Lines.size()-1))
        fill(0,0,255);
      else
        fill(255);
 //     ellipse(a.x,a.y,5,5);
      fill(0);
      for(int j=0;j<Lines.size();j++)
      {
        Point b=(Point)Lines.get(j);
        float distance=sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2));
        if(distance<threshhold*2)
        {
        stroke(0,255,0);          
          line(a.x,a.y,b.x,b.y);
   //      ellipse(a.x,a.y,distance*2,distance*2);
        }
        if(distance<threshhold)
        {
        stroke(255,0,0);          
          line(a.x,a.y,b.x,b.y);
   //      ellipse(a.x,a.y,distance*2,distance*2);
        }

       if(i!=j)
       {
         if(distance<threshhold)
         {
         float force=a.k*(distance-relax);
         float theta=atan(abs(a.y-b.y)/abs(a.x-b.x));
          a.forceX+=(a.x>b.x?-1:1)*force*cos(theta);
          a.forceY+=(a.y>b.y?-1:1)*force*sin(theta);
         }
       }
        
      }
      
      a.vX=a.vX+a.forceX*deltat/a.m;
      a.vY=a.vY+a.forceY*deltat/a.m;
      if(sqrt(pow((a.x-width/2),2)+pow((a.y-height/2),2))<radius)
     {
        a.x=a.x+a.vX*deltat;
        a.y=a.y+a.vY*deltat;
     }
     else
     {
       a.x+=a.x<width/2?1:-1;
       a.y+=a.y<height/2?1:-1;
       a.forceX=0;
       a.forceY=0;
     }
      /*
      if(a.x<0)
        a.forceX*=-1;
      if(a.x>width)
        a.forceX*=-1;
      if(a.y<0)
        a.forceY*=-1;
      if(a.y>height)
        a.forceY*=-1;
        */
      Lines.set(i,a);
      stroke(255,0,0);
  //    line(a.x,a.y,a.x-a.forceX,a.y);
  //    line(a.x,a.y,a.x,a.y-a.forceY);
      
    }
    t+=.0001;
    text(t,0,10);
    text(a.forceX+" "+a.forceY,0,40);
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
    k=.01;
    m=1;
    aX=0;
    aY=0;
    vX=0;
    vY=0;
  }
}

