float t=0;
float x1,x2,y,offset1,amplitude1, offset2,amplitude2, ballx, bally, ballx2, bally2;
float xinc=.01;
float yinc=-.02;
float xinc2=.03;
float yinc2=-.01;
float rad;

void setup()
{
  size(800,600);
  rad=width/40;
  ballx=3*width/5; 
  bally=3*height/8;
  ballx2=2*width/7;
  bally2=7*height/8;
  offset1=150*width/1280;
  offset2=300*width/1280;
  amplitude1=50*width/1280;
  amplitude2=75*width/1280;
}
void draw()
{
  background(255);
  stroke(0);

  for(y=0;y<width;y++)
  {
    x1=offset1+amplitude1*sin(t+7*pow(y,1.25)/10000);
    x2=offset2+amplitude2*sin(t+3*pow(y,1.4)/10000);
    /*    x1=offset3+amplitude1*sin(t+7*pow(y,1.25)/10000);
     x2=offset4+amplitude2*sin(t+3*pow(y,1.4)/10000);
     x5=offset5+amplitude1*sin(t+7*pow(y,1.25)/10000);
     x6=offset6+amplitude2*sin(t+3*pow(y,1.4)/10000);*/
    stroke(x1/30);
    line(x1,y,x2,y);    
    line(x1+400*width/1280,y,x2+400*width/1280,y);    
    line(x1+700*width/1280,y,x2+700*width/1280,y);  
  }
  stroke(255);
  fill(255);
  ellipse(ballx,bally,rad,rad);  
  ellipse(ballx2,bally2,rad,rad);  
  ellipse(4*width/7,7*height/8,rad,rad);
  ballx+=xinc;
  bally+=yinc;
  if((ballx<rad)||(ballx>width-rad))  
    xinc*=-1;
  if((bally<rad)||(bally>height-rad))
    yinc*=-1;
  ballx2+=xinc2;
  bally2+=yinc2;
  if((ballx2<rad)||(ballx2>width-rad))  
    xinc2*=-1;
  if((bally2<rad)||(bally2>height-rad))
    yinc2*=-1;

  t+=.01*width/1280;
}

