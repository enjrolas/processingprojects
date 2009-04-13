import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import java.util.regex.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class random_branches extends PApplet {
LinkedList Lines;
float t, s;
float x,y,theta;
PFont myFont;
int threshhold=50;
int radius=300;
public void setup()
{
  Lines=new LinkedList();
  background(0);
  t=0;
  s=1000;
  size(screen.width,screen.height);
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont, 18);
  for(int i=0;i<50;i++)
  {
    x=random(radius);
    theta=acos(x/radius);
    y=random(radius*sin(theta));
    x*=random(2)-1;
    y*=random(2)-1;
    Lines.add(new Point((int)x+width/2,(int)y+height/2));
  }
}

public void draw()
{

  background(0);
  fill(0);
  ellipse(width/2,height/2,radius*2,radius*2);
  Point a=new Point(1,1);
  for (int i=0;i<Lines.size();i++)
    {
      a=(Point)Lines.get(i);
      a.forceX*=.9f;
      a.forceY*=.9f;
      a.forceX+=a.k*s/a.x;
      a.forceX-=a.k*s/(width-a.x);
      a.forceY+=a.k*s/a.y;
      a.forceY-=a.k*s/(height-a.y);
      stroke(255);
      if(i==(Lines.size()-1))
        fill(0,0,255);
      else
        fill(255);
      ellipse(a.x,a.y,5,5);
      fill(255);
      for(int j=0;j<Lines.size();j++)
      {
        Point b=(Point)Lines.get(j);
        float distance=sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2));
        stroke(0,255,0);
        if(distance<threshhold)
          line(a.x,a.y,b.x,b.y);
       if(i!=j)
       {
         
         float force=a.k*s/distance;
         float theta=atan((a.y-b.y)/(a.x-b.x));
          a.forceX+=force*cos(theta);
          a.forceY+=force*sin(theta);
       }
        
      }
      
      a.vX=a.vX+a.forceX*t/a.m;
      a.vY=a.vY+a.forceY*t/a.m;
      if(sqrt(pow((a.x-width/2),2)+pow((a.y-height/2),2))<radius)
     {
        a.x=a.x+a.vX*t;
        a.y=a.y+a.vY*t;
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
      line(a.x,a.y,a.x-a.forceX,a.y);
      line(a.x,a.y,a.x,a.y-a.forceY);
      
    }
    t+=.0001f;
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
    k=.001f;
    m=1;
    aX=0;
    aY=0;
    vX=0;
    vY=0;
  }
}


  static public void main(String args[]) {     PApplet.main(new String[] { "random_branches" });  }}