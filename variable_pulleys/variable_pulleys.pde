
float angle;
myPoint pivot, pulley, leftTip, rightTip;
float[] leftDistances;
float[] rightDistances;
float[] sums;
float radius;
float angle_inc=.5;
float angle_range=85;
float distance;
PFont font;
float maximum=0;
float offset=0;
void setup()
{
  font = loadFont("ArialMT-48.vlw"); 
  textFont(font, 18); 
  radius=250;
  leftTip=new myPoint();
  rightTip=new myPoint();
  angle=0;
  leftDistances=new float[(int)(2*angle_range/angle_inc)+2];
  rightDistances=new float[(int)(2*angle_range/angle_inc)+2];
  sums=new float[(int)(2*angle_range/angle_inc)+2];
  for(int i=0;i<((2*angle/abs(angle_inc))-1);i++)
  {
    leftDistances[i]=0;
    rightDistances[i]=0;
    
  }
  pivot=new myPoint(screen.width/2, screen.height/4);
  pulley=new myPoint(screen.width/2, screen.height/2);
  size(screen.width, screen.height, P3D);
  for(angle=-1*angle_range;angle<angle_range;angle+=angle_inc)
  {
  leftTip.x=pivot.x-radius*cos(radians(angle));
  leftTip.y=pivot.y-radius*sin(radians(angle));
  rightTip.x=pivot.x+radius*cos(radians(angle));
  rightTip.y=pivot.y+radius*sin(radians(angle));
  leftDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=sqrt(pow(leftTip.x-pulley.x,2)+pow(leftTip.y-pulley.y,2));
  rightDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=sqrt(pow(rightTip.x-pulley.x,2)+pow(rightTip.y-pulley.y,2));
  sums[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=leftDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]+rightDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))];
  if(sums[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]>maximum)
    maximum=sums[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))];
  }
}
void draw()
{
  background(0);
  leftTip.x=pivot.x-radius*cos(radians(angle));
  leftTip.y=pivot.y-radius*sin(radians(angle));
  rightTip.x=pivot.x+radius*cos(radians(angle));
  rightTip.y=pivot.y+radius*sin(radians(angle));
  leftDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=sqrt(pow(leftTip.x-pulley.x,2)+pow(leftTip.y-pulley.y,2));
  rightDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=sqrt(pow(rightTip.x-pulley.x,2)+pow(rightTip.y-pulley.y,2));
  sums[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]=leftDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))]+rightDistances[(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc))];
  stroke(0,255,0);
  strokeWeight(4);
  line(leftTip.x, leftTip.y, rightTip.x,rightTip.y);
  strokeWeight(1);
  ellipse(pivot.x,pivot.y,5,5);
  fill(255,0,0);
  ellipse(pulley.x,pulley.y,5,5);
  strokeWeight(1);
  stroke(0,255,255);
  line(rightTip.x,rightTip.y,pulley.x,pulley.y);
  stroke(255,0,255);
  line(leftTip.x,leftTip.y,pulley.x,pulley.y);
  for(int i=0;i<((2*angle_range/abs(angle_inc)));i++)
  {
    stroke(255,0,255);
    ellipse(screen.width/4+i-leftDistances.length/2,5*screen.height/8+.5*leftDistances[i],1,1);
    stroke(0,255,255);
    ellipse(3*screen.width/4+i-leftDistances.length/2,5*screen.height/8+.5*rightDistances[i],1,1);
    stroke(255);
    ellipse(screen.width/2+i-leftDistances.length/2,screen.height-.5*(leftDistances[i]+rightDistances[i]),1,1);
    ellipse(screen.width/2+i-leftDistances.length/2,screen.height/4+.5*(leftDistances[i]+rightDistances[i]),1,1);
    
  }  
  stroke(255,0,0);
  int i=(int)(angle_range/abs(angle_inc)+angle/abs(angle_inc));
   ellipse(screen.width/2+i-leftDistances.length/2,screen.height-.5*(leftDistances[i]+rightDistances[i]),5,5);
   ellipse(3*screen.width/4+i-leftDistances.length/2,5*screen.height/8+.5*rightDistances[i],5,5);
   ellipse(screen.width/4+i-leftDistances.length/2,5*screen.height/8+.5*leftDistances[i],5,5);

  stroke(255);
  fill(255);
 text("cable length", screen.width/2-leftDistances.length/8,3*screen.height/4);
 text("right cable length",3*screen.width/4-leftDistances.length/2,5*screen.height/8);
 text("left cable length",screen.width/4-leftDistances.length/2,5*screen.height/8);
  rotateX(.8);
  rotateY(.2);
  rotateZ(.1);

  float theta_inc=.01;
  float r=50;
  for(float theta=0;(theta<4*PI);theta+=theta_inc)
  {
    r=.25*sums[(int)(((2*angle_range/abs(angle_inc)))/((int)(1+theta/theta_inc)))];
    float x,y,z,x1,y1,z1;
    x=r*cos(theta);
    y=r*sin(theta);
    z=5*theta;
    x1=r*cos(theta+theta_inc);
    y1=r*sin(theta+theta_inc);
    z1=5*(theta+theta_inc);
    line(x+screen.width/4,y+screen.height/4,z,x1+screen.width/4,y1+screen.height/4,z1);
   
  }


//  offset+=.33;
 
  angle+=angle_inc;
  if((angle>(angle_range-angle_inc))||(angle<(-1*angle_range-angle_inc)))
    angle_inc*=-1;
}

class myPoint{
  float x, y, z;
  myPoint()
  {
  }

  myPoint(float a, float b)
  {
    x=a;
    y=b;
  }
  myPoint(float a, float b, float c)
  {
    x=a;
    y=b;
    z=c;
  }
}
