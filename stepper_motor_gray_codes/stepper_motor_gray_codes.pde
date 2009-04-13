int stator_radius=200;
int coil_radius=15;
int rotor_radius=stator_radius-coil_radius-5;
int centerx, centery;
int index=0;
int max_step=15;
int activated_coils;
float angle=0;


boolean full_step_mode=false;
boolean half_step_mode=false;
boolean gray_step_mode=true;

boolean [][] full_step={ {false, false, false, true}, 
                         {false, false, true, false},
                         {false, true, false, false},
                         {true, false, false, false} };

boolean [][] half_step={ {false, false, false, true},
                         {false, false, true, true},
                         {false, false, true, false},
                         {false, true, true, false},
                         {false, true, false, false},
                         {true, true, false, false},
                         {true, false, false, false},
                         {true, false, false, true} };
  
boolean [][] gray_step={ {false, false, false, false},
                         {false, false, false, true},
                         {false, false, true, true},
                         {false, false, true, false},
                         {false, true, true, false},
                         {false, true, true, true},
                         {false, true, false, true},
                         {false, true, false, false},
                         {true, true, false, false},
                         {true, true, false, true},
                         {true, true, true, true},
                         {true, true, true, false},
                         {true, false, true, false},
                         {true, false, true, true},
                         {true, false, false, true},
                         {true, false, false, false} };
boolean []coils;

void setup()
{
  coils=new boolean[4];
    
  size(800,600);
  centerx=width/2;
  centery=height/2;
}


void draw()
{
  background(0);
  stroke(255);
  strokeWeight(1);
  noFill();
  ellipse(centerx,centery,stator_radius*2+coil_radius,stator_radius*2+coil_radius);
    angle=0;
    activated_coils=0;
  for(int i=0;i<4;i++)
  {
    if(full_step_mode)
      coils[i]=full_step[index][i];
    if(gray_step_mode)
      coils[i]=gray_step[index][i];
    if(half_step_mode)
      coils[i]=half_step[index][i];
    
    if(coils[i]==true)
    {
      if(i==0)
        anglex++;
      if(i==1)
        angley++;
      if(i==2)
        anglex--;
      if(i==3)
        angley--;
        
      activated_coils++;
      fill(0,255,0);
    }
    else
      fill(0);
    ellipse(centerx+stator_radius*cos(PI*i/2),centery+stator_radius*sin(PI*i/2),coil_radius,coil_radius);     
  }
   stroke(0,0,255);
   strokeWeight(10);
   if(activated_coils!=0)
     angle/=activated_coils;
  line(centerx+rotor_radius*cos(angle), centery+rotor_radius*sin(angle), centerx-rotor_radius*cos(angle),centery-rotor_radius*sin(angle));

}

void keyPressed()
{
  if(key==' ')
  {
    index++;
    if(index>max_step)
      index=0;
    println(degrees(angle));
  }
}
