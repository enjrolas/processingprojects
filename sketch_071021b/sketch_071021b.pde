import ddf.minim.*;
import ddf.minim.analysis.*;

AudioPlayer song;
 FFT fft;
   float r=350;
void setup()
{
  size(1024, 768);
 
  // always start Minim first!
  Minim.start(this);

  //at 44100 samples/sec, we want 1.8 seconds of data
  //bufferSize=1.8*441400=79380
  // this loads mysong.wav from the data folder
//  song = Minim.loadFile("Boy.mp3",79380);
  song = Minim.loadFile("Boy.mp3",79380);
  //song.play();
 // AudioSample sample=Minim.loadSample("Boy.mp3",2000);
 /* for(int i=100;i<1000;i++)
    println(sample.mix.get(i));*/
  //fft = new FFT(song.bufferSize(), song.sampleRate());
 noLoop();

}
 
void draw()
{
  background(0);

  // we draw the waveform by connecting neighbor values with a line
  // we multiply each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
 for(long n=0;(1000*n*song.bufferSize()/song.sampleRate())<song.length();n++)
  {
 //   song.play((int)(1000*n*song.bufferSize()/song.sampleRate()));
  //  song.pause();
    println(1000*n*song.bufferSize()/song.sampleRate());
    println(song.length());
    float theta=0;
    float theta_inc = 2*PI/song.bufferSize();
     song.cue((int)(n*song.bufferSize()/song.sampleRate()));
     song.play();
    float rinc=(float)2/song.bufferSize();
    //println(rinc);

    for(int i = 0; i < song.bufferSize() - 1; i++)
    {
      /*stroke(2*((255*song.left.get(i))+128),0,0);
      line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);    
      stroke(0,0,2*((255*song.left.get(i))+128));
      line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);*/
      stroke(((256*song.mix.get(i))+128));    
      line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
      theta+=theta_inc;  
      r-=rinc;
    }
    println(song.mix.get(0));
  }
  song.play();
}
 
void stop()
{
  song.close();
  super.stop();
}
void mousePressed()
{
   redraw();
}

