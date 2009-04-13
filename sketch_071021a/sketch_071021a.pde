import ddf.minim.*;
 
AudioPlayer song;
 
void setup()
{
  size(100, 100);
 
  // always start Minim first!
  Minim.start(this);
 
  // this loads mysong.wav from the data folder
  song = Minim.loadFile("mysong.wav");
  song.play();
}
 
void draw()
{
  background(0);
}
 
void stop()
{
  song.close();
  super.stop();
}
