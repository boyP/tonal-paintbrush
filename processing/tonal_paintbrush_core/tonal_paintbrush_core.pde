/**
 * TONAL PAINTBRUSH PROJECT CODE:
 * Authors:  Pratik Prakash
             Ameya Kamat
             Mark McElwaine
             Mark Fernandez

             Paint program
             https://processing.org/discourse/beta/num_1165920458.html
 */
 
 //Dependencies
 import java.net.*;
 import java.io.*;
 
 import ddf.minim.*;
 import ddf.minim.analysis.*;
 import ddf.minim.effects.*;
 import ddf.minim.signals.*;
 import ddf.minim.spi.*;
 import ddf.minim.ugens.*;

 import java.util.ArrayList;

 //Constants
 String SERVER_URL = "";
 
 //Fields
 boolean isButtonOn;
 int currentASV;
 int currentStrokeID;
 PVector currentPos;

 ArrayList<SoundPoint> soundPoints;

 
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
   int strokeID;
   float analogSoundValue;
   
   SoundPoint(PVector position, int strokeID, float analogValue) {
     this.position = position;
     this.strokeID = strokeID;
     this.analogSoundValue = analogValue;
   }
 }


 public class MarkObj {
    public boolean buttonState;
    public int analogValue;
 }

 void setup() {
   size(640, 520);
   isButtonOn = false;
   currentStrokeID = 0;
   PVector currentPos = new PVector(0,0,0);

   soundPoints = new ArrayList<SoundPoint>();

   //Kinect Setup
   setupKinect();
 }
 
 void draw() {

  //First poll webserver for button state changes
  currState = pollWebServer();

  //Check whether the button changed from ON to OFF or vice versa
  if(currState != isButtonOn) {
      if(isButtonOn) {
        //On -> Off
        currentStrokeID++;
      }
      else {
        //Off -> On
      }
  }
  else {
    if(isButtonOn) {
      //On => Create soundPoints
      PVector pos = getPositionVector();
      SoundPoint point = new SoundPoint(pos, currentStrokeID, currentASV);
      if(sendPoint(point)) {
        print('Point sent with strokeID: ' + point.strokeID);
      }
    }
  }

   drawKinect();
  }
 }
 
 /*=========================*
  * Web Server Polling
  *=========================*/
  boolean pollWebServer() {

    //First connect to the web server
    //Get the JSON object from the web server
    //Parse the JSON into buttonState and analogValue
    //Update button state and return analogValue
    boolean buttonState = false;
    try {
      MarkObj data = getInfo();
      buttonState = data.buttonState;
      currentASV = data.analogValue;
    }
    catch(Exception e) {
      print("Problem with web server polling")
    }

    return buttonState;
  }

  MarkObj getInfo()throws MalformedURLException, IOException{
    InputStream input = new URL(SERVER_URL).openStream();
    Reader reader = new InputStreamReader(input, "UTF-8");
    MarkObj data = (MarkObj) new Gson().fromJson(reader,MarkObj.class);
    return data;
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

  /**
   * Go through the list of sounds and play the sounds
   */
  void playSounds(List<SoundPoint> soundPoints) {
    for (point : soundPoints) {
      int sound = point.analogSoundValue * calculateRatio(currentPos, point.position);
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




  