#include <Adafruit_NeoPixel.h>

#define PIN            6

#define NUMPIXELS      16

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);


char xval; // Data received from the serial port
char yval;
char zval;

void setup() {
   
   pixels.begin();
   Serial.begin(9600); // Start serial communication at 9600 bps

}

void loop() {
   
   if (Serial.available()) 
   { // If data is available to read,
       xval = Serial.read(); // read x and store it in val
   }
   if(Serial.available()){
       yval = Serial.read();
   }
   if(Serial.available()){
       zval = Serial.read();
   }

   pixels.setPixelColor(0, pixels.Color(int(xval),int(yval), int(zval))); 
   pixels.show();
   delay(10); // Wait 10 milliseconds for next reading
}
