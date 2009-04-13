float xrotation, yrotation;

void setup()
{
  size(500,500,P3D);
}

void draw()
{
background(0);
stroke(0,255,0);
fill(0);
strokeWeight(4);
translate(250, 250, 0); 
rotateX(-1*yrotation);
rotateY(xrotation);
box(200);
}

void mouseDragged()
{
  xrotation+=((float)mouseX-(float)pmouseX)/100;
  yrotation+=((float)mouseY-(float)pmouseY)/100;
  println(xrotation+" "+yrotation);
}
