//// import the fingertracker library
//// and the SimpleOpenNI library for Kinect access
import fingertracker.*;
import SimpleOpenNI.*;
import processing.serial.*;

Serial myPortLeft;
Serial myPortRight;

//// declare FignerTracker and SimpleOpenNI objects
FingerTracker fingers;
SimpleOpenNI kinect;
//
//// set a default threshold distance:
//// 625 corresponds to about 2-3 feet from the Kinect
int threshold = 625;
PVector[] topFingers;
//
int width = 640;
int height = 480;
//
int counter = 0;
int currentSpeedLeft = -1;
int currentSpeedRight = -1;

int[] notes = {0, 120, 150, 214, 272, 300, 428, 500, 601, 1501};
void setup() {
  myPortLeft = new Serial(this, "/dev/tty.usbmodemfd12241", 115200);
  myPortRight = new Serial(this, "/dev/tty.usbmodemfd12221", 115200);
//
  size(width, height);
//
//
//
//  // initialize your SimpleOpenNI object
//  // and set it up to access the depth image
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // mirror the depth image so that it is more natural
  kinect.setMirror(true);

  // initialize the FingerTracker object
  // with the height and width of the Kinect
  // depth image
  fingers = new FingerTracker(this, width, height);
  // the "melt factor" smooths out the contour
  // making the finger tracking more robust
  // especially at short distances
  // farther away you may want a lower number
  fingers.setMeltFactor(100);

  // Initialize the topFingers Array
  topFingers = new PVector[2];
  topFingers[0] = new PVector();
  topFingers[1] = new PVector();
}
//
void draw() {
  // get new depth data from the kinect
  kinect.update();
  // get a depth image and display it
  PImage depthImage = kinect.depthImage();
  image(depthImage, 0, 0);

  // update the depth threshold beyond which
  // we'll look for fingers
  fingers.setThreshold(threshold);

  // access the "depth map" from the Kinect
  // this is an array of ints with the full-resolution
  // depth data (i.e. 500-2047 instead of 0-255)
  // pass that data to our FingerTracker
  int[] depthMap = kinect.depthMap();
  fingers.update(depthMap);

  // iterate over all the contours found
  // and display each of them with a green line
  stroke(0, 255, 0);
  for (int k = 0; k < fingers.getNumContours(); k++) {
    fingers.drawContour(k);
  }

  // iterate over all the fingers found
  // and draw them as a red circle
  noStroke();
  fill(255, 0, 0);
  for (int i = 0; i < fingers.getNumFingers(); i++) {
    PVector position = fingers.getFinger(i);

    ellipse(position.x - 5, position.y -5, 10, 10);
  }
//
  getTopFingers(fingers);
  writeThereminValues(counter);
  counter++;
  //delay(250);
  


  // show the threshold on the screen
  fill(255, 0, 0);
  text(threshold, 10, 20);
}

// keyPressed event:
// pressing the '-' key lowers the threshold by 10
// pressing the '+/=' key increases it by 10 
void keyPressed() {
  int keyInt = key - '0';  
//  println("Key:" + key + ", keyInt: " + keyInt, );
  
  if (key == '-') {
//    threshold -= 10;
  }
  else if (key == '=') {
//    threshold += 10;
  }
  else {
    
    if(currentSpeedLeft != keyInt || currentSpeedRight != keyInt) {
      myPortLeft.write(keyInt + "," + keyInt + '\n');
      print(keyInt + "," + keyInt + '\n');
      
      currentSpeedLeft = keyInt;
      currentSpeedRight = keyInt;
    } else {
      println("Speed still: " + currentSpeedLeft + ". Not sending to Serial.");
    }
    
    
  }
}
//
void writeThereminValues(int counter) {

  int L =  (topFingers[0].y == 9999) ? 0 : int(map(topFingers[0].y, 0, height, 10, 1));
  println("Left top finger: " + L);
  int R =  (topFingers[1].y == 9999) ? 0 : int(map(topFingers[1].y, 0, height, 10, 1));
  println("Right top finger: " + R);
  
  if(currentSpeedLeft != L) {
    myPortLeft.write(notes[L] + "\n");
    print("L : " + notes[L] + "\n");
    
    currentSpeedLeft = L;
  }
  
  if(currentSpeedRight != R){
    myPortRight.write(R + "\n");
    print("R: " + R + "\n");
    
    currentSpeedRight = R;
  }
  
}

//
void getTopFingers(FingerTracker fingers) {
  // Note:  "Top" in the image is the lowest y value.

  // Reset Left Finger
  topFingers[0].set(0, 9999);

  //Reset Right FInger
  topFingers[1].set(0, 9999);

  // Loop through this frame's fingeres
  for (int i = 0; i < fingers.getNumFingers(); i++) {
    PVector finger = fingers.getFinger(i);

    // Check if this is in the left or right of the image
    if (finger.x < (width / 2)) { // Left

      if (finger.y < topFingers[0].y) {
        topFingers[0] = finger;
      }
    } 
    else { //Right
      if (finger.y < topFingers[1].y) {
        topFingers[1] = finger;
      }
    }
  }
}

