import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class bridget_riley extends PApplet {float t=0;
float x,y;
float xinc=-.1f;
float yinc=.1f;
int rad=30;
public void setup()
{
  size(800,600,P3D);
  x=4*width/5;
  y=6*height/7;
}
public void draw()
{
  background(0);
  stroke(30,30,255);
  float a, b, aOld, bOld, amplitude;
  amplitude=10;
  for(float offset=-1*amplitude;offset<width+amplitude;offset+=6+sin(t/100000))
  {
    aOld=0;
    bOld=0;
  for(a=0*sin(t/1000);a<height;a++)
  {
    b=offset+amplitude*sin(a*a/15000);
    line(bOld,a,b,a);
    aOld=a;
    bOld=b;
    t+=.0001f;
  }
  }
  fill(0);
  stroke(0);
  ellipse(x,y,rad,rad);
  x+=xinc;
  y+=yinc;
  if((x<rad)||(x>width-rad))  
    xinc*=-1;
  if((y<rad)||(y>height-rad))
    yinc*=-1;
 }


  static public void main(String args[]) {     PApplet.main(new String[] { "bridget_riley" });  }}