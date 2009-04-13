float xposition, yposition;
float xvelocity, yvelocity;
float xacceleration, yacceleration;

void setup()
{
  size(500,500,P3D);
  xposition=0;
  yposition=0;
  xvelocity=0;
  yvelocity=0;
  xacceleration=0;
  yacceleration=0;
}

void draw()
{
background(0);
stroke(0,255,0);
fill(0);
strokeWeight(4);
translate(250, 250, 0); 
rotateX(-1*yposition);
rotateY(xposition);
box(200);
xposition+=xvelocity;
yposition+=yvelocity;
xvelocity+=xacceleration;
yvelocity+=yacceleration;
}

void mouseDragged()
{
  xacceleration=((float)mouseX-(float)pmouseX)/100;
  yacceleration+=((float)mouseY-(float)pmouseY)/100;
}

void mouseReleased()
{
  xacceleration=0;
  yacceleration=0;
}
