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
  out.println("SO,1,1\r\n");
  out.println("PAUSE 2\r\n");
  out.println("MS, 6, 3\r\n");
  out.println("JZ,2\r\n");
  out.println("J2,"+xoffset+","+yoffset+"\r\n");

int divider=3;
for (int i=0; i<img.height;i+=divider)
{
  for(int j=0;j<img.width;j+=divider)
    {
          color myColor=img.pixels[i*img.width+j];
          double z=(double)red(myColor)+(double)blue(myColor)+(double)green(myColor);
          z*=100.0/(3.0*255.0);
          z*=1.0/100.0;
          String zString=nf((float)z,3,3);
          double x=(double) j * 100/(double)img.width;
          x*=xdim/100.0;
          x+=xoffset;
          String xString=nf((float)x,3,3);
          double y=(double) i * 100/(double)img.height;
          y*=ydim/100.0;
          y+=yoffset;
          String yString=nf((float)y,3,3);
          println("M3,"+xString+","+yString+","+zString+"\r\n");
          out.println("M3,"+xString+","+yString+","+zString+"\r\n");
          fill((int)(z*255));
          ellipse((int)((x-xoffset)*100),(int)((y-yoffset)*100),20,20);
    }
    i+=divider;
  if(i<img.height)
  {
  for(int j=img.width;j>=0;j-=divider)
    {
          color myColor=img.pixels[i*img.width+j];
          double z=red(myColor)+blue(myColor)+green(myColor);
          z*=100.0/(3.0*255.0);
          z*=1.0/100.0;
          String zString=nf((float)z,3,3);
          double x=(double) j * 100/img.width;
          x*=xdim/100;
          x+=xoffset;
          String xString=nf((float)x,3,3);
          double y=(double) i * 100/img.height;
          y*=ydim/100.0;
          y+=yoffset;
          String yString=nf((float)y,3,3);
          out.println("M3,"+xString+","+yString+","+zString+"\r\n");
         fill((int)(z*255));
          ellipse((int)((x-xoffset)*100),(int)((y-yoffset)*100),5,5);
    }
  }
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
