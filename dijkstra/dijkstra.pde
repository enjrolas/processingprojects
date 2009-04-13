Graph g;
LinkedList Q, S, previous;
String source="here";
String target="there";
void setup()
{
  Q=new LinkedList();
  S=new LinkedList();
  g=new Graph();
  addPoints();
  previous=new LinkedList();
  addPoints();
  myVertex a;
  for (int i=0;i<g.vertices.size();i++)
  {
      a=(myVertex)g.vertices.get(i);
      if(a.name==source);
         {
           a.distance=0;
           g.vertices.set(i,a);
         }     
  }
  runStuff();
  
}

void addPoints()
{
  g.addDistance("here","somewhere else", 5);
  g.addDistance("raleigh","somewhere else", 2);
  g.addDistance("Raleigh","Boston", 4);
  g.addDistance("Boston","there", 3);
}

void draw()
{
}

void runStuff()
{  
  Q=g.vertices;
  float alt;
  myVertex u,v;
  while(Q.size()>0)
  {
    println(Q.size());
    if(previous.size()==0)
      u=g.getVertex(source);
    else
    {
      u=getMinimum();
    }
    for(int i=0;i<u.neighbors.size();i++)
    {
      myVertex a=(myVertex)u.neighbors.get(i);
      println(a.name);
    }
    for(int j=0;j<u.neighbors.size();j++)
    {
       v=(myVertex)u.neighbors.get(j);
       alt=u.distance + u.getLength(v.name);
       println("u.distance and v.distance: "+u.distance+" "+v.distance);
       if(alt<v.distance)
       {
         v.distance=alt;
         u.neighbors.set(j,v);
         previous.add(u);
       }
    }  
    Q.remove(g.getIndex(u.name));
  }
  for(int i=0;i<previous.size();i++)
  {
    myVertex a=(myVertex)previous.get(i);
    print(a.name+" ");
  }
}

myVertex getMinimum()
{
    float currentMinimum=50000000;
    int minIndex=0;
    myVertex a;
    for(int i=0;i<g.vertices.size();i++)
    {
      a=(myVertex)Q.get(i);
      println("A.distance= "+a.distance);
      if(a.distance<currentMinimum)
        {
          minIndex=i;
          currentMinimum=a.distance;
        }
    }
    return (myVertex)Q.get(minIndex);
  }


class Graph{
  LinkedList vertices;
  Graph()
  {
    vertices=new LinkedList();
  }
  void newPoint(String s)
  {    
    vertices.add(new myVertex(s, 50000000));
  }
  void addDistance(String s, String d, float distance)
  {
    myVertex a, source, destination;
    int sIndex=-1;
    int dIndex=-1;
    int i;
    for(i=0;i<vertices.size();i++)
    {
      a=(myVertex)vertices.get(i);
      if(a.name==s)
        sIndex=i;
      if(a.name==d)
        dIndex=i;
    }
    if(sIndex==-1)//the source point didn't exist yet
    {
      vertices.add(new myVertex(s, 50000000));
      sIndex=i;
      i++;
    }
    if(dIndex==-1)//the source point didn't exist yet
    {
      vertices.add(new myVertex(d, 50000000));
      dIndex=i;
    }
    source=(myVertex)vertices.get(sIndex);
    destination=(myVertex)vertices.get(dIndex);
    boolean present=false;
    for(int k=0;k<source.neighbors.size();k++)
      {
        myVertex z=(myVertex)source.neighbors.get(k);
        if(destination.name==z.name)
          present=true;
      }
     if(present==false)
     {
        source.edges.add(new edge(destination.name, distance));
        source.neighbors.add(destination);
     }
    present=false;
    for(int k=0;k<destination.neighbors.size();k++)
      {
        myVertex z=(myVertex)destination.neighbors.get(k);
        if(source.name==z.name)
          present=true;
      }
      if(present==false)
      {
        destination.edges.add(new edge(source.name, distance));
        destination.neighbors.add(source);
      }
  }
  myVertex getVertex(String name)
  {
    myVertex a,b;
    b=new myVertex("",0);
    for(int i=0;i<vertices.size();i++)
      {
        a=(myVertex)vertices.get(i);
        if(name==a.name)
          b=a;
      }
      return b;
  }
  int getIndex(String name)
  {
  myVertex a;
  int b=0;
    for(int i=0;i<vertices.size();i++)
      {
        a=(myVertex)vertices.get(i);
        if(name==a.name)
          b=i;
      }
      return b;
  }
  

}

class myVertex{
  String name;
  float distance;
  LinkedList edges, neighbors;
  myVertex(String n, float d){
    edges=new LinkedList();
    neighbors=new LinkedList();
    name=n;
    distance=d;
  }
  float getLength(String d)
  {
    edge a,b;
    b=new edge("",0);
    for(int i=0;i<edges.size();i++)
      {
        a=(edge)edges.get(i);
        if(a.destination==d)
          b=a;
      }
      return b.weight;
  }
}

class edge{
  String destination;
  float weight;
  edge(String d, float w)
  {
    destination=d;
    weight=w;
  }
}
