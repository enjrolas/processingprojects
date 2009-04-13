
LinkedList pulleyPoints;
LinkedList originalPulleyPoints;
LinkedList graphPoints;

PFont font;


float pulleyAngle, mirrorAngle;
float releaseAngle;
float gearRatio;
int lastReleased=0;
int releaseIndex;
boolean runMode=false;
float stringLength;


int startAngle, angleRange;
float lengthOfStringOnPulley;
float openStringLength;
float newOpenStringLength;
float angularIncrement;

float mirrorRadius;
float pulleyHeight;
float pulleyY;

float theta;

myPoint rightTip, leftTip, releasePoint;

void setup()
{
  font=loadFont("ArialMT-48.vlw");
  textFont(font);
  rightTip=new myPoint();
  leftTip=new myPoint();
  pulleyPoints=new LinkedList();
  originalPulleyPoints=new LinkedList();
  graphPoints=new LinkedList();
  releasePoint=new myPoint();
  angularIncrement=2*PI/2000;
  pulleyY=3*screen.height/4+100;
  pulleyAngle=0;
  mirrorAngle=-PI/3;
  gearRatio=.5;
  mirrorRadius=500;
  pulleyHeight=1000;
  loadPulley();
//  flip();
  rotatePulley(3.53);
  calculateStringLength();
  gatherGraphData();
  writeOutGraphData();
  calculateStats();
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
     float angle=atan(y.floatValue()/(-1*x.floatValue()));
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

void writeOutGraphData()
{
   	

PrintWriter output= createWriter("analysis.txt"); 
  output.println("angle, string length, release angle"); 
  for(int i=0;i<graphPoints.size();i++)
  {
    graphPoint a=(graphPoint)graphPoints.get(i);
    output.println(a.angle+ "," + a.stringLength+","+a.releaseAngle); 
  }
  output.flush();
  output.close();
    
}

void flip()
{
  for(int i=0;i<pulleyPoints.size();i++)
  {
    myPoint a=(myPoint)pulleyPoints.get(i);
    a.x-=width/2;
    a.x*=-1;
    a.x+=width/2;
    pulleyPoints.set(i,a);
  }
  
}

void drawTangentLine()
{
  float distance, slope, error;

    myPoint a= (myPoint) pulleyPoints.get(pulleyPoints.size()-2);
    myPoint b= (myPoint) pulleyPoints.get(pulleyPoints.size()-1);
    slope=-1*(b.y-a.y)/(b.x-a.x);
    theta=atan(slope);
    distance=sqrt(pow(a.x-leftTip.x,2)+pow(a.y-leftTip.y,2));
    error=sqrt(pow(leftTip.x-(a.x-distance*cos(theta)),2)+pow(leftTip.y-(a.y+distance*sin(theta)),2));
    line(a.x,a.y,a.x-distance*cos(theta),a.y+distance*sin(theta));
    println(pulleyAngle+" "+error);
}

void gatherGraphData()
{  
  int b=1000;
  while(mirrorAngle<PI/3)
  {
      pulleyAngle-=2*PI/pulleyPoints.size();
      rotatePulley(-2*PI/pulleyPoints.size());
      mirrorAngle+=2*PI/pulleyPoints.size()/3;  
      calculateStringLength();
      graphPoint a=new graphPoint(pulleyAngle, releaseIndex, stringLength, theta);
    //  println(a.releaseIndex);
      graphPoints.add(a);
  } 
}

void graph()
{
  for(int i=0;i<graphPoints.size()-2;i++)
  {
    graphPoint a=(graphPoint)graphPoints.get(i);
    graphPoint b=(graphPoint)graphPoints.get(i+1);
  stroke(0,255,100);
    //release index vs angle
    line(900+a.angle*100, 700-a.releaseIndex/2, 900+b.angle*100, 700-b.releaseIndex/2);
  stroke(0,100,255);
    //string length vs angle
    line(900+a.angle*100, 1800-a.stringLength, 900+b.angle*100, 1800-b.stringLength);    
    if(a.angle==startAngle)
    {
      fill(255,0,0);
      ellipse(900+a.angle*100, 1820-a.stringLength*2,5,5);

      fill(255,255,0);
      ellipse(900+a.angle*100, 1820-a.stringLength*2,5,5);
    }
  }
}


void calculateStats()
{
  float minimumStringLength, maximumStringLength, averageStringLength;
  float minimumReleaseAngle, maximumReleaseAngle, averageReleaseAngle;
  float angleRange, stringRange;
  int minIndex=0;
  boolean counting=false;
  minimumReleaseAngle=1000000;
  maximumReleaseAngle=-1000000;
  averageStringLength=0;
  minimumStringLength=1000000;
  maximumStringLength=-1000000;
  averageReleaseAngle=0;
  for(int i=0;i<graphPoints.size();i++)
  {
    graphPoint a=(graphPoint)graphPoints.get(i);
    averageStringLength+=a.stringLength;
    if(a.stringLength<minimumStringLength)
     {
      minimumStringLength=a.stringLength;
      minIndex=i;
     }
    if(a.stringLength>maximumStringLength)
      maximumStringLength=a.stringLength;
    if(a.releaseAngle<minimumReleaseAngle)
      minimumReleaseAngle=a.releaseAngle;
    if(a.releaseAngle>maximumReleaseAngle)
      maximumReleaseAngle=a.releaseAngle;
  }
  averageReleaseAngle/=graphPoints.size();
  averageStringLength/=graphPoints.size();
  
  angleRange=maximumReleaseAngle-minimumReleaseAngle;
  stringRange=maximumStringLength-minimumStringLength;
  println("maximum string deformation is "+stringRange/maximumStringLength);
  println("release angle range is "+angleRange);
  println("minimum index is "+minIndex);
  
  
  
  minimumReleaseAngle=1000000;
  maximumReleaseAngle=-1000000;
  averageStringLength=0;
  minimumStringLength=1000000;
  maximumStringLength=-1000000;
  averageReleaseAngle=0;

  for(int i=startAngle;i<(startAngle+graphPoints.size()*PI/4/(2*PI));i++)
  {
    graphPoint a=(graphPoint)graphPoints.get(i);

    averageStringLength+=a.stringLength;
    if(a.stringLength<minimumStringLength)
      minimumStringLength=a.stringLength;
    if(a.stringLength>maximumStringLength)
      maximumStringLength=a.stringLength;
    if(a.releaseAngle<minimumReleaseAngle)
      minimumReleaseAngle=a.releaseAngle;
    if(a.releaseAngle>maximumReleaseAngle)
      maximumReleaseAngle=a.releaseAngle;
  }
  println("maximum string deformation over the selected range is "+stringRange/maximumStringLength);
  println("release angle range over the selected range is "+angleRange);

}

void draw()
{
  myPoint a=(myPoint) pulleyPoints.get(pulleyPoints.size()-1);
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
  drawTangentLine();
  calculateStringLength();
  calculateStats();
  ellipse(a.x,a.y,10,10);
  graph();
//  println(pulleyAngle);
  
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
    theta=atan(slope);
    distance=sqrt(pow(a.x-leftTip.x,2)+pow(a.y-leftTip.y,2));
    stroke(100);
    line(a.x,a.y,b.x,b.y);
    stroke(200,100,100);
      if(sqrt(pow(leftTip.x-(a.x-distance*cos(theta)),2)+pow(leftTip.y-(a.y+distance*sin(theta)),2))<20)
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
  myPoint a=(myPoint) pulleyPoints.get(releaseIndex);
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
    pulleyAngle-=2*PI/1000;
    rotatePulley(-2*PI/1000);
    mirrorAngle+=2*PI/1000/3;
    calculateStringLength();
    graphPoint a=new graphPoint(pulleyAngle, releaseIndex, stringLength, releaseAngle);
 //  graphPoints.add(a);
  }
  if(keyCode==RIGHT)
  {
    pulleyAngle+=2*PI/1000;
    rotatePulley(2*PI/1000);
    mirrorAngle-=2*PI/1000/3;
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
    
  if(key=='a')
    startAngle++;
  if(key=='d')
    startAngle--;
    
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

class graphPoint
{
  float stringLength;
  int releaseIndex;
  float angle, releaseAngle;
  graphPoint(float a, int b, float c, float d)
  {
    angle=a;
    releaseIndex=b;
    stringLength=c;
    releaseAngle=d;
  }
}
