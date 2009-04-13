PImage joystick, slider;

int snadbox_height=screen.height*3/4;

void setup()
{
 size(screen.width, screen.height);
 joystick=loadImage("/Users/nikki/Documents/Processing/transmitter/joystick.jpg");
 slider=loadImage("/Users/nikki/Documents/Processing/transmitter/slider.jpg");  
}
void draw()
{
  background(255);
  image(joystick, sandbox_height+50,10);
  image(slider, sandbox_height+50, joystick.width+20);
}

/*
class Joystick{
  
  Joystick()
  {
  }
}

*/
