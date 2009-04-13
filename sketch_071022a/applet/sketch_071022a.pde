import processing.video.*;

import sms.*;



import processing.opengl.*;

import processing.serial.*;
import damkjer.ocd.*;

Camera camera1;
LinkedList points;



boolean collectPoints=false;

//double z;
float depth;
Capture cam; 
PImage img; 
boolean newFrame=false; 
int _id =0;

ArrayList aboveThreshold;
ArrayList clusters;


LinkedList xVals,yVals,zVals;
int window=10;

float xAccel, xVel,xPos=0;
float avgxAccel, avgxVel, avgxPos=0;
float avg_out_xAccel, avg_out_xVel, avg_out_xPos=0;
float zAccel, zVel,zPos=0;
float avgzAccel, avgzVel, avgzPos=0;
float avg_out_zAccel, avg_out_zVel, avg_out_zPos=0;
float[] forwardVect;
Serial myPort;    // The serial port:
PFont myFont;     // The display font:
String inString;  // Input string from serial port:
int lf = 10;      // ASCII linefeed
float[] gyro;
int n=0;
float[] accelerometer;
float angleX=0;
float angleY=0;
float angleZ=0;
float velX=0,posX=0,velY=0,posY=0,velZ=0,posZ=0;
float t=0;
float avgX,avgY,avgZ,accumX,accumY,accumZ=0;
float accum_accelerometerX,accum_accelerometerY,accum_accelerometerZ,avg_accelerometerX,avg_accelerometerY,avg_accelerometerZ=0;
float av_av_out_z,av_av_av_out_z=0;
//float gx,gy,gz;
int frames=0;
int fuck=0;

boolean averaging=true;
boolean offset=true;
boolean position=false;
boolean line=false;
boolean box=false;
int j=0;
boolean jesse = false;

void setup() {
  xVals=new LinkedList();
  yVals=new LinkedList();
  zVals=new LinkedList();
  points=new LinkedList();
  size(600,400,OPENGL);
    camera1 = new Camera(this,500,0,0,0,0,0);
  	cam = new Capture(this, 320, 240, 15); 
	// BlobDetection 
	// img which will be sent to detection (a smaller copy of the cam frame); 
	img = new PImage(320,240);  
  gyro=new float[]{0,0,0};
  accelerometer=new float[]{0,0,0};
        clusters = new ArrayList();
  forwardVect=new float[3];
  // Make your own font. It's fun!
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont, 18);
  // List all the available serial ports:
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  /*  myPort = new Serial(this, Serial.list()[0], 57600);
  myPort.write(7);
  myPort.buffer(100);
  myPort.bufferUntil(lf);*/
  println("i am not afraid of you");
  //noLoop();
  background(0);
}



void draw() {
    camera1.feed();
  getAccels();
  background(0);


 stroke(255);
 //line(width/2,height/2,0,width/2+forwardVect[0],height/2+forwardVect[1],forwardVect[2]);

 if(collectPoints)
 {
   //println("collecting");
    float[] myPoint=new float[3];
    myPoint[0]=width/2+(float)(10*forwardVect[0]*depth);
    myPoint[1]=height/2+(float)(10*forwardVect[1]*depth);
    myPoint[2]=(float)(10*forwardVect[2]*depth);
 /*   myPoint[0]=width/2;
    myPoint[1]=height/2+t;
    myPoint[2]=depth;*/
    points.add(new tPoint(myPoint[0],myPoint[1],myPoint[2],depth));
    t+=.1;

 } 
   for  (int i=0;i<points.size();i++)
  {
    tPoint a=(tPoint)points.get(i);
    stroke(a.depth*60-128,0,a.depth*50-128);
   line(a.x-1,a.y-1,a.z-1,a.x,a.y,a.z);
  }
/* 	if (newFrame) 
	{ 
                background(255);
		newFrame=false; 
		
		img.copy(cam, 0, 0, cam.width, cam.height,  
				0, 0, img.width, img.height);
                image(cam,0,0,width,height); 
           
		//fastblur(img, 2);
                
		//theBlobDetection.computeBlobs(img.pixels); 
		//drawBlobsAndEdges(true,true); 
	} */

}

void getAccels()
{
    int[] vals=Unimotion.getSMSArray();
    accelerometer[0]=vals[0];
    accelerometer[1]=vals[1];
    accelerometer[2]=vals[2];
    analyze();
}

void analyze()
{
  
   frames++;
   
  if(xVals.size()>window)
 { 
   Linear temp=(Linear)xVals.getLast();
  xAccel-=temp.acceleration;
  xVel-=temp.velocity;
  xPos-=temp.position;
 }
 
  xAccel+=accelerometer[0];
  xVel+=velX;
  xPos+=posX;
  if(xVals.size()>window)
    xVals.removeLast();
  Linear xPoint=new Linear(accelerometer[0],velX,posX);
  xVals.addFirst(xPoint);

  avgxAccel=xAccel/xVals.size();
  avgxVel=xVel/xVals.size();
  avgxPos=xPos/xVals.size();

  avg_out_xAccel=accelerometer[0]-avgxAccel;
  velX+=avg_out_xAccel/10.0;
  avg_out_xVel=velX-avgxVel;
  posX+=avg_out_xVel; 
  
    if(zVals.size()>window)
 { 
   Linear temp=(Linear)zVals.getLast();
  zAccel-=temp.acceleration;
  zVel-=temp.velocity;
  zPos-=temp.position;
 }
  zAccel+=accelerometer[2];
  zVel+=velZ;
  zPos+=posZ;
  if(zVals.size()>window)
    zVals.removeLast();
  Linear zPoint=new Linear(accelerometer[2],velZ,posZ);
  zVals.addFirst(zPoint);

  avgzAccel=zAccel/zVals.size();
  avgzVel=zVel/zVals.size();
  avgzPos=zPos/zVals.size();

  avg_out_zAccel=accelerometer[2]-avgzAccel;
  velZ+=avg_out_zAccel/10.0;
  avg_out_zVel=velZ-avgzVel;
  posZ+=avg_out_zVel; 
  
    float gSize = sqrt(pow(accelerometer[0],2)+pow(accelerometer[1],2)+pow(accelerometer[2],2));
  float gx = accelerometer[0]/gSize;
  float gy = accelerometer[1]/gSize;
  float gz = accelerometer[2]/gSize;
  float angle = acos(-gz);
  float rotX = -gy;
  float rotY = gx;
  
  forwardVect[0] = rotX*rotX*(1+gz)-gz;
  forwardVect[1] = rotX*rotY*(1+gz);
  forwardVect[2] = -rotY*sin(angle);
  
}


void parse()
{
  
    if(inString!= null)
    {
    String[] myString = split(inString, " ");

    for(int i=0;i<myString.length;i++)
    {
    myString[i]=myString[i].trim();
    }
    if(myString.length>12)
    {
      if(myString[12].indexOf("Z")==-1)
      {
      if(myString[1].compareTo("")>0)
    gyro[0]=(Integer.parseInt(myString[1])-512);
      if(myString[4].compareTo("")>0)
    gyro[1]=(Integer.parseInt(myString[4])-512);
      if(myString[7].compareTo("")>0)
    gyro[2]=(Integer.parseInt(myString[7])-512);
      if(myString[10].compareTo("")>0)
    accelerometer[0]=(Integer.parseInt(myString[10])-338);
      if(myString[11].compareTo("")>0)
    accelerometer[1]=(Integer.parseInt(myString[11])-338);
      if(myString[12].compareTo("")>0)
    accelerometer[2]=(Integer.parseInt(myString[12])-338);
      }
    }
  analyze();
    }
}

// ================================================== 
// captureEvent() 
// ================================================== 
void captureEvent(Capture cam) 
{ 
	cam.read(); 
        aboveThreshold = new ArrayList();
        clusters = new ArrayList();
              smartPixel[][] newPixels = new smartPixel[cam.width][cam.height];
              int redthresh=200;
              int bluethresh=200;
              int greenthresh=200;
              int pointx=0;
              int pointy=0;
              int numpoints=0;
              double z;
              double f0=12;
              double k=1/14.0;
              for(int i=0;i<cam.width*cam.height;i++)
               {
                  if((red(cam.pixels[i])<redthresh)||(blue(cam.pixels[i])<bluethresh)||(green(cam.pixels[i])<greenthresh)){
                      cam.pixels[i]=color(0,0,0);
                      newPixels[i%cam.width][i/cam.width] = new smartPixel(null, color(0,0,0), i%cam.width, i/cam.width);
               }else{
                     int xpos = (i%cam.width);
                     int ypos = (i/cam.width);
                     pointx+=(i%cam.width);
                     pointy+=(i/cam.width);
                     numpoints++;
                     
                     smartPixel newp = new smartPixel(null, color(255,255,255), xpos, ypos);
                     
                     if (xpos > 0) {
                       smartPixel p1 = newPixels[xpos-1][ypos];
                     
                       if (p1.c == color(255,255,255)) {
                        
                           p1.clust.sm.add(newp);
                           newp.clust = p1.clust;
                           p1.clust.centerx = (p1.clust.centerx*p1.clust.sm.size()+newp.x)/(p1.clust.sm.size()+1);
                           p1.clust.centery = (p1.clust.centery*p1.clust.sm.size()+newp.y)/(p1.clust.sm.size()+1);
                         
                       }
                     }
                     if (ypos > 0 && xpos >0) {
                       smartPixel p2 = newPixels[xpos-1][ypos-1];
                       if (p2.c == color(255,255,255)) {
                         if(newp.clust != null) {
                           unionClusters(newp.clust, p2.clust);
                         } else {
                           p2.clust.sm.add(newp);
                           newp.clust = p2.clust;
                           p2.clust.centerx = (p2.clust.centerx*p2.clust.sm.size()+newp.x)/(p2.clust.sm.size()+1);
                           p2.clust.centery = (p2.clust.centery*p2.clust.sm.size()+newp.y)/(p2.clust.sm.size()+1);
                         }
                       }
                     }
                     if (ypos > 0) {
                       smartPixel p3 = newPixels[xpos][ypos-1];
                       if (p3.c == color(255,255,255)) {
                         if(newp.clust != null) {
                           unionClusters(newp.clust, p3.clust);
                         } else {
                           p3.clust.sm.add(newp);
                           newp.clust = p3.clust;
                           p3.clust.centerx = (p3.clust.centerx*p3.clust.sm.size()+newp.x)/(p3.clust.sm.size()+1);
                           p3.clust.centery = (p3.clust.centery*p3.clust.sm.size()+newp.y)/(p3.clust.sm.size()+1);
                         }
                       }
                     }
                     if(newp.clust == null) {
                       cluster newc = new cluster(newp);
                       clusters.add(newc);
                       newp.clust = newc;
                     }
                     newPixels[xpos][ypos] = newp;
                     aboveThreshold.add(newp);
                     
                     //cam.pixels[i]=color(255,255,255);
                     
                  }
               }
               /*
               if(numpoints!=0)
               {
               pointx=pointx/numpoints;
               pointy=pointy/numpoints;
               }
               
               cam.pixels[pointx+pointy*cam.width]=color(255,0,0);
               if(pointx<(cam.width/2))
                 z=f0-k*((cam.width/2)-(double)pointx);
              else
                z=f0+k*((double)pointx-(cam.width/2));
                println("POINT: " + pointx);
                println(z);
                */
                for(int q=0;q<clusters.size();++q) {
                  cluster cc  = (cluster) clusters.get(q);
                  cam.pixels[int(cc.centery)*cam.width+int(cc.centerx)] = color(255,0,0); 
                 // println(cc.sm.size());
                }
                if(clusters.size()==1)
                {
                  cluster a=(cluster) clusters.get(0);
               if(a.centerx< (cam.width/2))
                 z=f0+k*((cam.width/2)-(double)a.centerx);
              else
                z=f0-k*((double)a.centerx-(cam.width/2));
                 // println("z= "+z);       
                   depth=(float)  z;           
                }
	newFrame = true; 
} 


void keyPressed() {
  if(key == 'c') {
    points.clear();
  }

  if(key==' '){
    collectPoints=!collectPoints;
  }
    if (key == 'z') {
    camera1.zoom(.01);
   
  }
  if (key == 'x') {
    camera1.zoom(-.01);
  }
  if(key=='t'){
    camera1.tilt(-.01);
  }
  if(key=='g')
    camera1.tilt(.01);
  if(key=='y')
    camera1.roll(-.01);
  if(key=='h')
    camera1.roll(.01);
  if(key=='u')
    camera1.pan(-.01);
  if(key=='j')
    camera1.pan(.01);
}
void mouseDragged(){
  if (mouseButton == CENTER) {
      camera1.zoom(radians(mouseY - pmouseY) / 2.0);
    }
  if (mouseButton == LEFT) {
      camera1.truck(- mouseX + pmouseX);
      camera1.boom(- mouseY + pmouseY);
    }
  if (mouseButton == RIGHT) {
    camera1.circle(radians(-mouseX + pmouseX));
    camera1.arc(radians(-mouseY + pmouseY));
    
  }
}


class Linear{
  public float acceleration, velocity, position;
  Linear(){
    acceleration=0;
    velocity=0;
    position=0;
  }
  Linear(float x, float y, float z)
  {
     acceleration=x;
     velocity=y;
     position=z;
  }
}

class smartPixel {
  smartPixel parent;
  color c;
  int numPix, x,y;
  float centerx, centery;
  cluster clust;
  smartPixel() {
    
  }
  
  smartPixel(smartPixel p, color _c, int _x, int _y) {
    parent = p;
    c = _c;
    numPix = 1;
    x = _x;
    y = _y;
    centerx = _x;
    centery = _y;
    clust = null;
  }
  
  smartPixel union(smartPixel n) {
    smartPixel temp1 = this;
    while(temp1.parent !=null) {
      //println(temp1.parent.x + " " + temp1.parent.y);
      temp1 = temp1.parent;
    }
    smartPixel temp = n;
    while(temp.parent!=null) {
      temp = temp.parent;
      //println("ELSE");
    }
    if(temp.x != temp1.x && temp.y != temp1.y) {
     temp.parent = temp1;
     //println("ASD: " + temp1.centerx + " " + temp1.centery + " " + numPix);
     temp1.centerx = (float)(temp1.centerx*temp1.numPix+temp.centerx*temp.numPix)/(float)(temp1.numPix+temp.numPix);
     temp1.centery = (float)(temp1.centery*temp1.numPix+temp.centery*temp.numPix)/(float)(temp1.numPix+temp.numPix);
     //println(temp1.centerx + " " + temp1.centery + " " + numPix);
     temp1.numPix += temp.numPix;
    }
    return temp1;
  }
  
  
}

class cluster {
  ArrayList sm;
  float centerx,centery;
  int id;
  
  cluster() {
    id = _id++;
    sm = new ArrayList();
  }
  
  cluster(smartPixel p) {
    id = _id++;
    sm = new ArrayList();
    sm.add(p);
    centerx = p.x;
    centery = p.y;
  }
}

void unionClusters(cluster c1, cluster c2) {
  if(c1.id == c2.id) return;
  for(int i=0;i<c2.sm.size();++i) {
    smartPixel pp = (smartPixel) c2.sm.get(i);
    c1.centerx = (c1.centerx*c1.sm.size()+pp.x)/(c1.sm.size()+1);
    c1.centery = (c1.centery*c1.sm.size()+pp.y)/(c1.sm.size()+1);
    pp.clust = c1;
    c1.sm.add(pp);
  }
  for(int i=0;i<clusters.size();++i) {
    cluster t = (cluster) clusters.get(i);
    if(t.id == c2.id) {
      clusters.remove(i);
      return;
    }
  }
}

class tPoint{
  float x,y,z,depth;
  tPoint(float a, float b, float c,float d)
  {
    x=a;
    y=b;
    z=c;
    depth=d;
  }
}
