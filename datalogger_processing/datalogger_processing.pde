
import processing.serial.*;

PrintWriter output;
float sensorEpsilon = 0.01;

int numSamples = 1000;
Serial myPort;  // The serial port

float[][] voltage = new float[numSamples][2];
float[] temperature = new float[numSamples];
float[] R = new float[numSamples];
float R0 = 10000.0;
float R2 = 10000.0;
float B = 3950;
float T0 = 298.0;
boolean full_set = false;
boolean noData = false;

PFont font;

int data[] = new int[100];
int index, i;
int vindex;

void setup() {
  size(10,10);
  //size(screen.width, screen.height);
  // List all the available serial ports
  println(Serial.list());


  output=createWriter("log.csv");
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);
  
  for(int i=0;i<100;i++)
    for(int j=0;j<2;j++)
      voltage[i][j]=0;
  
  font = loadFont("AmericanTypewriter-Light-18.vlw"); 
  textFont(font); 
  output.println("Time (seconds), Temperature (degrees C)");
  
  vindex=0;
}

float display(float temp_in)
{
  temp_in -= 273;
  temp_in = 100 - temp_in;
  temp_in *= 6;
  temp_in += 100;
  return temp_in;
}

float display_c(float temp_in)
{
  temp_in = 100 - temp_in;
  temp_in *= 6;
  temp_in += 100;
  return temp_in;
}

float data_request(char channel)
{
  int rawValue = 0;
  while (rawValue == 0) {
    myPort.write(channel);
    delay(50);
    
    i=0;
    while(myPort.available()>0) {
      data[i] = myPort.read();
      i++;
    }
    
    if (data[2] == channel) {
      rawValue = data[0] + data[1]*256;
    }
    else
      rawValue = 0;
      
    myPort.clear();
  }
  
  return (float)rawValue;
}


float get_data(char channel)
{
  ArrayList<Float> samples = new ArrayList(); 
  ArrayList<Float> differences = new ArrayList();
  ArrayList<Float> bestMeasurements = new ArrayList();
  
  for(int i = 0; i < samples.size(); i++)
    samples.add(data_request(channel));
    
  for(int i = 0; i < samples.size(); i++) {
    ArrayList<Float> samplesSubset = samples;
    samplesSubset.remove(i);
    differences.add(abs(subtractList(samplesSubset)));
  }

  
  float[] arrayDifferences = ArrayList_to_array(differences);
  float smallestDiff = min(arrayDifferences);
  bestMeasurements.add(samples.get(differences.indexOf(smallestDiff)));
  
  for (int i = 0; i < differences.size(); i++){
    float thisDifference = differences.get(i);
    if(abs(thisDifference - smallestDiff) < sensorEpsilon){
      bestMeasurements.add(samples.get(i));
    }
  }
  
  return average(bestMeasurements);
}


float subtractList(ArrayList subtractionList) {
 ArrayList<Float> toSubtract = new ArrayList(subtractionList);
 float subtraction = 0.0;
 for(int i = 0; i < toSubtract.size(); ++i){
   subtraction -= toSubtract.get(i);
 } 
 
 return subtraction;
}


float addList(ArrayList additionList) {
 ArrayList<Float> toAdd = new ArrayList(additionList);
 float addition = 0.0;
 for(int i = 0; i < toAdd.size(); ++i){
   addition += toAdd.get(i);
 }
 
 return addition;
}

float average(ArrayList samples) {
  return addList(samples)/samples.size();
}

float[] ArrayList_to_array(ArrayList arrayList) {
 ArrayList<Float> theArrayList = new ArrayList(arrayList);
 float[] theArray = new float[theArrayList.size()];
 for(int i = 0; i < theArrayList.size(); ++i){
   theArray[i] = theArrayList.get(i);
 }
 
 return theArray;
}

void draw()
{
  voltage[index][0] = get_data('0');
  voltage[index][1] = get_data('1');
  
  R[index] = R2*((float)voltage[index][0]/(float)voltage[index][1])-R2;
  temperature[index]=B/log(R[index]/(R0*exp(-1*B/T0)));
  
  if((temperature[index]-273)>100)
       output.println(300*(float)index/1000+","+nf((temperature[index]-273),3,1));
  else if((temperature[index]-273)>10)
       output.println(300*(float)index/1000+","+nf((temperature[index]-273),2,1));
  else if((temperature[index]-273)>-10)
       output.println(300*(float)index/1000+","+nf((temperature[index]-273),1,1));



  background(0);
  

  stroke(0,0,255);
  line(0,display_c(0),numSamples,display_c(0));
  stroke(0,255,0);
  line(0,display_c(25),numSamples,display_c(25));
  line(0,display_c(50),numSamples,display_c(50));
  line(0,display_c(75),numSamples,display_c(75));
  stroke(255,0,0);
  line(0,display_c(100),numSamples,display_c(100));

  stroke(255);
  text("0 degrees C",numSamples,display_c(0));
  text("25 degrees C",numSamples,display_c(25));
  text("50 degrees C",numSamples,display_c(50));
  text("75 degrees C",numSamples,display_c(75));
  text("100 degrees C",numSamples,display_c(100));

  for(i=0;i<(numSamples-1);i++)
  {
   /*  stroke(0,255,0);
     line(i,3*voltage[i][0],i+1,3*voltage[i+1][0]);
     stroke(0,0,255);
     line(i,3*voltage[i][1],i+1,3*voltage[i+1][1]);
     */


     stroke(255,255,0);
     line(i,display(temperature[i]),i+1,display(temperature[i+1]));

  }
       fill(255,0,0);
       
       if(noData)
         stroke(255,0,0);
       else
       {
         stroke(0,255,0);
       } 
        
     ellipse(index,display(temperature[index]),5,5);
     text(temperature[index]-273,index+5,display(temperature[index])-5);
 
     if(!noData)
       index++;
  
    if(index>=2)
      full_set=true;
    if(index==numSamples)
    {
      index=0;
    }
}

void keyPressed()
{
  output.flush();
  output.close();
  exit();
}
