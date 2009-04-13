void setup()
{
  size(screen.width, screen.height);  
  noLoop();
}

boolean threshhold(color a, color b)
{
  int redThreshhold=100;
  int blueThreshhold=100;
  int greenThreshhold=100;
  return((abs(red(a)-red(b))>redThreshhold)&&(abs(green(a)-green(b))>greenThreshhold)&&(abs(blue(a)-blue(b))>blueThreshhold));
    
}

color bwThreshhold(color a)
{
  int threshhold=25;
  if(red(a)+green(a)+blue(a)>(3*threshhold))
    return color(255,255,255);
  else
    return color(0,0,0);
}

void draw()
{
  PImage img = loadImage("/Users/nikki/Documents/Processing/images/river.jpg");
int dimension = (img.width*img.height);
loadPixels();
for (int i=0; i<img.height;i++)
{
  for(int j=0;j<img.width-1;j++)
    {
      color a=img.pixels[i*img.width+j];
      color b=img.pixels[i*img.width+j+1];
/*      if(threshhold(a,b))
        img.pixels[i*img.width+j+1]=color(255,255,255);
      else
        img.pixels[i*img.width+j+1]=color(0,0,0);*/
        img.pixels[i*img.width+j]=bwThreshhold(color(abs(red(a)-red(b)),abs(green(a)-green(b)),abs(blue(a)-blue(b))));
    }
}
  

updatePixels();
image(img, 0, 0);
}
