
void setup()
{
   size(screen.width, screen.height);
   noLoop();
}
void draw()
{
    background(0);
    stroke(0,255,0);
   float r1, r2, r3, vout, next_vout, r1_inc, r2_inc, r3_inc;
   float v1,v2, next_v1,next_v2;
   r1_inc=100;
   r2_inc=1;
   r3_inc=100;

   for(r1=0;r1<1000;r1+=r1_inc)
    {
/*        vout=r2/(r1+r2);
        next_vout=(r2+r2_inc)/(r1+r2+r2_inc);
        line(r2,100*vout,r2+r2_inc, 100*next_vout);*/
      for(r3=0;r3<1000;r3+=r3_inc)
      {
          r2=35;
         // for(r2=0;r2<70;r2+=r2_inc)
          //{     
            v1=(r2+r3)/(r1+r2+r3);
            v2=r3/(r1+r2+r3);
            next_v1=(r2+r2_inc+r3)/(r1+r2+r3+r2_inc);
            next_v2=r3/(r1+r2+r3+r2_inc);
            stroke(0,255,0);
            line(r2*10,500*v1,(r2+r2_inc)*10, 500*next_v1);        
            stroke(0,0,255);
            line(r2*10,500*v2,(r2+r2_inc)*10, 500*next_v2);        
          //}
      }
    }
  
}
