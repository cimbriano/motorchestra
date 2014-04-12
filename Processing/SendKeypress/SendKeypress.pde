// Example by Tom Igoe

import processing.serial.*;

// The serial port:
Serial myPort;

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
  myPort.write(key + "," + key + '\n');
  println(key + "," + key);
}
