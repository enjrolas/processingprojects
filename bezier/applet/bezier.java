import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class bezier extends PApplet {

int numCurves=5;
myPoint[][] points=new myPoint[4][numCurves];
myPoint[][] increments=new myPoint[4][numCurves];


int select=0;
float angle=0;
public void setup()
{
  size(600,600,P3D);
  for(int i=0;i<4;i++)
    for(int j=0;j<numCurves;j++)
    {
      points[i][j]=new myPoint();
      increments[i][j]=new myPoint();
      points[i][j].x=(int)random((float)width);
      points[i][j].y=(int)random((float)height);
      points[i][j].y=(int)random((float)width);
      increments[i][j].x=random(3)-1.5f;
      increments[i][j].y=random(3)-1.5f;
      increments[i][j].z=random(3)-1.5f;
    }
}
public void draw()
{
  background(0);
  stroke(0,0,255);
  //  fill(0,255,0);
  //  ellipse(xvalue[select],yvalue[select],5,5);
  noFill();
  strokeWeight(10.0f);
//strokeJoin(ROUND);
//  smooth();
  for(int i=0;i<numCurves;i++)
  {
      points[0][i].x*=sin(angle);
      points[0][i].y*=sin(angle);
      points[3][i].x*=cos(angle);
      points[3][i].y*=cos(angle);

      stroke(points[0][i].x,points[2][i].y,points[3][i].x);
      curve(points[0][i].x,points[0][i].y,points[0][i].z,points[1][0].x,points[1][0].y,points[1][0].z,points[2][0].x,points[2][0].y,points[2][0].z,points[3][i].x,points[3][i].y,points[3][i].z);
      points[0][i].x/=sin(angle);
      points[0][i].y/=sin(angle);
      points[3][i].x/=cos(angle);
      points[3][i].y/=cos(angle);

  }
  for(int i=0;i<4;i++)
    for(int j=0;j<numCurves;j++) 
    {
      points[i][j].x+=increments[i][j].x;
      points[i][j].y+=increments[i][j].y;
      points[i][j].z+=increments[i][j].z;
      if((points[i][j].x>width)||(points[i][j].x<0))
        increments[i][j].x*=-1;
      if((points[i][j].y>width)||(points[i][j].y<0))
        increments[i][j].y*=-1;   
      if((points[i][j].z>width/4)||(points[i][j].z<(-1*width)))
        increments[i][j].z*=-1;   
        
    }
    angle+=.01f;
}


class myPoint{
  float x, y,z;
  myPoint()
  {
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "bezier" });
  }
}
