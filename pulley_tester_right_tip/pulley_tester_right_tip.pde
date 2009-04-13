
LinkedList pulleyPoints;
LinkedList originalPulleyPoints;

PFont font;


float pulleyAngle, mirrorAngle;
float releaseAngle;
float gearRatio;
int lastReleased=0;
int releaseIndex;
boolean runMode=false;
float stringLength;

float lengthOfStringOnPulley;
float openStringLength;
float newOpenStringLength;
float angularIncrement;

float mirrorRadius;
float pulleyHeight;
float pulleyY;

myPoint rightTip, leftTip, releasePoint;

void setup()
{
  font=loadFont("ArialMT-48.vlw");
  textFont(font);
  rightTip=new myPoint();
  leftTip=new myPoint();
  pulleyPoints=new LinkedList();
  originalPulleyPoints=new LinkedList();
  releasePoint=new myPoint();
  angularIncrement=2*PI/2000;
  pulleyY=3*screen.height/4+100;
  pulleyAngle=0;
  mirrorAngle=-PI/3;
  gearRatio=.5;
  mirrorRadius=300;
  pulleyHeight=600;
  loadPulley();
  rotatePulley(1.7399);
  calculateStringLength();
  size(screen.width, screen.height);   
 // findInitialTangency();
}

void loadPulley()
{
  pulleyPoints.clear();
  String lines[] = loadStrings("pulley.csv");
  for(int i=0;i<lines.length;i++)
  {
     StringTokenizer st = new StringTokenizer(lines[i],",");
     Float x=Float.valueOf(st.nextToken());
     Float y=Float.valueOf(st.nextToken());
     Float z=Float.valueOf(st.nextToken());
     println(x+" "+y+" "+z);
     float angle=atan(y.floatValue()/x.floatValue());
     if((x.floatValue()<0)&&(y.floatValue()>=0))
       angle+=PI;
     if((x.floatValue()<0)&&(y.floatValue()<0))
       angle-=PI;
     
     myPoint a=new myPoint(screen.width/2+x.floatValue(),pulleyY+y.floatValue(),z.floatValue(),angle,sqrt(pow(x.floatValue(),2)+pow(y.floatValue(),2)));
     pulleyPoints.add(a);
     originalPulleyPoints.add(a);
  }
  lastReleased=pulleyPoints.size()-1;
}

void findInitialTangency()
{
  float distance, slope, theta, error;
  do{
    rotatePulley(.001);
    pulleyAngle+=.001;
    myPoint a= (myPoint) pulleyPoints.get(pulleyPoints.size()-2);
    myPoint b= (myPoint) pulleyPoints.get(pulleyPoints.size()-1);
    slope=-1*(b.y-a.y)/(b.x-a.x);
    theta=atan(slope);
    distance=sqrt(pow(a.x-leftTip.x,2)+pow(a.y-leftTip.y,2));
    error=sqrt(pow(leftTip.x-(a.x-distance*cos(theta)),2)+pow(leftTip.y+(a.y-distance*sin(theta)),2));
    println(pulleyAngle+" "+error);
    
  }
    while(error>10);
}


void drawTangentLine()
{
  float distance, slope, theta, error;

    myPoint a= (myPoint) pulleyPoints.get(pulleyPoints.size()-2);
    myPoint b= (myPoint) pulleyPoints.get(pulleyPoints.size()-1);
    slope=-1*(b.y-a.y)/(b.x-a.x);
    theta=atan(slope);
    distance=sqrt(pow(a.x-leftTip.x,2)+pow(a.y-leftTip.y,2));
    error=sqrt(pow(leftTip.x-(a.x-distance*cos(theta)),2)+pow(leftTip.y-(a.y+distance*sin(theta)),2));
    line(a.x,a.y,a.x-distance*cos(theta),a.y+distance*sin(theta));
    println(pulleyAngle+" "+error);
}

void draw()
{
  
  myPoint a=(myPoint) pulleyPoints.get(pulleyPoints.size()-1);
  println(a.angle);
  background(0);
  stroke(100);
  strokeWeight(1);
  noFill();
  stroke(255,255,0);
  strokeWeight(10);
  line(leftTip.x,leftTip.y,rightTip.x,rightTip.y);
  strokeWeight(1);
  fill(255,0,0);
  ellipse(width/2,pulleyY-pulleyHeight, 10, 10);
  drawPulley();
//  drawTangentLine();
  calculateStringLength();
  ellipse(a.x,a.y,10,10);
}

void rotatePulley(float angle)
{
  for(int i=0;i<pulleyPoints.size();i++)
  {
    myPoint a=(myPoint) pulleyPoints.get(i);
    a.angle+=angle;
    a.x=width/2+a.r*cos(a.angle);
    a.y=pulleyY+a.r*sin(a.angle);
    pulleyPoints.set(i,a);
  }
}

void drawPulley()
{
  for(int i=0;i<pulleyPoints.size()-1;i+=5)
  {
    myPoint a,b;
    a=(myPoint)pulleyPoints.get(i);
    b=(myPoint)pulleyPoints.get(i+1);
    stroke(255);
//    line(a.x,a.y,b.x,b.y);
    line(width/2,pulleyY,width/2+a.r*cos(a.angle),pulleyY+a.r*sin(a.angle));
  }
}


void calculateStringLength()
{
  calculateReleaseAngle();
  calculateOpenStringLength();
  calculateLengthOfStringOnPulley();
  stringLength=openStringLength+lengthOfStringOnPulley;
  stroke(255);
  text(stringLength,0,60);
}

void calculateOpenStringLength()
{
  openStringLength=sqrt(pow(releasePoint.x-leftTip.x,2)+pow(releasePoint.y-leftTip.y,2));
}  


void calculateMirrorTips()
{
  leftTip.x=width/2-mirrorRadius*cos(mirrorAngle);
  leftTip.y=pulleyY-pulleyHeight+mirrorRadius*sin(mirrorAngle);
  rightTip.x=width/2+mirrorRadius*cos(mirrorAngle);
  rightTip.y=pulleyY-pulleyHeight-mirrorRadius*sin(mirrorAngle);
}


//check tangents to the current diameter pulley and pick the one with the right
//angle to hit the mirror's tip;
void calculateReleaseAngle()
{
  calculateMirrorTips(); 
  releaseIndex=pulleyPoints.size()-1;
  int currentDistance=1000000;
  float openDistance=0;
  float distance=0;
  
  for(int j=0;j<pulleyPoints.size()-1;j++)
  {
    myPoint a= (myPoint) pulleyPoints.get(j);
    myPoint b= (myPoint) pulleyPoints.get(j+1);
    float slope=-1*(b.y-a.y)/(b.x-a.x);
    float theta=atan(slope);
    distance=sqrt(pow(a.x-rightTip.x,2)+pow(a.y-rightTip.y,2));
    stroke(100);
    line(a.x,a.y,b.x,b.y);
    stroke(200,100,100);
      if(sqrt(pow(rightTip.x-(a.x+distance*cos(theta)),2)+pow(rightTip.y-(a.y-distance*sin(theta)),2))<10)
      {
        if(abs(j-lastReleased)<currentDistance)
          {
            releaseAngle=theta;
            releasePoint.x=a.x;
            releasePoint.y=a.y;
            releaseIndex=j;
            currentDistance=abs(releaseIndex-lastReleased);
            openDistance=distance;
          }          
      }
  }
  myPoint a=(myPoint) pulleyPoints.get(releaseIndex-1  );
  lastReleased=releaseIndex;
  line(a.x,a.y,a.x-openDistance*cos(releaseAngle),a.y+openDistance*sin(releaseAngle));
  text(releaseIndex,20,180);


 
}

void calculateLengthOfStringOnPulley()
{
  lengthOfStringOnPulley=0;
  if(releaseIndex<pulleyPoints.size()-2)
   for(int i=pulleyPoints.size()-1;i>releaseIndex+1;i--)
  {
      myPoint a=(myPoint)pulleyPoints.get(i);
      myPoint b=(myPoint)pulleyPoints.get(i-1);
      lengthOfStringOnPulley+=sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2));
  } 
}

void keyPressed()
{
  if(keyCode==LEFT)
  {
    pulleyAngle-=.01;
    rotatePulley(-.01);
    mirrorAngle+=.01/3;
  }
  if(keyCode==RIGHT)
  {
    pulleyAngle+=.01;
    rotatePulley(.01);
    mirrorAngle-=.01/3;
  }
  if(keyCode==UP)
  {
    rotatePulley(.01);
    pulleyAngle+=.01;
  }
  if(keyCode==DOWN)
  {
    rotatePulley(-.01);
    pulleyAngle-=.01;
  }
  if(key=='l')
    loadPulley();
    
    
}


class myPoint{
  float x, y, z, angle, r;
  myPoint()
  {
    x=0;
    y=0;
    z=0;
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
  myPoint(float a, float b, float c, float d)
  {
    x=a;
    y=b;
    z=c;
    angle=d;
  }  
  myPoint(float a, float b, float c, float d, float e)
  {
    x=a;
    y=b;
    z=c;
    angle=d;
    r=e;
  }
}
