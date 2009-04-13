float[] samples;
float[] FFT;
float[] weighted_samples;
LinkedList peaks;
float scaling=100;
float frequency=1000;
int samples_per_second=10000;
int num_samples=100;
float dir=10;
int max_freq=10000;
void setup()
{
  peaks=new LinkedList();
  samples=new float[num_samples];
  weighted_samples=new float[num_samples];
  FFT=new float[1+(int)((max_freq/(2*PI)))];
  size(800,600);
  for(int i=0;i<num_samples;i++)
  {
    samples[i]=sin(frequency*i/samples_per_second);
    println(samples[i]+ " "+i);
  }
}

void draw()
{
  background(0);
  stroke(0,255,0);  
  for(int i=0;i<(num_samples-1);i++)
  {
    line(i*(width/num_samples),scaling*samples[i]+height/2, (i+1)*(width/num_samples), scaling*samples[i+1]+height/2);
  }
  stroke(0,0,255);
  for(int omega=0;omega<max_freq/(2*PI);omega++)
  {
    FFT[omega]=goertzel(omega);
    line(omega/2,600,omega/2,600-.25*FFT[omega]);
  }
  find_peaks();
  for(int i=0;i<peaks.size();i++)
  {
    Peak a=(Peak)peaks.get(i);
    stroke(255,0,0);
    line(a.freq/2,600,a.freq/2,400);
  }
  for(int i=0;i<num_samples;i++)
  {
//    samples[i]=sin(frequency*i/samples_per_second);
    samples[i]=sin(frequency*i/samples_per_second)+sin(.75*frequency*i/samples_per_second + PI/3)+cos(1.5*frequency*i/samples_per_second + PI/3);
  }    
  blackman();
  frequency+=dir;
  if((frequency>max_freq)||(frequency<100))
    dir*=-1;
}

void find_peaks()
{
  float prev_slope, slope;
  float noise_threshhold=50;
  prev_slope=0;
  peaks.clear();
  for(int i=0;i<(max_freq/(2*PI))-1;i++)
  {
     slope=FFT[i+1]-FFT[i];
     if(((prev_slope>0)&&(slope<0))&&(FFT[i]>noise_threshhold))
     {
       peaks.add(new Peak(i));
       println("peak!");
     }
     prev_slope=slope;
    
  }
}

//puts a sin^2 blackman window on the samples, which improves the 
//accuracy of the algorithm
void blackman()
{
  for (int i=0;i<num_samples;i++)
     weighted_samples[i]=samples[i]*sin(i*PI/num_samples)*sin(i*PI/num_samples);
}
//run goertzel's algorithm and return the power at the specified frequency
float goertzel(float omega)
{
  float s_prev=0;
  float s_prev2=0;
  float coeff = 2.0 * cos( (2.0 * PI * omega) / samples_per_second );
  for(int i=0; i < num_samples; i++)
  {
    float s = weighted_samples[i] + coeff * s_prev - s_prev2;
    s_prev2=s_prev;
    s_prev=s;
  }
  float power = s_prev2 * s_prev2 + s_prev * s_prev - coeff * s_prev2 * s_prev;
  return power;
}

class Peak{
  int freq;
  Peak()
  {
    freq=0;
  }  
  Peak(int i)
  {
    freq=i;
  }
}
