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
  
 import KinectPV2.KJoint;
 import KinectPV2.*;

 //Constants
 final String   SERVER_URL   = "http://192.168.4.1:80";
 final int      CUTOFF_FREQ  = 200;
 final PApplet  THIS_APP     = this;
 final int      DRAW_DELAY   = 5;
 final int      CREATE_POINT_INTERVAL = 1; //the number of DRAW_DELAYs until a point is sampled
 final float    DIST_THRESHOLD = 0.8;
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
   TriOsc osc;
   LowPass lpf;
   
   SoundPoint(PVector position, int analogReading) {
     this.position = position;
     this.analogReading = analogReading;
     osc = new TriOsc(THIS_APP);
     osc.freq(analogReadingToFrequency(analogReading));
      osc.amp(0.0); //initialise with 0 amplitude
      lpf = new LowPass(THIS_APP);
      osc.play();
      lpf.process(osc,CUTOFF_FREQ);
      
   }
 }
 
 //Fields
 boolean buttonPressed = false;
 boolean isNewStroke = true;
 int currentAnalogVal;
 int currentASV;
 PVector currentPos;
 GetRequest getRequest;
 // ArrayList<SoundPoint> soundPoints;

 int strokeIndex = 0;
 ArrayList<ArrayList<SoundPoint>> strokes;
 int tickNumber = 0;

 KinectPV2 kinect;
 float zVal = 300;
 float rotX = PI;
 
 //Colors 
 /* UNCOMMENT WHEN YOU WANT TO ADD PAINT
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
 */

 void setup() {
   size(1024, 768,P3D);
   getRequest = new GetRequest(SERVER_URL);
   currentPos = new PVector(0,0,0);
   // soundPoints = new ArrayList<SoundPoint>();

   strokes = new ArrayList<ArrayList<SoundPoint>>();
   //Kinect Setup
   setupKinect();
 }
 
 void draw() {

  delay(DRAW_DELAY);
  
  //Clear all
  if(keyPressed) {
    if(key == 'C') {
      strokeIndex = 0;
      isNewStroke = true;
      strokes = new ArrayList<ArrayList<SoundPoint>>();
    }
  }
  
  tickNumber++;
  
  //First check webserver to update button state
  updateBrushState();

  updateSoundState();

  if(buttonPressed) {
    
    //Either creating a new stroke on in same stroke
    if(tickNumber % CREATE_POINT_INTERVAL == 0) {

      if(isNewStroke) {
        //Create a new slot in the array
        strokeIndex++;
        strokes.add(new ArrayList<SoundPoint>());
        isNewStroke = false;
        println("created new stroke: " + strokeIndex);
      }

      //Add soundPoint to current list of soundPoints
      PVector pos = new PVector(currentPos.x, currentPos.y, currentPos.z);
      SoundPoint newPoint = new SoundPoint(pos, currentAnalogVal);
      strokes.get(strokeIndex-1).add(newPoint);
    }
  }
  else {
    //Button is not pressed
    isNewStroke = true;
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
     kinect = new KinectPV2(this);
  
    kinect.enableColorImg(true);
  
    //enable 3d  with (x,y,z) position
    kinect.enableSkeleton3DMap(true);
  
    kinect.init();
 }
  
void drawKinect() {
    background(0);

  image(kinect.getColorImage(), 0, 0, 320, 240);

  //translate the scene to the center 
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(zVal);
  rotateX(rotX);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight],1);
      drawHandState(joints[KinectPV2.JointType_HandLeft],0);

      //Draw body
      color col  = skeleton.getIndexColor();
      stroke(col);
      drawBody(joints);
    }
  }
  popMatrix();


  fill(255, 0, 0);
  text(frameRate, 50, 50);
  }
  
  void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);

  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm    
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  strokeWeight(2.0f + joints[jointType].getZ()*8);
  point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
}

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  strokeWeight(2.0f + joints[jointType1].getZ()*8);
  point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

void drawHandState(KJoint joint,int findState) {
  handState(joint.getState());
  strokeWeight(5.0f + joint.getZ()*8);
  point(joint.getX(), joint.getY(), joint.getZ());
  if(findState==1){
    //print("\n(x,y,z) =  " + joint.getX() + "," + joint.getY() + "," + joint.getZ());
    currentPos.x = joint.getX();
    currentPos.y = joint.getY();
    currentPos.z = joint.getZ();
  }
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    stroke(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    stroke(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    stroke(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    stroke(100, 100, 100);
    break;
  }
}

  
 /*=========================*
  * Sound Interface
  *=========================*/

  void updateSoundState() {
    // if(soundPoints.size() == 0) {
    //     return;
    // }

    for (ArrayList<SoundPoint> points : strokes) {
      //Find the point with the min dist in the stroke and play
      playClosestPoint(points);
    }
  }

  void playClosestPoint(ArrayList<SoundPoint> points) {
      float minDist = Integer.MAX_VALUE;
      SoundPoint point = null;

      for(SoundPoint sp : points) {
        float dist = currentPos.dist(sp.position);
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
  
  /**
  * Conversion function from ADC reading to frequecy
  *
  */
  int analogReadingToFrequency(int reading) {
     return int(map(reading, 0, 1024, 200,1500)); 
  }

  /*=========================*
   * Paint Interface
   *=========================*/
   /* UNCOMMENT WHEN YOU WANT TO ADD PAINT
   void createPaint() {
     // Now if the button is pressed, paint
     if (buttonPressed)
     {
       smooth();
       noStroke();
       fill(colors[strokeIndex % NUM_COLORS]);
       ellipseMode(CENTER);
       ellipse(currentPos.x,currentPos.y,20,20); //May need to fix window size to support position
     }
  }
  */


  