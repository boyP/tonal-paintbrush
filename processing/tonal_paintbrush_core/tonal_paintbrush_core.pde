/**
 * TONAL PAINTBRUSH PROJECT CODE:
 * Authors:  Pratik Prakash
             Ameya Kamat
             Mark McElwaine
             Mark Fernandez
 */
 
 //Dependencies
 import org.openkinect.freenect.*;
 import org.openkinect.processing.*;
 import java.net.*;
 import java.io.*;
 
 //Constants
 String SERVER_URL = "";
 
 //Fields
 boolean isButtonOn;
 boolean currentASV;
 boolean currentStrokeID;
 Kinect kinect;
 
 /**
  * SoundPoint is a class representing one of the several instances of a brush stroke
  * x:                The x position in 3-D space
  * y:                The y position in 3-D space
  * z:                The z position in 3-D space
  * strokeID:         The stroke to which the SoundPoint belongs
  * analogSoundValue: The value of the sound played
  */
 class SoundPoint {
   float x;
   float y;
   float z;
   int strokeID;
   float analogSoundValue;
   
   SoundPoint(float x, float y, float z, int strokeID, float analogValue) {
     this.x = x;
     this.y = y;
     this.z = z;
     this.strokeID = strokeID;
     this.analogSoundValue = analogValue;
   }
 }


 public class MarkObj {
    public boolean buttonState;
    public double analogValue;
 }

 void setup() {
   size(640, 520);
   isButtonOn = false;
   currentStrokeID = 0;
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
      SoundPoint point = new SoundPoint(pos.x, pos.y, pos.z, currentStrokeID, currentASV);
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
  * Max Interface
  *=========================*/

  /**
   * Sends the point to MAX via OSC, returns true if successful. 
   */
  boolean sendPoint(SoundPoint point) {
    return true;
  }

  void sendCurrentPosition() {

  }


  