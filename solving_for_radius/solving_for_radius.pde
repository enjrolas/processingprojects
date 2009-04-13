myPoint[] string;
myPoint[] rim;
int current_point;
float string_length;
float max_angle=PI/3;
myPoint pivot, axle,tip,release_point;
float mirror_arm;
float mirror_angle;
float max_length;
float radius;
float initial_radius=30;
float initial_angle=0;
int point_inc=1;
int release_index=0;

float phi;  //phi is the angle the pulley has turned to
float phi_inc=.001;
float theta;  //theta is the mirror angle


void setup()
{
  string=new myPoint[1000];
  rim=new myPoint[1000];
  current_point=1;
  for(int i=0;i<string.length;i++)
  {
    string[i]=new myPoint();
    rim[i]=new myPoint();
  }
  phi = initial_angle;
   size(screen.width,screen.height);
   pivot=new myPoint(screen.width/2,screen.height/4);
   axle=new myPoint(screen.width/2, screen.height/2);
   mirror_arm=screen.height/8;
   mirror_angle=max_angle;
   radius=initial_radius;
   tip=new myPoint(pivot.x+mirror_arm*cos(mirror_angle),pivot.y-mirror_arm*sin(mirror_angle));
   max_length=sqrt(pow(tip.x-axle.x,2)+pow(tip.y-axle.y,2));
   rim[0]=new myPoint(axle.x+initial_radius*cos(initial_angle),axle.y+initial_radius*sin(initial_angle));
   release_point=new myPoint(rim[0].x,rim[0].y);
   string[0]=new myPoint(rim[0].x,rim[0].y);
   for(int i=current_point;i<string.length;i++)
   {
     float delta_y=release_point.y-tip.y;
     float delta_x=release_point.x-tip.x;
     string[i]=new myPoint();
     string[i].x=release_point.x-(i-current_point)*delta_x/(string.length-current_point);
     string[i].y=release_point.y-(i-current_point)*delta_y/(string.length-current_point);
   }
}
float find_release_angle()
{
  return 0;
}

void draw()
{
  background(0);
  fill(0,255,0);
  ellipse(pivot.x,pivot.y,5,5);
  fill(255,0,0);
  ellipse(tip.x,tip.y,5,5);
  fill(0,0,255);
  ellipse(axle.x,axle.y,5,5);
  stroke(255,0,0);
  line(pivot.x,pivot.y,tip.x,tip.y);
  ellipse(rim[0].x,rim[0].y,10,10);
  stroke(255);
  for(int i=0;i<string.length-1;i++)
  {
    line(string[i].x,string[i].y, string[i+1].x,string[i+1].y);
  }
  for(int i=0;i<current_point-1;i++)
  {
    line(rim[i].x,rim[i].y,rim[i+1].x,rim[i+1].y);
  }
  phi+=phi_inc;
  current_point+=point_inc;
  if(current_point>(string.length-1))
   {
     point_inc*=-1;
     phi_inc*=-1;
   }
  calculate_rim();

}

void calculate_rim()
{
  rim[current_point].x=axle.x+radius*cos(phi);
  rim[current_point].y=axle.y+radius*sin(phi);
  for(int i=0;i<current_point;i++)
  {
    if((rim[i].x==release_point.x)&&(rim[i].y==release_point.y))
      release_index=i;
  }
  
}

float get_string_length_along_rim()
{
  float length_for_far=0;
  for(int i=0;i<current_point-1;i++)
  {
    length_so_far+=sqrt(pow(rim[i].x-rim[i+1].x,2)+pow(rim[i].y-rim[i+1].y,2));
  }
}

void set_free_string()
{
  for(int i=current_point-1;i<string.length
}

class myPoint{
  float x, y;
  myPoint()
  {
    x=0;
    y=0;
  }
  myPoint(float a, float b)
  {
    x=a;
    y=b;
  }
}
