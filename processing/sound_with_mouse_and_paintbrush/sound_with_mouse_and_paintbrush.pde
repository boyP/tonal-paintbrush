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
   public SawOsc osc;
   public LowPass lpf;
   
   public SoundPoint(int x, int y, int frequency) {
      this.x = x;
      this.y = y;
      osc = new SawOsc(THIS_APP);
      osc.freq(frequency);
      osc.amp(0.0);
      lpf = new LowPass(THIS_APP);
      osc.play();
      lpf.process(osc,CUTOFF_FREQ);
      
   }
}

ArrayList<SawOsc> oscArray;
ArrayList<LowPass> lpfArray;
ArrayList<SoundPoint> soundPoints;

int counter = 0;
LowPass lowPass;
LowPass lp2;
GetRequest req;
boolean pressed = false;
int analogValue = 0;
boolean butChanged = false;
boolean playNow = false;
int N = 15;

int currIndex = 0;
int currFreq = 300;
float amp=0.0;


void setup() {
  size(500, 700);
  req = new GetRequest("http://192.168.4.1:80");
  oscArray = new ArrayList<SawOsc>();
  lpfArray = new ArrayList<LowPass>();
  soundPoints = new ArrayList<SoundPoint>();
  

}

void draw() {
  
  delay(10);
  
  counter++;
  if(pressed) {
    if(counter % 10 == 0) {
       createSoundPoint(); 
    }
  }
  
  updateBrushState();
  
  updateSoundState();
  
  
}

void updateSoundState() {
   if(soundPoints.size() > 0) {
    for(SoundPoint soundPoint : soundPoints) {
       float dist = sqrt(pow(soundPoint.x - mouseX,2) + pow(soundPoint.y - mouseY,2));
       SawOsc currOsc = soundPoint.osc;
       
       if(dist > DIST_THRESHOLD) {
          currOsc.amp(0.0); 
       } else {
          currOsc.amp(map(dist,0,DIST_THRESHOLD,1.0,0.0)); 
       }
    }
  } 
}

void updateBrushState() {
  
  req.send();
  String webTxt =  req.getContent();
  String [] webTxtArr = split(webTxt,':');
  
  analogValue = int(webTxtArr[1]);
  int butReading = int(webTxtArr[0]);
  
  pressed = butReading == 0;
}

void createSoundPoint() {
  
  int frequency = int(map(analogValue, 0, 1024, 200,1000));
  SoundPoint newPoint = new SoundPoint(mouseX, mouseY, frequency);
  soundPoints.add(newPoint);
  
}


void mousePressed() {
  /*
  currFreq += 50;  
  SoundPoint newPoint = new SoundPoint(mouseX, mouseY, currFreq);
  
  soundPoints.add(newPoint);
  */
    
}