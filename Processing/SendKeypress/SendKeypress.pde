// Example by Tom Igoe

import processing.serial.*;

// The serial port:
Serial myPort;

String buffer = "";
int currentSpeed = 0;

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
     myPort.write(buffer + "," + buffer + '\n');
     print(buffer + "," + buffer + '\n');
     
    // Clear the buffer
    currentSpeed = Integer.parseInt(buffer);
    buffer = "";
    
  } else if(key == CODED) {
    if(keyCode == UP) {
      currentSpeed += 10;
    } else if(keyCode == DOWN) {
      currentSpeed -= 10;
    } else if(keyCode == LEFT) {
      currentSpeed += 1;
    } else if(keyCode == RIGHT){
      currentSpeed -= 1;
    }
    
     myPort.write(currentSpeed + "," + currentSpeed + '\n');
     print(currentSpeed + "," + currentSpeed + '\n');
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
