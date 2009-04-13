import processing.opengl.*;
import java.awt.event.*;
import processing.core.*;

OCDCamera camera1;


LinkedList levels;

float radius=350;
int numPoints=9;
int skip=2;
float theta=0;
float phi=0;
int layers=10;
float angle_step=360/numPoints;
void setup()
{
  size(1200,700, OPENGL);
  camera1 = new OCDCamera(this,1000,1000,1000,width/2,height/2,0);
  levels=new LinkedList();
  for(int i=0;i<layers;i++)
  { 
    level a;
   if(i==0)   
   {
    a=new level(numPoints, radius, skip,30);
   }
   else
   {
    level b=(level)levels.get(i-1);
    a=new level(numPoints, b.childRadius, skip,b.angle+angle_step/2);
   }
   
    levels.add(a);
  }
}


void draw()
{
  background(0);
  camera1.feed();
  stroke(255,0,255);
  for(int count=0;count<layers;count++)
  {
  fill(0);
  LinkedList intersections, points;
  level a=(level)levels.get(count);
  intersections=a.intersections;
  points=a.points;
  myPoint point1,point2,intersection;
 // ellipse(width/2,height/2,a.radius*2,a.radius*2);
  int i=0;
  phi=0;
  for(int j=(1+numPoints/2);j<numPoints;j++)
  {
  do{
    point1=(myPoint)points.get(i);
    intersection=(myPoint)intersections.get(i);
    myPoint intersectiona, intersectionb;
    fill(0,0,255);
    if(i>=1)
    {
      intersectionb=(myPoint)intersections.get(i-1);
    }
    else
      intersectionb=(myPoint)intersections.get(i-1+numPoints);
    if(i>=2)
    {
      intersectiona=(myPoint)intersections.get(i-2);
    }
    else
      intersectiona=(myPoint)intersections.get(i-2+numPoints);
   //   println(count);
  // //if(count<3)
  //    triangle(point1.x,point1.y,intersectiona.x,intersectiona.y,intersectionb.x,intersectionb.y); 

    fill(0,0,255);
   // ellipse(intersection.x,intersection.y,5,5);
    i+=skip;
    if(i>=numPoints)
      i-=numPoints;
    point2=(myPoint)points.get(i);
  stroke(255);
 // line(point1.x,point1.y,point2.x,point2.y);
 // line(width/2+a.radius*cos(radians(a.angle+theta)),height/2+a.radius*sin(radians(a.angle+theta)),width/2+a.radius*cos(radians(a.angle+theta+2*angle_step)),a.radius*sin(radians(phi)),height/2+a.radius*sin(radians(a.angle+theta+2*angle_step)),a.radius*sin(radians(phi)));
  line(width/2+((numPoints-j)/numPoints)*a.radius*cos(radians(a.angle+theta))*sin(radians(phi)),height/2+((numPoints-j)/numPoints)*a.radius*sin(radians(a.angle+theta))*sin(radians(phi)),radius/2+((numPoints-j)/numPoints)*a.radius*cos(radians(phi)));
  if(theta>360)
    theta-=360;
    
 //   line(width/2+((point1.x-width/2)*cos(theta)),height/2+((point1.y-height/2)*sin(theta)),width/2+((point2.x-width/2)*cos(theta)),height/2+((point2.y-height/2)*sin(theta)));
  //  line(point1.x+a.radius*cos(theta),point1.y+a.radius*sin(theta),point2.x+a.radius*cos(theta),point2.y+a.radius*sin(theta));
  // line(point1.x+a.radius*cos(theta),point1.y,point2.x+a.radius*cos(theta),point2.y);
 // roke(0,0,255);
  //line(width/2,height/2,point1.x,point1.y);
  }while(i!=0);
  phi+=360/numPoints;
  }
  }
  theta+=.05;
}

void keyPressed(){
  if (key == 'z') {
    camera1.zoom(.01);
   
  }
  if (key == 'x') {
    camera1.zoom(-.01);
  }
  if(key=='a'){
    camera1.arc(radians(10));
  }
  if(key=='d'){
    camera1.arc(radians(-10));
  }
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




class myPoint{
  float x,y;
  myPoint(float a, float b)
  {
    x=a;
    y=b;
  }
}

class myLine{
  float a,b;
  myLine(float i, float j)
  {
    a=i;
    b=j;
  }
}

class level{
  
  int numPoints, skip;
  float radius, childRadius, angle;
  LinkedList points, lines, intersections;
  
  level(int num, float rad, int skype, float angel)
  {
    points=new LinkedList();
    lines=new LinkedList();
    intersections=new LinkedList();
    numPoints=num;
    radius=rad;
    skip=skype;
    angle=angel;
    newPoints(angel);
    findLines();
    findIntersections();
  }
void newPoints(float angle)
{
  points.clear();
  float theta=angle;
  for(int i=0;i<numPoints;i++)
  { 
    points.add(new myPoint(width/2+radius*cos(radians(theta)),height/2+radius*sin(radians(theta))));
    theta+=360/numPoints;
  }
}

void findLines()
{
  for(int i=0;i<numPoints;i++)
  {
    myLine liney;
    myPoint point1,point2;
    float a,b;
      point1=(myPoint)points.get(i);
    if(i<=(numPoints-3))
      point2=(myPoint)points.get(i+2);
    else
    {
     // println(i+ " "+(i+2-numPoints));
      point2=(myPoint)points.get(i+2-numPoints);
    }
      b=(point1.y-point2.y)/(point1.x-point2.x);
      a=point1.y-(point1.x*b);
      liney=new myLine(a,b);
     // println(a+" "+b);
      lines.add(liney);
  }
}
void findIntersections()
{
  for(int i=0;i<numPoints;i++)
  {
   float x,y;
   float a1,a2,b1,b2;
   myLine line1,line2;
   myPoint point1;
   point1=(myPoint)points.get(i);
   line1=(myLine)lines.get(i);
   if(i<=(numPoints-2))
     line2=(myLine)lines.get(i+1);
  else
  {
     line2=(myLine)lines.get(i+1-numPoints);
  //  println(i+1-numPoints);
  }
  x=((line1.a-line2.a)/(line2.b-line1.b));
  y=line1.a+line1.b*x;
  intersections.add(new myPoint(x,y));
  }
  myPoint rad;
  rad=(myPoint)intersections.get(0);
  childRadius=sqrt(pow((rad.x-width/2),2)+pow(rad.y-height/2,2));
}
}







/**

 * Data Type for manipulating the Processing viewport. There are

 * several ways to create a Camera, but all cameras are manipulated

 * the same way. The default camera position sits on the positive

 * z-axis. The default target position is at the world origin. The

 * default up direction is in the negative y. The default

 * field-of-view is PI/3 radians. The default aspect ratio is the

 * ratio of the applet width to the applet height. The default near 

 * clipping plane is placed a 1/10 x shot length. The default far

 * clipping plane is placed at 10x the shot length.

 *

 * @author  Kristian Linn Damkjer

 * @version OCD 1.0

 * @version Processing 0087

 * @since   OCD 1.0

 * @since   Processing 0087

 */ 

public class OCDCamera {

    private static final float TWO_PI = (float) (2 * Math.PI);

    private static final float PI = (float) Math.PI;

    private static final float HALF_PI = (float)(Math.PI / 2);

    private static final float TOL = 0.00001f;



    //--- Attributes ----------

    private PApplet parent;



    /** Camera Orientation Information */

    private float azimuth,

                  elevation,

                  roll;



    /** Camera Look At Information */

    private float cameraX, cameraY, cameraZ,        // Camera Position

                  targetX, targetY, targetZ,        // Target Position

                  upX,     upY,     upZ,            // Up Vector

                  fov, aspect, nearClip, farClip;   // Field of View, Aspect Ratio, Clip Planes



    /** The length of the view vector */

    private float shotLength;



    /** distance differences between camera and target */

    private float dx, dy, dz;





    //--- Constructors --------



    /** 

     * Create a camera that sits on the z axis

     */

    public OCDCamera(PApplet parent) {

        this(parent, (parent.height / 2f) / parent.tan(PI/6));

    }

    

    /** Gimme just a wee bit o' control, please. */

    public OCDCamera(PApplet parent, float shotLength) {

        this(parent, 0, 0, shotLength);

    }



    /** Gimme just a little bit more control oughtta do it. */

    public OCDCamera(PApplet parent, float cameraX, float cameraY, float cameraZ) {

        this(parent, cameraX, cameraY, cameraZ, 0, 0, 0);

    }

        

    // OK, I fancy myself a Director. Step aside.

    public OCDCamera(PApplet parent,

                  float cameraX, float cameraY, float cameraZ,

                  float targetX, float targetY, float targetZ) {

        this(parent,

             cameraX, cameraY, cameraZ,

             targetX, targetY, targetZ,

                   0,       1,       0,

             (PI / 3), 1f * parent.width / parent.height, 0, 0);

        nearClip = shotLength / 10;

        farClip = shotLength * 10;

    }

    

    // I mean it! Give me the controls already!

    public OCDCamera(PApplet parent,

                  float cameraX, float cameraY, float cameraZ,

                  float targetX, float targetY, float targetZ,

                  float upX,     float upY,     float upZ,

                  float fov, float aspect, float nearClip, float farClip) {

        this.parent = parent;

        this.cameraX = cameraX;

        this.cameraY = cameraY;

        this.cameraZ = cameraZ;

        this.targetX = targetX;

        this.targetY = targetY;

        this.targetZ = targetZ;

        this.upX = upX;

        this.upY = upY;

        this.upZ = upZ;

        this.fov = fov;

        this.aspect = aspect;

        this.nearClip = nearClip;

        this.farClip = farClip;

        

        dx = cameraX - targetX;

        dy = cameraY - targetY;

        dz = cameraZ - targetZ;

        

        shotLength = sqrt(dx * dx + dy * dy + dz * dz);

        azimuth    = atan2(dx, dz);

        elevation  = atan2(dy, sqrt(dz * dz + dx * dx));

        

        if (elevation > HALF_PI - TOL) {

          this.upY =  0;

          this.upZ = -1;

        }



        if (elevation < TOL - HALF_PI) {

          this.upY =  0;

          this.upZ =  1;

        }

    }



    //--- Behaviors ----------



    /** Send what this camera sees to the view port */

    public void feed() {

      parent.perspective(fov, aspect, nearClip, farClip);

      parent.camera(cameraX, cameraY, cameraZ,

             targetX, targetY, targetZ,

             upX,     upY,     upZ);

    }



    /** Aims the camera at the specified target */

    public void aim(float targetX, float targetY, float targetZ) {



        // Move the target

        this.targetX = targetX;

        this.targetY = targetY;

        this.targetZ = targetZ;



        // Describe the new vector between the camera and the target

        dx = cameraX - targetX;

        dy = cameraY - targetY;

        dz = cameraZ - targetZ;



        // Describe the new azimuth and elevation for the camera

        shotLength = sqrt(dx * dx + dy * dy + dz * dz);

        azimuth    = atan2(dx, dz);

        elevation  = constrain(atan2(dy, sqrt(dz * dz + dx * dx)), TOL-HALF_PI, HALF_PI-TOL);

        

        // update the up vector

        updateUp();

    }

                

    /** Jumps the camera to the specified position */

    public void jump(float positionX, float positionY, float positionZ) {



        // Move the camera

        this.cameraX = positionX;

        this.cameraY = positionY;

        this.cameraZ = positionZ;



        // Describe the new vector between the camera and the target

        dx = cameraX - targetX;

        dy = cameraY - targetY;

        dz = cameraZ - targetZ;



        // Describe the new azimuth and elevation for the camera

        shotLength = sqrt(dx * dx + dy * dy + dz * dz);

        azimuth    = atan2(dx, dz);

        elevation  = constrain(atan2(dy, sqrt(dz * dz + dx * dx)), TOL-HALF_PI, HALF_PI-TOL);

        

        // update the up vector

        updateUp();

    }

                

    /** Changes the field of view between "fish-eye" and "close-up" */

    public void zoom(float amount) {

        fov = constrain(fov + amount, TOL, PI - TOL);

    }



    /** Moves the camera and target simultaneously along the camera's X axis */

    public void truck(float amount) {



        // Calculate the camera's "X" vector

        float cXx = dy * upZ - dz * upY;

        float cXy = dx * upZ - dz * upX;

        float cXz = dx * upY - dy * upX;



        // Normalize the "X" vector so that it can be scaled

        float magnitude = sqrt(cXx * cXx + cXy * cXy + cXz * cXz);

        magnitude = (magnitude < TOL) ? 1 : magnitude;

        cXx /= magnitude;

        cXy /= magnitude;

        cXz /= magnitude;



        // Perform the truck, if any

        cameraX -= amount * cXx;

        cameraY -= amount * cXy;

        cameraZ -= amount * cXz;

        targetX -= amount * cXx;

        targetY -= amount * cXy;

        targetZ -= amount * cXz;

    }



    /** Moves the camera and target simultaneously along the camera's Y axis */

    public void boom(float amount) {

        // Perform the boom

        cameraX += amount * upX;

        cameraY += amount * upY;

        cameraZ += amount * upZ;

        targetX += amount * upX;

        targetY += amount * upY;

        targetZ += amount * upZ;

    }

    

    /** Moves the camera and target along the view vector */

    public void dolly(float amount) {

        float dirX = dx / shotLength;

        float dirY = dy / shotLength;

        float dirZ = dz / shotLength;

        

        cameraX += amount * dirX;

        cameraY += amount * dirY;

        cameraZ += amount * dirZ;

        targetX += amount * dirX;

        targetY += amount * dirY;

        targetZ += amount * dirZ;

    }

    

    /** Rotates the camera about its X axis */

    public void tilt(float elevationOffset) {



        // Calculate the new elevation for the camera

        elevation = constrain(elevation - elevationOffset, TOL-HALF_PI, HALF_PI-TOL);



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        targetX = cameraX - ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        targetY = cameraY - (-shotLength * cos(HALF_PI + elevation));

        targetZ = cameraZ - ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }

    

    /** Rotates the camera about its Y axis */

    public void pan(float azimuthOffset) {



        // Calculate the new azimuth for the camera

        azimuth = (azimuth - azimuthOffset + TWO_PI) % TWO_PI;



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        targetX = cameraX - ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        targetY = cameraY - (-shotLength * cos(HALF_PI + elevation));

        targetZ = cameraZ - ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }

    

    /** Rotates the camera about its Z axis

     *  NOTE: rolls will NOT affect the azimuth, but WILL affect plans, trucks, and booms

     */

    public void roll(float amount) {

        // Change the roll amount

        roll += amount;

        

        // Update the up vector

        updateUp();

    }



    /** Arcs the camera over (under) a center of interest along a set azimuth*/

    public void arc(float elevationOffset) {



        // Calculate the new elevation for the camera

        elevation = constrain(elevation + elevationOffset, TOL-HALF_PI, HALF_PI-TOL);



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        cameraX = targetX + ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        cameraY = targetY + (-shotLength * cos(HALF_PI + elevation));

        cameraZ = targetZ + ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }



    /** Circles the camera around a center of interest at a set elevation*/

    public void circle(float azimuthOffset) {



        // Calculate the new azimuth for the camera

        azimuth = (azimuth + azimuthOffset + TWO_PI) % TWO_PI;



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        cameraX = targetX + ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        cameraY = targetY + (-shotLength * cos(HALF_PI + elevation));

        cameraZ = targetZ + ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }



    /** Tumbles the camera about its center of interest */

    public void tumble(float azimuthOffset, float elevationOffset) {



        // Calculate the new azimuth and elevation for the camera

        azimuth = (azimuth + azimuthOffset + TWO_PI) % TWO_PI;

        elevation = constrain(elevation + elevationOffset, TOL-HALF_PI, HALF_PI-TOL);



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        cameraX = targetX + ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        cameraY = targetY + (-shotLength * cos(HALF_PI + elevation));

        cameraZ = targetZ + ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }



    /** Allows the camera to freely look around its origin */

    public void look(float azimuthOffset, float elevationOffset) {



        // Calculate the new azimuth and elevation for the camera

        elevation = constrain(elevation - elevationOffset, TOL-HALF_PI, HALF_PI-TOL);

        azimuth = (azimuth - azimuthOffset + TWO_PI) % TWO_PI;



        // Orbit to the new azimuth and elevation while maintaining the shot distance

        targetX = cameraX - ( shotLength * sin(HALF_PI + elevation) * sin(azimuth));

        targetY = cameraY - (-shotLength * cos(HALF_PI + elevation));

        targetZ = cameraZ - ( shotLength * sin(HALF_PI + elevation) * cos(azimuth));



        // update the up vector

        updateUp();

    }



    /** Moves the camera and target simultaneously in the camera's X-Y plane */

    public void track(float xOffset, float yOffset) {

        // Perform the truck, if any

        truck(xOffset);



        // Perform the boom, if any

        boom(yOffset);

    }



    //---- Helpers -------------------------------------------------------------

    /** */

    private void updateUp() {



        // Describe the new vector between the camera and the target

        dx = cameraX - targetX;

        dy = cameraY - targetY;

        dz = cameraZ - targetZ;



        // Calculate the new "up" vector for the camera

        upX = -dx * dy;

        upY =  dz * dz + dx * dx;

        upZ = -dz * dy;



        // Normalize the "up" vector

        float magnitude = sqrt(upX * upX + upY * upY + upZ * upZ);

        magnitude = (magnitude < TOL) ? 1 : magnitude;

        upX /= magnitude;

        upY /= magnitude;

        upZ /= magnitude;

        

        // Calculate the roll if there is one

        if (roll != 0) {



            // Calculate the camera's "X" vector

            float cXx = dy * upZ - dz * upY;

            float cXy = dx * upZ - dz * upX;

            float cXz = dx * upY - dy * upX;



            // Normalize the "X" vector so that it can be scaled

            magnitude = sqrt(cXx * cXx + cXy * cXy + cXz * cXz);

            magnitude = (magnitude < 0.001) ? 1 : magnitude;

            cXx /= magnitude;

            cXy /= magnitude;

            cXz /= magnitude;



            // Perform the roll

            cXx *= sin(roll);        

            cXy *= sin(roll);        

            cXz *= sin(roll);        

            upX *= cos(roll);

            upY *= cos(roll);

            upZ *= cos(roll);

            upX += cXx;

            upY += cXy;

            upZ += cXz;

        }

    }



    //--- Simple Hacks ----------

    private final float radians(float a) {

      return parent.radians(a);

    }



    private final float sin(float a) {

      return parent.sin(a);

    }



    private final float cos(float a) {

      return parent.cos(a);

    }



    private final float tan(float a) {

      return parent.tan(a);

    }



    private final float sqrt(float a) {

      return parent.sqrt(a);

    }



    private final float atan2(float y, float x) {

      return parent.atan2(y, x);

    }



    private final float degrees(float a) {

      return parent.degrees(a);

    }



    private final float constrain(float v, float l, float u) {

      return parent.constrain(v, l, u);

    }

}
