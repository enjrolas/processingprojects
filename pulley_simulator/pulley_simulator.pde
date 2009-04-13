LinkedList string;
LinkedList circle;

float initialRadius;
float pulleyRadius;
float pulleyAngle, mirrorAngle;
float releaseAngle;
float gearRatio;

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
  string=new LinkedList();
  circle=new LinkedList();
  rightTip=new myPoint();
  leftTip=new myPoint();
  releasePoint=new myPoint();
  initialRadius=50;
  angularIncrement=2*PI/2000;
  pulleyRadius=initialRadius;
  pulleyY=3*screen.height/4;
  pulleyAngle=0;
  mirrorAngle=0;
  gearRatio=.5;
  mirrorRadius=screen.width/4;
  pulleyHeight=screen.height/2;
  calculateStringLength();
  size(screen.width, screen.height);
}

void draw()
{
  background(0);
  stroke(100);
  strokeWeight(1);
  noFill();
  ellipse(width/2,pulleyY, pulleyRadius*2, pulleyRadius*2);
  stroke(255,255,0);
  strokeWeight(10);
  line(leftTip.x,leftTip.y,rightTip.x,rightTip.y);
  strokeWeight(1);
  fill(255,0,0);
  ellipse(width/2,pulleyY-pulleyHeight, 10, 10);
  calculateReleaseAngle();
}


void calculateStringLength()
{
  calculateReleaseAngle();
  calculateOpenStringLength();
  calculateLengthOfStringOnPulley();
  stringLength=openStringLength+lengthOfStringOnPulley;
}

void calculateOpenStringLength()
{
  openStringLength=sqrt(pow(releasePoint.x-rightTip.x,2)+pow(releasePoint.y-rightTip.y,2));
}

void update()
{
  calculateMirrorTips();
  newOpenStringLength=sqrt(pow(rightTip.x-releasePoint.x,2)+pow(rightTip.y-releasePoint.y,2));
  slack=openStringLength-newOpenStringLength;
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
  circle.clear();
  
  //here, make 2*PI/2000 whatever the angular accuracy you're shooting for
  for(float i=0;i<2*PI;i+=angularIncrement)
  {
    myPoint a=new myPoint(width/2+pulleyRadius*cos(i),pulleyY-pulleyRadius*sin(i));
    circle.add(a);
  }  
  for(int j=0;j<circle.size()-1;j++)
  {
    myPoint a= (myPoint) circle.get(j);
    myPoint b= (myPoint) circle.get(j+1);
    float slope=-1*(b.y-a.y)/(b.x-a.x);
    float theta=atan(slope);
    float distance=sqrt(pow(a.x-rightTip.x,2)+pow(a.y-rightTip.y,2));
    stroke(100);
    line(a.x,a.y,b.x,b.y);
    stroke(200,100,100);
    if(j>PI/angularIncrement)
      if(sqrt(pow(rightTip.x-(a.x+distance*cos(theta)),2)+pow(rightTip.y-(a.y-distance*sin(theta)),2))<1)
      {
        line(a.x,a.y,a.x+distance*cos(theta),a.y-distance*sin(theta));
        releaseAngle=theta;
        releasePoint.x=a.x;
        releasePoint.y=a.y;
      }
  }
 
}

void calculateLengthOfStringOnPulley()
{
  lengthOfStringOnPulley=0;
   for(int i=0;i<string.size()-1;i++)
  {
      myPoint a=(myPoint)string.get(i);
      myPoint b=(myPoint)string.get(i+1);
      lengthOfStringOnPulley+=sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2));
  } 
}

void keyPressed()
{
  if(key==' ')
  {
    mirrorAngle+=angularIncrement;
    update();
  }
    
}


class myPoint{
  float x, y, angle;
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
  myPoint(float a, float b, float c)
  {
    x=a;
    y=b;
    angle=c;
  }
}
