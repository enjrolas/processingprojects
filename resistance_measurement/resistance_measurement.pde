
void setup()
{
   size(screen.width, screen.height*3/4);
   noLoop();
}
void draw()
{
    background(0);
    stroke(0,255,0);
   float r1, r2, rsense;
   float v1,v2, next_v1,next_v2;


  float rinc=1;
float r0,B, T0, T;
T0=25;
B=3950;
r0=10000;
int numErrors=0;

PrintWriter output;
output=createWriter("data.txt");

float v, rsense_reconstructed, temperature_reconstructed, v1_digitized, v2_digitized, error;

v=3;

/*for(r1=0;r1<30000;r1+=1000)
{
 for(r2=0;r2<30000;r2+=1000)
 {*/
  for(T=0;T<100;T+=.01)
  {
    rsense=r0*exp(-1*B/(T0+273))*exp(B/(T+273));
  
    v1=v*(rsense+r2)/(r1+rsense+r2);
    v2=v*r2/(r1+rsense+r2);
    
    v1_digitized=0;
    v2_digitized=0;
    for(float a=0;((a<v) && (a>v1));a+=v/1024)
    {
       if(a<v1)
         v1_digitized=a;
    }

    for(float a=0;((a<v)&&(a>v2));a+=v/1024)
    {
       if(a<v2)
         v2_digitized=a;
    }
  
    println(v1+" "+v2+" "+v1_digitized+" "+v2_digitized);
  
    rsense_reconstructed=(v1_digitized*r2/v2_digitized)-1;
    temperature_reconstructed=(B/log((rsense_reconstructed/r0)*exp(-1*B/(T0+273))))-273;
    error=temperature_reconstructed-T;
  
    if(error>.1)
      numErrors++;
      
    
  }
  output.print(numErrors+" ");
  numErrors=0;
 }
output.println();
println(numErrors+" "+r1+" "+r2);
}

output.flush();
output.close();
/*
for(rsense=0;rsense<70;rsense+=rinc)
{

   for(r1=0;r1<1000;r1+=10)
    {
            v1=(rsense)/(r1+rsense);
            next_v1=(rsense+rinc)/(r1+rsense+rinc);
            stroke(0,255,0);
            line(rsense*10,500*v1,(rsense+rinc)*10, 500*next_v1);        
    }

   for(r2=0;r2<1000;r2+=10)
    {
            v1=(r2)/(r2+rsense);
            next_v1=(r2)/(r2+rsense+rinc);
            stroke(0,0,255);
            line(rsense*10,500*v1,(rsense+rinc)*10, 500*next_v1);        
    }
  
}*/
}
