float threshhold=10;
float inc=1;

PImage img;

void setup()
{
 size(screen.width, screen.height);
 background(0);
  noLoop();
}

color threshhold(color a, color b)
{
  int redThreshhold=10;
  int blueThreshhold=10;
  int greenThreshhold=10;
  float redpart=0, greenpart=0, bluepart=0;
  if(abs(red(a)-red(b))>redThreshhold)
    redpart=255;
  if(abs(green(a)-green(b))>greenThreshhold)
    greenpart=255;
  if(abs(blue(a)-blue(b))>blueThreshhold)
    bluepart=255;
    
  
  return color(redpart, greenpart, bluepart);   
}
color derivative(color a, color b)
{

  float redpart=0, greenpart=0, bluepart=0;
    redpart=abs(red(a)-red(b));
    greenpart=abs(green(a)-green(b));
    bluepart=abs(blue(a)-blue(b));
    
  
  return color(redpart, greenpart, bluepart);   
}

color bwThreshhold(color a)
{

  if(red(a)+green(a)+blue(a)>(3*threshhold))
    return color(255,255,255);
  else
    return color(0,0,0);
}

void draw()
{
  img = loadImage("/Users/nikki/Documents/Processing/routing_faces/gulls.jpg");
  threshhold+=inc;
  if((threshhold>40)||(threshhold==0))
    inc*=-1;
int dimension = (img.width*img.height);
loadPixels();

  PrintWriter out=createWriter("output.sbp");
double xoffset=10;
double yoffset=.5;
double xdim=5*1.3;
double ydim=5;
  out.println("IF %(25)=1 THEN GOTO UNIT_ERROR\r\n");
  out.println("SA\r\n");
  out.println("MS, 6, 3\r\n");
  out.println("JZ,2\r\n");
  out.println("J2,"+xoffset+","+yoffset+"\r\n");
  out.println("PAUSE 2\r\n");
double radius=1;
double height=0;
float theta;


for(height=0;height<1;height+=.1)
for(radius=0;radius<1;radius+=.1)
for(theta=0;theta<2*PI;theta+=.01)
{
   out.println("M3, "+xoffset+radius*cos(theta)+","+yoffset+radius*sin(theta)+","+height+"\r\n");
}



/*
for (int i=0; i<img.height;i++)
{
  for(int j=0;j<img.width-1;j++)
    {
      color a=img.pixels[i*img.width+j];
      color b=img.pixels[i*img.width+j+1];
     //   img.pixels[i*img.width+j]=bwThreshhold(color(abs(red(a)-red(b)),abs(green(a)-green(b)),abs(blue(a)-blue(b))));
       // img.pixels[i*img.width+j]=threshhold(a,b);
       img.pixels[i*img.width+j]=derivative(a,b);
    }
}

*/
 //vertical derivative
/*
for (int i=0; i<img.width;i++)
{
  for(int j=0;j<img.height-1;j++)
    {
      color a=img.pixels[j*img.width+i];
      color b=img.pixels[(j+1)*img.width+i];
     //   img.pixels[i*img.width+j]=bwThreshhold(color(abs(red(a)-red(b)),abs(green(a)-green(b)),abs(blue(a)-blue(b))));
       // img.pixels[i*img.width+j]=threshhold(a,b);
       img.pixels[j*img.width+i]=derivative(a,b);
    }
}
  

updatePixels();
image(img, 0, 0);
img.save("flower-vertical-derivative.jpg");

*/
}
