XMLElement xml;
Position position;
lookingAt subject;

void setup() {
   size(200,200);
   position=new Position();
   subject=new lookingAt();
   xml=new XMLElement(this, "panel.xml");
   println(xml.getName());
   println();
   for(int i=0;i<xml.getChildCount();i++)
   {
     XMLElement nextElement=xml.getChild(i);
     for(int j=0;j<nextElement.getChildCount();j++)
     {
       XMLElement child=nextElement.getChild(j);
       println("Sub-Element:  "+child.getName());
       String name=child.getName();
         if(name.equals("lookingAt")){
          subject.lookingAt=child.getStringAttribute("lookingAt");
          subject.type=child.getStringAttribute("type");
          if(subject.type.equals("exact")){
            subject.position.x=child.getIntAttribute("x");
            subject.position.y=child.getIntAttribute("y");
            
          }
          if(name.equals("position")){
           position.x=child.getIntAttribute("x");
           position.y=child.getIntAttribute("y");
          }
       }
     }
     
   }
}

void draw()
{
  background(0,0,255);
}


class character{
  String name;
  Head head;
   character(String charName){
     name=charName;
     String filename=charName+".xml";
     XMLElement charFile=new XMLElement(this, filename);\
     head=new Head(charFile);
   } 
   void drawCharacter(){
     head.drawHead();
   }
}

class Head{
  Position position;
  Eye leftEye, rightEye;
  color skinColor
  head(XMLElement charElement){
    
  }
  void drawHead()
  {
    fill(skinColor);
    leftEye.drawEye();
    rightEye.drawEye();
  }
}

class Eye{
  Position position
  Eye(XMLElement eyeElement, Position headPosition, String side){
  }
  void drawEye()
  {
  }
}

class lookingAt{
 String lookingAt, type;
 Position position;
  lookingAt()
  {
    position=new Position();
  }
}

class Position{
  int x, y;
  Position()
  {
  }
}

class colorParser{
  colorParser()
  {
  }
  color getColor(String name)
  {
    if(name.equals("blond"))
      return color(230, 200, 0);
    if(name.equals("blue"))
      return color(0, 0, 255);
    if(name.equals("tan"))
      return color(130, 100, 0);
    if(name.equals("black"))
      return color(0, 0, 0);
    if(name.equals("white"))
      return color(255, 255, 255);
    else
      return color(0);    
    
  }
}
