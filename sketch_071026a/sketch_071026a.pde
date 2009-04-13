import processing.opengl.*;

import damkjer.ocd.*;

Camera camera1;


void setup() {
  size(500,500,OPENGL);
  smooth();
  camera1 = new Camera(this,500,0,0,0,0,0);
}

void draw() {
  background(255);
  stroke(0);
  box(40);
  camera1.feed();
}

void keyPressed(){
  if (key == 'z') {
    camera1.zoom(.01);
   
  }
  if (key == 'x') {
    camera1.zoom(-.01);
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
