/*
This is a simple WhiteNoise generator. It can be started with .play(float amp).
In this example it is started and stopped by clicking into the renderer window.
*/
import processing.sound.*;
import java.util.ArrayList;

final PApplet THIS_APP = this;
final int CUTOFF_FREQ = 400;
final int DIST_THRESHOLD = 300;


class SoundPoint {
   public PVector position;
   public SqrOsc osc;
   public LowPass lpf;
   
   public SoundPoint(PVector pos, int frequency) {
      this.position = pos;
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
// ArrayList<SoundPoint> soundPoints;

int strokeIndex = 0;
ArrayList<ArrayList<SoundPoint>> strokes;

LowPass lowPass;
LowPass lp2;
boolean pressed = false;
boolean isNewStroke = true;
boolean butChanged = false;
boolean playNow = false;
int N = 15;

int currIndex = 0;
int currFreq = 300;
float amp=0.0;

PVector currentPos;


//Colors 
final int NUM_COLORS = 9;
int Green = #009688;
int Yellow = #FFEB3B;
int Red = #E64A19;
int Blue = #03A9F4;
int Lime = #CDDC39;
int Orange = #FF9800;
int Purple = #7C4DFF;
int Brown = #795548;
int Pink = #F8BBD0;
int[] colors = {Green, Yellow, Red, Blue, Lime, Orange, Purple, Brown, Pink};

void setup() {
  size(640,480);
  background(102);
  oscArray = new ArrayList<SqrOsc>();
  lpfArray = new ArrayList<LowPass>();
  // soundPoints = new ArrayList<SoundPoint>();
  strokes = new ArrayList<ArrayList<SoundPoint>>();
  currentPos = new PVector(mouseX, mouseY);

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

void createPaint() {
 // Now if the mouse is pressed, paint
 if (mousePressed)
 {
   smooth();
   noStroke();
   fill(colors[strokeIndex % NUM_COLORS]);
   ellipseMode(CENTER);
   ellipse(mouseX,mouseY,20,20);
 }
}


void draw() {

  if(mousePressed) {
      currFreq += 10;  
      
      if(isNewStroke) {
        isNewStroke = false;
        //strokeIndex = strokeIndex == 0 ? 0 : strokeIndex+1;
        strokeIndex++;
        strokes.add(new ArrayList<SoundPoint>());
        print("New stroke: " + strokeIndex);
      }

      //Add soundPoint to current list of soundPoints
      PVector pos = new PVector(mouseX, mouseY);
      SoundPoint newPoint = new SoundPoint(pos, currFreq);
      strokes.get(strokeIndex-1).add(newPoint);
  }
  else {
    isNewStroke = true;
  }
  
  createPaint();
  delay(10);
   
   currentPos.x = mouseX;
   currentPos.y = mouseY;
   for (ArrayList<SoundPoint> points : strokes) {
      //Find the point with the min dist in the stroke and play
      playClosestPoint(points, currentPos);
   }
}

 
 void playClosestPoint(ArrayList<SoundPoint> points, PVector pos) {
      
      if(points.size() == 0) { return; }

      float minDist = Integer.MAX_VALUE;
      SoundPoint point = null;

      for(SoundPoint sp : points) {
        float dist = pos.dist(sp.position);
        if(dist < minDist) {
          minDist = dist;
          if(point != null) { point.osc.amp(0.0); } //Turn off previous minimum's sound
          point = sp;
        }
        else {
          sp.osc.amp(0.0);
        }
      }
      
      if(point == null) return;

      //Play the minimum dist
      if(minDist > DIST_THRESHOLD) { point.osc.amp(0.0); }
      else { point.osc.amp(map(minDist,0.0,DIST_THRESHOLD,1.0,0.0)); } 
  }