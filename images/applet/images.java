import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import java.util.regex.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class images extends PApplet {public void setup()
{
  size(screen.width, screen.height);  
  noLoop();
}

public boolean threshhold(int a, int b)
{
  int redThreshhold=100;
  int blueThreshhold=100;
  int greenThreshhold=100;
  return((abs(red(a)-red(b))>redThreshhold)&&(abs(green(a)-green(b))>greenThreshhold)&&(abs(blue(a)-blue(b))>blueThreshhold));
    
}

public int bwThreshhold(int a)
{
  int threshhold=25;
  if(red(a)+green(a)+blue(a)>(3*threshhold))
    return color(255,255,255);
  else
    return color(0,0,0);
}

public void draw()
{
  PImage img = loadImage("/Users/nikki/Documents/Processing/images/river.jpg");
int dimension = (img.width*img.height);
loadPixels();
for (int i=0; i<img.height;i++)
{
  for(int j=0;j<img.width-1;j++)
    {
      int a=img.pixels[i*img.width+j];
      int b=img.pixels[i*img.width+j+1];
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

  static public void main(String args[]) {     PApplet.main(new String[] { "images" });  }}