/*
This is a simple WhiteNoise generator. It can be started with .play(float amp).
In this example it is started and stopped by clicking into the renderer window.
*/
import http.requests.*;
import processing.sound.*;
import java.util.ArrayList;

final PApplet THIS_APP = this;
final int CUTOFF_FREQ = 400;
final int DIST_THRESHOLD = 300;


class SoundPoint {
   public int x,y;
   public SqrOsc osc;
   public LowPass lpf;
   
   public SoundPoint(int x, int y, int frequency) {
      this.x = x;
      this.y = y;
      osc = new SqrOsc(THIS_APP);
      osc.freq(frequency);
      osc.amp(0.0);
      lpf = new LowPass(THIS_APP);
      osc.play();
      lpf.process(osc,CUTOFF_FREQ);
      
   }
}

ArrayList<SqrOsc> oscArray;
ArrayList<LowPass> lpfArray;
ArrayList<SoundPoint> soundPoints;

LowPass lowPass;
LowPass lp2;
GetRequest req;
boolean pressed = false;
boolean butChanged = false;
boolean playNow = false;
int N = 15;

int currIndex = 0;
int currFreq = 300;
float amp=0.0;


void setup() {
  size(500, 700);
  oscArray = new ArrayList<SqrOsc>();
  lpfArray = new ArrayList<LowPass>();
  soundPoints = new ArrayList<SoundPoint>();
  
  /*
  for(int i = 0; i<N; i++) {
    SqrOsc currOsc = new SqrOsc(this);
    currOsc.freq(100 + 10*i);
    LowPass currLpf = new LowPass(this);
    currOsc.play();
    currLpf.process(currOsc,700);
    currOsc.amp(0.1); //initially 0 volume
    
    oscArray.add(currOsc);
    lpfArray.add(currLpf);
    
  }
  */
  

}

void draw() {
  
  delay(10);
  
 
  if(soundPoints.size() > 0) {
    for(SoundPoint soundPoint : soundPoints) {
       float dist = sqrt(pow(soundPoint.x - mouseX,2) + pow(soundPoint.y - mouseY,2));
       SqrOsc currOsc = soundPoint.osc;
       
       if(dist > DIST_THRESHOLD) {
          currOsc.amp(0.0); 
       } else {
          currOsc.amp(map(dist,0,DIST_THRESHOLD,1.0,0.0)); 
       }
    }
  }
}


void mousePressed() {
  currFreq += 50;  
  SoundPoint newPoint = new SoundPoint(mouseX, mouseY, currFreq);
  
  soundPoints.add(newPoint);
    
}