XMLElement xml;
Position position;
lookingAt subject;
LinkedList characters;

void setup() {
   size(200,200);
   position=new Position();
   subject=new lookingAt();
   characters=new LinkedList();
   
   XMLElement panel=new XMLElement(this, "panel.xml");
   setupCharacters(panel);
}

void setupCharacters(XMLElement panel)
{
     for(int i=0;i<panel.getChildCount();i++) //loop through the panel bits
     {
       XMLElement a=panel.getChild(i);
       if(a.getName().equals("characters"))
        for(int j=0;j<a.getChildCount();j++) //loop through all the characters in the panel
         {
           XMLElement currentCharacter=a.getChild(j);
           String name=currentCharacter.getName()+".xml";
           XMLElement characterFile=new XMLElement(this, name);
           //TODO--make sure the character file exists
           characters.add(new character(currentCharacter, characterFile)); //create a linked list of all the characters, creating each character as we go
         } 
     }
       
}

void draw()
{
  background(0,0,255);
  for(int i=0;i<characters.size();i++)
  {
    character a=(character)characters.get(i);
    a.drawCharacter();
    
  }
}


class character{
  String name;
  colorParser parser;
  Head head;
  Position position;
   character(XMLElement characterPose, XMLElement charFile){  //characterPose describes how the character looks in this particular panel
     position=new Position();
     parser=new colorParser();
     name=characterPose.getName();
     String filename=name+".xml";
     for(int i=0;i<characterPose.getChildCount();i++) //loop through all the sub-elements of a character's pose
     {
       XMLElement a=characterPose.getChild(i);
       if(a.getName().equals("position"))
       {
         if(a.getStringAttribute("type").equals("exact"))  //if the position is specified in terms of (x,y) pixels
         {
           position.x=a.getIntAttribute("x");
           position.y=a.getIntAttribute("y");
         }
       }
     }
     
    for(int i=0;i<charFile.getChildCount();i++) //now loop through all the elements of the general character description and 
                                                //create objects for each major element
    {
      XMLElement a=charFile.getChild(i);
      if(a.getName().equals("head"))
      {
        head=new Head(a,characterPose);
      }
    }      
                                                 

   } 
   void drawCharacter(){
     head.drawHead();
   }
   color getColor(String colorName)
   {
      return(parser.getColor(colorName));
   }
}

class Head{
  Position position;
  Eye leftEye, rightEye;
  int headWidth, headHeight;
  color skinColor;
  colorParser parser;
  Head(XMLElement headElement, XMLElement panel){
    parser=new colorParser();
  
    for(int i=0;i<panel.getChildCount();i++)
    {
      XMLElement a=panel.getChild(i);
    }
  }
  void drawHead()
  {
    fill(skinColor);
    ellipse(position.x,position.y, headWidth, headHeight);
    leftEye.drawEye();
    rightEye.drawEye();
  }

}

class Eye{
  Position position;
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
  Position(int a, int b)
  {
    x=a;
    y=b;
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
      return color(165, 42, 42);
    else
      return color(0);    
    
  }
}
