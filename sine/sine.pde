import processing.dxf.*;

boolean record = false;
long samplerate=10000;



   float r=350;
void setup()
{
  size(1024, 768,P3D);



 noLoop();

}
 
void draw()
{
    if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
    record=false;
  }
  background(0);

  // we draw the waveform by connecting neighbor values with a line
  // we multiply each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
 //   song.play((int)(1000*n*song.bufferSize()/song.sampleRate()));
  //  song.pause();

    float theta=0;
    float theta_inc = 2*PI/(samplerate*1.8);
    float rinc=(float)10/(samplerate*1.8);
    float omega=1;
    //println(rinc);

    for(long i = 0; theta<1*2*PI; i++)
    {

      stroke((127*sin(omega*radians(i))+128));    
      line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
      theta+=theta_inc;  
      r-=rinc;
      if(sin(omega*radians(i))==1)
        omega+=.01;
    }
  

}
 
void stop()
{
}
void mousePressed()
{
   redraw();
}
void keyPressed()
{
  if(key==' ')
  {
  record=true;
  redraw();
  }
}
