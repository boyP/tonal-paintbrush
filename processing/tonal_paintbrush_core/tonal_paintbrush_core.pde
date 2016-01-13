/**
 * TONAL PAINTBRUSH // Build18 2016
 
     Pratik Prakash
     Ameya Kamat
     Mark McElwaine
     Mark Fernandez
     
   *** DEPENDENCIES ***
   Processing Sound Library
   HTTP Requests Library
   
   (to install, go to Sketch > Import Library > Add Library)
   
   ********************
   
   January 12th, 2016.
            
 */
 
 //imports
 import http.requests.*;
 import processing.sound.*;
 import java.util.ArrayList;
 import java.util.List;

 //Constants
 final String   SERVER_URL   = "http://192.168.4.1:80";
 final int      CUTOFF_FREQ  = 200;
 final PApplet  THIS_APP     = this;
 final int      DRAW_DELAY   = 10;
 final int      CREATE_POINT_INTERVAL = 10; //the number of DRAW_DELAYs until a point is sampled
 
  /**
  * SoundPoint is a class representing one of the several instances of a brush stroke
  * x:                The x position in 3-D space
  * y:                The y position in 3-D space
  * z:                The z position in 3-D space
  * strokeID:         The stroke to which the SoundPoint belongs
  * analogSoundValue: The value of the sound played
  */
 class SoundPoint {
   PVector position;
   int analogReading;
   SqrOsc osc;
   LowPass lpf;
   
   SoundPoint(PVector position, int analogReading) {
     this.position = position;
     this.analogReading = analogReading;
     osc = new SqrOsc(THIS_APP);
     osc.freq(analogReadingToFrequency(analogReading));
      osc.amp(0.0); //initialise with 0 amplitude
      lpf = new LowPass(THIS_APP);
      osc.play();
      lpf.process(osc,CUTOFF_FREQ);
      
   }
 }
 
 //Fields
 boolean buttonPressed = false;
 int currentAnalogVal;
 int currentASV;
 PVector currentPos;
 GetRequest getRequest;
 ArrayList<SoundPoint> soundPoints;
 int tickNumber = 0;
 

 void setup() {
   size(640, 520);
   getRequest = new GetRequest(SERVER_URL);
   PVector currentPos = new PVector(0,0,0);
   soundPoints = new ArrayList<SoundPoint>();

   //Kinect Setup
   setupKinect();
 }
 
 void draw() {

  delay(DRAW_DELAY);
  
  tickNumber++;
  
  //First check webserver to update button state
  updateBrushState();

  updateSoundState();

  if(buttonPressed) {
    
    if(tickNumber % CREATE_POINT_INTERVAL == 0) {
      //Create soundPoints
      PVector pos = getPositionVector();
      SoundPoint newPoint = new SoundPoint(pos, currentAnalogVal);
      soundPoints.add(newPoint);
    }
  }

  drawKinect();
 }
 
 
 /*=========================*
  * Web Server Polling
  *=========================*/
  boolean updateBrushState() {
    getRequest.send();
    String webTxt =  getRequest.getContent();
    String [] webTxtArr = split(webTxt,':');
    
    currentAnalogVal = int(webTxtArr[1]);
    buttonPressed = int(webTxtArr[0]) == 0;
    return true;
  }


 /*=========================*
  * Kinect Interface
  *=========================*/
  void setupKinect() {
  }
  
  void drawKinect() {
  }

  /**
   * Gets the current x,y,z position of the brush
   */
  PVector getPositionVector() {
    return null;
  }
  
 /*=========================*
  * Sound Interface
  *=========================*/

  void updateSoundState() {
    if(soundPoints.size() == 0) {
        return;
    }
    
    for(SoundPoint sp : soundPoints) {
       //Update amplitude based on distance 
    }
  }

  /**
   * Go through the list of sounds and play the sounds
   */
  void playSounds(List<SoundPoint> soundPoints) {
    for (SoundPoint point : soundPoints) {
      //int sound = point.analogReading * calculateRatio(currentPos, point.position);
      //Play sound
    }
  }

  /**
   * Calculate the distance between the current brush position and the sound point position.
   * Returns: a fraction representing the fraction of the max volume the sound should be played at.
   */
  float calculateRatio(PVector currPos, PVector pos) {
    return 1;
  }



  /**
  * Conversion function from ADC reading to frequecy
  *
  */
  int analogReadingToFrequency(int reading) {
     return int(map(reading, 0, 1024, 100,1000)); 
  }


  