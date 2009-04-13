import processing.core.*; import processing.opengl.*; import java.awt.event.*; import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class spherical_outline extends PApplet {





LinkedList slices;
    OCDCamera camera1;
float radius=600;
float numLayers=20;

int numPoints=20;
float t=0;
int skip=2;
float c=0;
float d=0;
float theta=0;
float numSlices=5;
float angle_step=360/numPoints;
public void setup()
{
    camera1 = new OCDCamera(this,0,0,1000  ,width/2,height/2,0);
  size(1200,700,P3D);
  slices=new LinkedList();
  for(float tilt=0;tilt<360;tilt+=180/numSlices)
  {
    slice a=new slice(tilt);
    slices.add(a);
  }
  //noLoop();
}


public void draw()
{
  background(0);
  camera1.feed();

      pointLight(255,255,255,width/2,height/2,100);
      pointLight(255,255,255,width/2,height/2,-100);
      pointLight(255,255,255,width/2,height/2+200,0);
      pointLight(255,255,255,width/2,height/2-200,0);
      pointLight(255,255,255,width/2+200,height/2,0);
      pointLight(255,255,255,width/2-200,height/2,0);
    
  stroke(255,0,255);
  slice homeSlice;
  LinkedList levels;
  for(int sliceIndex=0;sliceIndex<numSlices;sliceIndex++)
  {
    homeSlice=(slice)slices.get(sliceIndex);
    levels=homeSlice.levels;
  for(int count=0;count<numLayers;count++)
  {
  fill(0,120,0);
  LinkedList points, nextPoints;
  level a=(level)levels.get(count);
  if(count<numLayers-1)
  {
    level b=(level)levels.get(count+1);
    nextPoints=b.points;
  }
  else
  {
    nextPoints=a.points;
  }
  points=a.points;
  myPoint point1,point2;

  for(int i=0;i<points.size();i++)
  {
    point1=(myPoint)points.get(i);
    if(i>=1)
      point2=(myPoint)points.get(i-1);
    else
    {
      point2=(myPoint)points.get(points.size()-1);
    }
 // stroke(100);
   stroke(0);
  line(width/2+point1.x,height/2+point1.y,point1.z,width/2+point2.x,height/2+point2.y,point2.z);
  if(count<numLayers-1)
  {
    fill(255*sin((float)count/5+2*t),255*cos((float)count/5+3*t/21),255*cos((float)count/5+2*t/9));
    myPoint nextPoint;
    if((i-1)>=0)
      nextPoint=(myPoint)nextPoints.get(i-1);
    else
      nextPoint=(myPoint)nextPoints.get(nextPoints.size()-1);
    t+=.00001f;
    c+=.00004f;
    d+=.000005f;
    beginShape();
    vertex(width/2+point1.x,height/2+point1.y,point1.z);
    vertex(width/2+point2.x,height/2+point2.y,point2.z);
    vertex(width/2+nextPoint.x,height/2+nextPoint.y,nextPoint.z);
    endShape();
    stroke(255);

//      pointLight(255,255,255,width/2+point1.x,height/2+point1.y,point1.z);

//      line(width/2+point2.x,height/2+point2.y,point2.z,width/2+nextPoint.x,height/2+nextPoint.y,nextPoint.z);
//    arcAmount=.00002*sin(4*t);
  //  circleAmount=.00005*sin(.5*t);
    camera1.arc(.00002f*sin(c));
    camera1.circle(.00005f*sin(d));
//    camera1.zoom(.000002*sin(t));
if(c>2*PI)
  c=0;
 if(d>2*PI)
   d=0;
  }
    }
  }
  }
}

class myPoint{
  float x,y,z;
  myPoint(float a, float b, float c)
  {
    x=a;
    y=b;
    z=c;
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

class slice{
  LinkedList levels;
  slice(float tilt)
  {
    levels=new LinkedList();
    for(int i=0;i<numLayers;i++)
    { 
      level a;
      if(i==0)   
     {
      a=new level(numPoints, radius, skip,0,tilt);
     }
     else
     {
      level b=(level)levels.get(i-1);
      a=new level(numPoints, b.childRadius, skip,b.angle+angle_step, tilt);
     }
   
      levels.add(a);
    }
  }
}

class level{
  
  int numPoints, skip;
  float radius, childRadius, angle, tilt;
  LinkedList points;
  
  level(int num, float rad, int skype, float angel, float tilty)
  {
    points=new LinkedList();
    numPoints=num;
    radius=rad;
    skip=skype;
    angle=angel;
    tilt=tilty;
    newPoints(angel);
  }
public void newPoints(float angle)
{
  points.clear();
  theta=angle;
  for(float phi=angle;phi!=360+angle;phi+=2*angle_step)
  { 
    if(phi>(360+angle))
      phi-=360;
     float c,b;
     c=radius;
     b=radius*cos(radians(tilt));
     float x,y,z;
     y=c*cos(radians(phi));
     x=b*sin(radians(phi));
     float rPrime=sqrt(pow(x,2)+pow(y,2));
     if(rPrime>radius)
       rPrime=radius;
     theta=degrees(asin(rPrime/radius));
   //  x=radius*cos(radians(phi))*sin(radians(theta));
    // y=radius*sin(radians(theta))*sin(radians(phi));
     z=(phi>180?-1:1)*radius*cos(radians(theta));
    points.add(new myPoint(x,y,z));  
  }
  float beta_angle=3*angle_step/2;
  float gamma=(180-2*angle_step)/2;
  childRadius=radius*sin(radians(beta_angle))/sin(radians(gamma));
  println(radius+" "+childRadius);
//  childRadius=radius*sin(radians(alpha_angle))/sin(radians(gamma));
}
}

public void mouseDragged(){
  if (mouseButton == CENTER) {
      camera1.zoom(radians(mouseY - pmouseY) / 2.0f);
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
public void keyPressed(){
    if(keyCode==UP)
      camera1.pan(.05f);
    if(keyCode==DOWN)
      camera1.pan(-.05f);
    if(keyCode==LEFT)
      camera1.arc(.05f);
    if(keyCode==RIGHT)
      camera1.arc(-.05f);
    if(keyCode==',')
      camera1.circle(.05f);
    if(keyCode=='.')
      camera1.circle(-.05f);
    if(key=='z')
      camera1.zoom(.1f);
    if(key=='x')
      camera1.zoom(-.1f);
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

            magnitude = (magnitude < 0.001f) ? 1 : magnitude;

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

  static public void main(String args[]) {     PApplet.main(new String[] { "spherical_outline" });  }}