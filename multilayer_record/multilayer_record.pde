import processing.dxf.*;

float[] audio;
    int samples=10000;
    float theta=0;
    float radius=50;
    float theta_inc = 2*PI/samples;
    float rinc=(float)5/samples;

void setup()
{
  audio=new float[samples];
  float omega=300;
  for(int i=0;i<samples;i++)
  {
     audio[i]=128*(1+sin(omega*(float)i));
  }
  
  size(screen.width, screen.height,P3D);
  noLoop();
}

void draw()
{
  background(255);
  beginRaw(DXF,"offset.dxf");
  float r=radius;
  for(int i=1;i<samples;i++)
  {
     stroke(0);
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  beginRaw(DXF,"128.dxf");
  r=radius;
  for(int i=1;i<samples;i++)
  {
     stroke(0);
     if(audio[i]>128)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=128;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"64.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(0,255,0);
     if(audio[i]>64)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=64;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"32.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(0,0,255);
     if(audio[i]>32)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=32;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"16.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(255,0,0);
     if(audio[i]>16)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=16;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"8.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(255,0,255);
     if(audio[i]>8)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=8;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"4.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(255,255,0);
     if(audio[i]>4)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=4;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  r=radius;
  theta=0;  
  beginRaw(DXF,"2.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(128);
     if(audio[i]>2)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=2;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"1.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(0,255,255);
     if(audio[i]>1)
     {
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
       audio[i]-=1;
     }
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
  background(255);
  theta=0;  
  r=radius;
  beginRaw(DXF,"background.dxf");
  for(int i=1;i<samples;i++)
  {
     stroke(0,255,255);
       line(width/2+r*cos(theta),height/2+r*sin(theta),width/2+(r-rinc)*cos(theta+theta_inc),height/2+(r-rinc)*sin(theta+theta_inc));
      theta+=theta_inc;  
      r-=rinc;     
  }
  endRaw();
}
