// Example by Tom Igoe

import processing.serial.*;

// The serial port:
Serial myPortLeft;
Serial myPortRight;

String buffer = "";
int currentSpeedLeft = -1;
int currentSpeedRight = -1;
int commaIndex = -1;

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  myPortLeft = new Serial(this, "/dev/tty.usbmodemfd12241", 115200);
  myPortRight = new Serial(this, "/dev/tty.usbmodemfd12221", 115200);
}


void draw() {
  fill(0);
  rect(25, 25, 50, 50);
}

void keyPressed() {
  int keyInt = key;

  if (keyInt == 10) {
    // Parse speeds and clear the buffer
    commaIndex = buffer.indexOf(",");
    currentSpeedLeft = Integer.parseInt(buffer.substring(0, commaIndex));
    currentSpeedRight = Integer.parseInt(buffer.substring(commaIndex+1));

    myPortLeft.write(currentSpeedLeft + "\n");
    myPortRight.write(currentSpeedRight + "\n");
    
    print(buffer + '\n');
    
    buffer = "";
  } 
  else if (key == CODED) {
    if (keyCode == UP) {
      currentSpeedLeft += 10;
      currentSpeedRight += 10;
    } 
    else if (keyCode == DOWN) {
      currentSpeedLeft -= 10;
      currentSpeedRight -= 10;
    } 
    else if (keyCode == RIGHT) {
      currentSpeedLeft += 1;
      currentSpeedRight += 1;
    } 
    else if (keyCode == LEFT) {
      currentSpeedLeft -= 1;
      currentSpeedRight -= 1;
    }

    myPortLeft.write(currentSpeedLeft + "\n");
    myPortRight.write(currentSpeedRight + "\n");

    print(currentSpeedLeft + "," + currentSpeedRight + '\n');
  } 
  else if (key == '\\') { // ESC
    // Clear the buffer
    buffer = "";
    println("Buffer :" + buffer);
  } 
  else {
    //Store this character in the buffer
    buffer += key;
    println("Buffer :" + buffer);
  }
}

