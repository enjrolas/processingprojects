import processing.dxf.*;

int VerticalAxis, HorizontalAxis;
int MirrorAxis;
float x, x1, y;
float inc=.1;
float a=.0025;
float focus=1/(4*a);
float end=200;
float margin=50;
float angle=45;
void setup()
{
  size(screen.width, screen.height,P3D);
  VerticalAxis=width/4;
  MirrorAxis=width/2;
  HorizontalAxis=3*height/4;
  noLoop();
}
void draw()
{
   beginRaw(DXF, "output.dxf");
  background(255);
  stroke(255,0,0);
  //fill(0,255,0);
  rect(MirrorAxis-VerticalAxis-end-margin,HorizontalAxis-(a*end*end)-margin,2*VerticalAxis+2*end+2*margin,a*end*end + 2*margin);
  stroke(0,0,255);
  line(MirrorAxis, HorizontalAxis-(a*end*end)-margin, MirrorAxis, HorizontalAxis+margin);
  stroke(255,0,0);
  ellipse(MirrorAxis-VerticalAxis,HorizontalAxis-focus,5,5);  
  ellipse(MirrorAxis+VerticalAxis,HorizontalAxis-focus,5,5);
  for(x1=-1*end;x1<end;x1+=inc)
  {
    x=x1*cos(degrees(angle));
    y=a*x*x;
    line(MirrorAxis-VerticalAxis+x,HorizontalAxis-y,MirrorAxis-VerticalAxis+x+inc,HorizontalAxis-a*(x+inc)*(x+inc));
    line(MirrorAxis+VerticalAxis+x,HorizontalAxis-y,MirrorAxis+VerticalAxis+x+inc,HorizontalAxis-a*(x+inc)*(x+inc));
  }
  endRaw();
}
