 
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
	cam = new Capture(this, 320, 240, 15); 
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
              int redthresh=50;
              int bluethresh=100;
              int greenthresh=100;
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
 
 
 
// ================================================== 
// Super Fast Blur v1.1 
// by Mario Klingemann  
// <http://incubator.quasimondo.com> 
// ================================================== 
void fastblur(PImage img,int radius) 
{ 
 if (radius<1){ 
    return; 
  } 
  int w=img.width; 
  int h=img.height; 
  int wm=w-1; 
  int hm=h-1; 
  int wh=w*h; 
  int div=radius+radius+1; 
  int r[]=new int[wh]; 
  int g[]=new int[wh]; 
  int b[]=new int[wh]; 
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw; 
  int vmin[] = new int[max(w,h)]; 
  int vmax[] = new int[max(w,h)]; 
  int[] pix=img.pixels; 
  int dv[]=new int[256*div]; 
  for (i=0;i<256*div;i++){ 
    dv[i]=(i/div); 
  } 
 
  yw=yi=0; 
 
  for (y=0;y<h;y++){ 
    rsum=gsum=bsum=0; 
    for(i=-radius;i<=radius;i++){ 
      p=pix[yi+min(wm,max(i,0))]; 
      rsum+=(p & 0xff0000)>>16; 
      gsum+=(p & 0x00ff00)>>8; 
      bsum+= p & 0x0000ff; 
    } 
    for (x=0;x<w;x++){ 
 
      r[yi]=dv[rsum]; 
      g[yi]=dv[gsum]; 
      b[yi]=dv[bsum]; 
 
      if(y==0){ 
        vmin[x]=min(x+radius+1,wm); 
        vmax[x]=max(x-radius,0); 
      } 
      p1=pix[yw+vmin[x]]; 
      p2=pix[yw+vmax[x]]; 
 
      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16; 
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8; 
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff); 
      yi++; 
    } 
    yw+=w; 
  } 
 
  for (x=0;x<w;x++){ 
    rsum=gsum=bsum=0; 
    yp=-radius*w; 
    for(i=-radius;i<=radius;i++){ 
      yi=max(0,yp)+x; 
      rsum+=r[yi]; 
      gsum+=g[yi]; 
      bsum+=b[yi]; 
      yp+=w; 
    } 
    yi=x; 
    for (y=0;y<h;y++){ 
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum]; 
      if(x==0){ 
        vmin[y]=min(y+radius+1,hm)*w; 
        vmax[y]=max(y-radius,0)*w; 
      } 
      p1=x+vmin[y]; 
      p2=x+vmax[y]; 
 
      rsum+=r[p1]-r[p2]; 
      gsum+=g[p1]-g[p2]; 
      bsum+=b[p1]-b[p2]; 
 
      yi+=w; 
    } 
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
