Cell[][] array;
 
LinkedList bins;
LinkedList cells;
 
int arrayX=3;
int arrayY=3;
int cellWidth=50;
int cellHeight=50;
int posTerminalx,posTerminaly,negTerminalx,negTerminaly;
void setup()
{
  size(800,600);
  array=new Cell[(int)arrayX][(int)arrayY];
  cells=new LinkedList();
  for(int i=0;i<arrayX;i++)
  {
    for(int j=0;j<arrayY;j++)
    {
      float current=sqrt(pow(arrayX,2)+pow(arrayY,2))-sqrt(pow((i-(arrayX-1)/2),2)+pow((j-(arrayY-1)/2),2));
      array[i][j]=new Cell(i,j, current);
      println(current);
      boolean inserted=false;
      if(cells.size()>0)
        for(int index=0;index<cells.size();index++)
        {
          Cell a=(Cell)cells.get(index);
         if(index<(arrayX*arrayY-1)
         {    
              cells.add(array[i][j]);
         }
        else
          cells.add(array[i][j]);
      println(i+ " "+j);
    }
}

/*    printlndkjfsl;j(cells.size());
    for(int i=0;i<cells.size();i++)
    {
      Cell a= (Cell) cells.get(i);
      println(a.current);
    }*/
    posTerminalx=width/2+((int)arrayX*cellWidth)/2;
    negTerminalx=width/2+((int)arrayX*cellWidth)/2;
    posTerminaly=height/2+(((int)arrayY+1)*cellWidth)/2;
    negTerminaly=height/2+(((int)arrayY+1)*cellWidth)/2+cellWidth/2;

}
void draw()
{
  background(0);
  for(int i=0;i<arrayX;i++)
    for(int j=0;j<arrayY;j++)
    {
      fill(array[i][j].current);
      stroke(0);
      rect(array[i][j].xPos,array[i][j].yPos,cellWidth, cellHeight);
    }
    for(int i=0;i<arrayX;i++)
      for(int j=0;j<arrayY;j++)
      {
      for(int a=0;a<arrayX;a++)
        for(int b=0;b<arrayY;b++)
        {
          noFill();
          if(array[i][j].switches[0][a][b])
           {
            stroke(130,0,0);
            line(array[i][j].posTerminalx,array[i][j].posTerminaly,array[a][b].posTerminalx,array[a][b].posTerminaly); 
           }
          if(array[i][j].switches[1][a][b])
           {
            stroke(0,0,130);
            line(array[i][j].negTerminalx,array[i][j].negTerminaly,array[a][b].negTerminalx,array[a][b].negTerminaly); 
           }
          if(array[i][j].switches[2][a][b])
           {
            stroke(130,0,0);
            line(array[i][j].posTerminalx,array[i][j].posTerminaly,array[a][b].negTerminalx,array[a][b].negTerminaly); 
           }
          if(array[i][j].switches[3][a][b])
           {
            stroke(130,0,130);
            line(array[i][j].negTerminalx,array[i][j].negTerminaly,array[a][b].posTerminalx,array[a][b].posTerminaly); 
           }
        }
           if(array[i][j].switches[0][0][(int)arrayY])
           {
            stroke(130,0,0);
            line(array[i][j].posTerminalx,array[i][j].posTerminaly,posTerminalx,posTerminaly); 
           }
          if(array[i][j].switches[1][0][(int)arrayY])
           {
            stroke(0,0,130);
            line(array[i][j].negTerminalx,array[i][j].negTerminaly,negTerminalx,negTerminaly); 
           }
      } 
}
 
class myLine{
  LinkedList points;
  float current;
  myLine()
  {
    current=0;
    points=new LinkedList();
  }
 
}
 
class myPoint{
  int row, column;
  myPoint(int a, int b)
  {
    row=a;
    column=b;
  }
}

class Cell{
  int x,y;
  int xPos, yPos;
  int posTerminalx, posTerminaly;
  int negTerminalx, negTerminaly;
  
  float current;
  boolean[][][] switches;
  Cell(int a, int b, float c)
  {
    x=a;
    y=b;
    current=c;

      xPos=(int)(width/2+((float)x-(float)arrayX/2)*cellWidth);
      yPos=(int)(height/2+((float)y-(float)arrayY/2)*cellHeight);
      posTerminalx=(xPos+cellWidth/2);
      posTerminaly=(yPos+cellWidth/4);
      negTerminalx=(xPos+cellWidth/2);
      negTerminaly=(yPos+3*cellWidth/4);
      
    switches=new boolean[4][(int)arrayX][(int)arrayY+1];  //a switch for every other cell in the array, plus the output terminal
    //switch[0][x]=from my cell's positive terminal to cell X's positive terminal
    //switch[1][x]=from my cell's negative terminal to cell X's negative terminal
    //switch[2][x]=from my cell's positive terminal to cell X's negative terminal
    //switch[3][x]=from my cell's negative terminal to cell X's positive terminal
  
      if(x<=arrayX-2)
      {
        switches[0][x+1][y]=true;
        switches[1][x+1][y]=true;
      }
      else
      {
        switches[0][0][y+1]=true;
        switches[1][0][y+1]=true;
      }
  }
}

class Bin{
  LinkedList cells;
  Bin(){
    cells=new LinkedList();
  }
  
}
