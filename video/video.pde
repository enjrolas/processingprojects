

import processing.video.*;

Capture myMovie;
color [] oldPixels;
color [] currentPixels;
int t;
void setup() {
  t=0;
  size(320, 240);
  colorMode(RGB,255);
  myMovie = new Capture(this, width, height, 30);
  oldPixels=new color[width*height];
  currentPixels=new color[width*height];
  //myMovie = new Movie(this, "/Users/nikki/Documents/Processing/video/alex.mov");
  //myMovie.loop();
}

color derivative(color a, color b)
{

  float redpart=0, greenpart=0, bluepart=0;
  redpart=abs((a >> 16 & 0xFF)-(b >> 16 & 0xFF));
  greenpart=abs((a >> 8 & 0xFF)-(b >> 8 & 0xFF));
  bluepart=abs((a & 0xFF)-(b & 0xFF));


  return color(redpart, greenpart, bluepart);  
}

void spatialDerivative()
{
  for (int i=0; i<myMovie.height;i++)
  {
    for(int j=0;j<myMovie.width-1;j++)
    {
      color a=myMovie.pixels[i*myMovie.width+j];
      color b=myMovie.pixels[i*myMovie.width+j+1];
      myMovie.pixels[i*myMovie.width+j]=derivative(a,b);
    }
  }
}

void timeDerivative()
{ 
  for (int i=0; i<myMovie.height;i++)
  {
    for(int j=0;j<myMovie.width;j++)
    {
      color a=myMovie.pixels[i*myMovie.width+j];
      color b=oldPixels[i*myMovie.width+j];
      //       myMovie.pixels[i*myMovie.width+j]=derivative(a,b);
      myMovie.pixels[i*myMovie.width+j]=oldPixels[i*myMovie.width+j];

    }
  }
}

void draw() {
  if(myMovie.available())
  {
    println("yeah!");
    myMovie.read();
  }
  else
    println("d'oh!");
  loadPixels();
  currentPixels=myMovie.pixels;
  if(t!=0)
    timeDerivative();
  //  spatialDerivative();  
  if(t==0)
  {
    oldPixels=currentPixels;
    oldPixels[5000]=color(255,0,0);
    oldPixels[5001]=color(0,255,0);
    oldPixels[5002]=color(0,0,255);
    println("update!");
  }
  updatePixels();
  t++;

  image(myMovie, 0, 0);
}

