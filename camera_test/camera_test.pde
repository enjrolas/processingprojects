 
import processing.video.*; 
 
Capture cam; 
PImage img; 
boolean newFrame=false; 
int _id =0;

ArrayList aboveThreshold;
ArrayList clusters;
// ================================================== 
// setup() 
// ================================================== 
void setup() 
{ 
	// Size of applet 
	size(320, 240); 
	// Capture 
/*        String[] cameras=Capture.list();
        println(cameras.length);
        for(int i=0;i<cameras.length;i++)  
          println(cameras[i]);*/
	cam = new Capture(this, 320, 240,15);   

	// BlobDetection 
	// img which will be sent to detection (a smaller copy of the cam frame); 
	img = new PImage(320,240);  
	//theBlobDetection = new BlobDetection(img.width, img.height); 
	//theBlobDetection.setPosDiscrimination(true); 
	//theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f; 
      clusters = new ArrayList();
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
                      //cam.pixels[i]=color(0,0,0);
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
                  println(cc.sm.size());
                }
	newFrame = true; 
} 
 
// ================================================== 
// draw() 
// ================================================== 
void draw() 
{ 
	if (newFrame) 
	{ 
                background(255);
		newFrame=false; 
		
		img.copy(cam, 0, 0, cam.width, cam.height,  
				0, 0, img.width, img.height);
                image(cam,0,0,width,height); 
           
		//fastblur(img, 2);
                
		//theBlobDetection.computeBlobs(img.pixels); 
		//drawBlobsAndEdges(true,true); 
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
