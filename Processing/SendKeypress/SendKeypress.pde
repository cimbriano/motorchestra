// Example by Tom Igoe

import processing.serial.*;

// The serial port:
Serial myPort;

String buffer = "";
int currentSpeedLeft = -1;
int currentSpeedRight = -1;
int commaIndex = -1;

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, "/dev/tty.usbmodemfa131", 115200);
}


void draw() {
  fill(0);
  rect(25, 25, 50, 50);
}

void keyPressed() {
  int keyInt = key;
  
  if(keyInt == 10) {
    // Send something to 
     myPort.write(buffer + '\n');
     print(buffer + '\n');
     
    // Parse speeds and clear the buffer
    commaIndex = buffer.indexOf(",");
    currentSpeedLeft = Integer.parseInt(buffer.substring(0, commaIndex));
    currentSpeedRight = Integer.parseInt(buffer.substring(commaIndex+1));
    buffer = "";
    
  } else if(key == CODED) {
    if(keyCode == UP) {
      currentSpeedLeft += 10;
      currentSpeedRight += 10;
    } else if(keyCode == DOWN) {
      currentSpeedLeft -= 10;
      currentSpeedRight -= 10;
    } else if(keyCode == RIGHT) {
      currentSpeedLeft += 1;
      currentSpeedRight += 1;
    } else if(keyCode == LEFT){
      currentSpeedLeft -= 1;
      currentSpeedRight -= 1;
    }
    
     myPort.write(currentSpeedLeft + "," + currentSpeedRight + '\n');
     print(currentSpeedLeft + "," + currentSpeedRight + '\n');
  } else if(key == '\\') { // ESC
    // Clear the buffer
    buffer = "";
    println("Buffer :" + buffer);
    
  } else {
    //Store this character in the buffer
    buffer += key;
    println("Buffer :" + buffer);
  }
  
  
 
}
