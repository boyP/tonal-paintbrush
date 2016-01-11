/**
 * TONAL PAINTBRUSH PROJECT CODE:
 * Authors:  Pratik Prakash
             Ameya Kamat
             Mark McElwaine
             Mark Fernandez
 */
 
 //Constants
 boolean isButtonOn;
 
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
 void setup() {
   isButtonOn = false;
 }
 
 void draw() {
   pollWebServer();
 }
 
 /*=========================*
  * Web Server Polling
  *=========================*/
  void pollWebServer() {
    print("Hello World");
    return;
  }
  
 /*=========================*
  * Kinect Interface
  *=========================*/
  
 /*=========================*
  * Max Interface
  *=========================*/
  
  