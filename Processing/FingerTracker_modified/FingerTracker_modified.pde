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
int threshold = 745;
PVector[] topFingers;
//
int width = 640;
int height = 480;
//
int counter = 0;
int currentSpeedLeft = -1;
int currentSpeedRight = -1;

String[] noteNames = {"OFF", "C#", "D#", "F", "F#", "G", "G#", "A#", "B", "C"};
int[] notes = {
  0, 92, 118, 163, 197, 225, 273, 685, 1055, 3010
};

PFont notesFont;
void setup() {
   println(Serial.list());
  
  myPortLeft = new Serial(this, "/dev/tty.usbmodemfd12241", 115200);
  myPortRight = new Serial(this, "/dev/tty.usbmodemfd12221", 115200);
  //
  size(width, height);

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
  notesFont = createFont("Courier New", 50, false);
}
//
void draw() {
  // get new depth data from the kinect
  kinect.update();
  // get a depth image and display it
  PImage depthImage = kinect.depthImage();
  image(depthImage, 0, 0);
  tint(255, 225, 0);

  // update the depth threshold beyond which
  // we'll look for fingers
  fingers.setThreshold(threshold);

  // access the "depth map" from the Kinect
  // this is an array of ints with the full-resolution
  // depth data (i.e. 500-2047 instead of 0-255)
  // pass that data to our FingerTracker
  int[] depthMap = kinect.depthMap();
  fingers.update(depthMap);

  drawGridLines();

  // iterate over all the contours found
  // and display each of them with a green line
  stroke(0, 255, 0);
  for (int k = 0; k < fingers.getNumContours(); k++) {
    fingers.drawContour(k);
  }

  // Get the topFingers
  getTopFingers(fingers);

  getCurrentSpeeds();

  // iterate over the top fingers on each side
  // and draw them as a red circle
  writeThereminValues();

  // Acutate the "Pressed" boxes ( or put a circle in the center of the box)
  drawPressedBoxes();
  //delay(250);

  // show the threshold value on the screen
  //fill(255, 0, 0);
  //text(threshold, 10, 20);
  
  drawNotes();
}

void drawPressedBoxes() {

  // Draws tracked fingers
  noStroke();
  fill(255, 0, 0);
  for (int i = 0; i < topFingers.length; i++) {
    PVector position = topFingers[i];
    ellipse(position.x - 5, position.y -5, 10, 10);
  }

  // Highlight the box
  noStroke();
  fill(200, 200, 200, 80.0);
  // Left side highlighting
  rect(0, (height / 9) * (9 - currentSpeedLeft), width / 2, height / 9);

  //Right side highlighting
  rect(width / 2, (height / 9) * (9 - currentSpeedRight), width / 2, height / 9);
}

void drawGridLines() {
  // Set color of grid lines
  strokeWeight(1);
  stroke(255, 255, 255, 127.0);
  for (int line_height = 0; line_height < height; line_height += height / 9 ) {
    line(0, line_height, width, line_height);
  }

  line(width / 2, 0, width / 2, height);
}

void drawNotes() {
  textFont(notesFont);
  fill(255, 255, 255, 153);
  for (int i = 1; i < noteNames.length; i++) {
    text(noteNames[i], 4, (10-i)*height/9-10);
    text(i, width-45, (10-i)*height/9-10);
  }
}

// keyPressed event:
// pressing the '-' key lowers the threshold by 10
// pressing the '+/=' key increases it by 10 
void keyPressed() {
  int keyInt = key - '0';  
  //  println("Key:" + key + ", keyInt: " + keyInt, );

  if (key == '-') {
    threshold -= 10;
  }
  else if (key == '=') {
    threshold += 10;
  }
  else {

    if (currentSpeedLeft != keyInt || currentSpeedRight != keyInt) {
      myPortLeft.write(keyInt + "," + keyInt + '\n');
      print(keyInt + "," + keyInt + '\n');

      currentSpeedLeft = keyInt;
      currentSpeedRight = keyInt;
    } 
    else {
      println("Speed still: " + currentSpeedLeft + ". Not sending to Serial.");
    }
  }
}

void getCurrentSpeeds() {
}
//
void writeThereminValues() {

  int L =  (topFingers[0].y == 9999) ? 0 : int(map(topFingers[0].y, 0, height, 10, 1));
  //  println("L: " + L);
  int R =  (topFingers[1].y == 9999) ? 0 : int(map(topFingers[1].y, 0, height, 10, 1));
  //  println("R: " + R);

  if (currentSpeedLeft != L) {
    
    // Regular mode
    myPortLeft.write(notes[L] + "\n");
    
    // Rhythm mode
//    myPortLeft.write(L + "\n");
    
    
    //    print("L : " + notes[L] + "\n");

    currentSpeedLeft = L;
    println("L: " + L);
  }

  if (currentSpeedRight != R) {
    myPortRight.write(R + "\n");
    //    print("R: " + R + "\n");
    println("R: " + R);

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

