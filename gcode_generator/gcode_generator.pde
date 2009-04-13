
PrintWriter out;

void setup()
{
  out=createWriter("output.sbp");
  
  int lineNumber=1;

  double x,y,z, theta;
  double centerX=20;
  double centerY=10;
  double radius=0;
  double Zstart=1;
  double Zfinish=0;
  double zStep=.025;
  double thetaStep=.01;
  double temp;
  String xString, yString, zString, lineNumberString;
  double maxRadius=radius+((Zstart-Zfinish)*2);
  double toolDiameter=.25;

  out.println("IF %(25)=1 THEN GOTO UNIT_ERROR\r\n");
  out.println("SA\r\n");
  out.println("SO,1,1\r\n");
  out.println("PAUSE 2\r\n");
  out.println("MS, 6, 3\r\n");
  out.println("JZ,2\r\n");
  out.println("J2,0.0,0.0\r\n");
  for(z=Zstart;z>Zfinish;z-=zStep)
  { 
    zString=nf((float)z,3,3);
    for(theta=0;theta<2*PI;theta+=thetaStep)
     {
      x=centerX+(radius*cos((float)theta));
      y=centerY+(radius*sin((float)theta));
      xString=nf((float)x,3,3);
      yString=nf((float)y,3,3);
      lineNumberString=nf(lineNumber, 4);
      out.println("M3,"+xString+","+yString+","+zString+"\r\n");
//      out.println("N"+ lineNumberString+" M3 X"+xString+" Y"+yString+" Z"+zString);
      lineNumber++;
    }
    radius+=2*zStep;
  }
  noLoop();
}
