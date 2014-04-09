/* 
 This is a test sketch for the Adafruit assembled Motor Shield for Arduino v2
 It won't work with v1.x motor shields! Only for the v2's with built in PWM
 control
 
 For use with the Adafruit Motor Shield v2 
 ---->	http://www.adafruit.com/products/1438
 */

#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61); 

// Select which 'port' M1, M2, M3 or M4. In this case, M1
Adafruit_DCMotor *myMotor = AFMS.getMotor(1);
// You can also make another motor on port M2
//Adafruit_DCMotor *myOtherMotor = AFMS.getMotor(2);

//boolean running = false;
void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  //Serial.println("Adafruit Motorshield v2 - DC Motor test!");

  AFMS.begin();  // create with the default frequency 1.6KHz
  //AFMS.begin(1000);  // OR with a different frequency, say 1KHz

  // Set the speed to start, from 0 (off) to 255 (max speed)
  myMotor->setSpeed(255);
  myMotor->run(FORWARD);
  // turn on motor
  myMotor->run(RELEASE);
}


void loop() {
  char rec = Serial.read();
  //Serial.println("Arduino recieved: " + rec);
  if (rec == '9') {
    myMotor->setSpeed(240);
    myMotor->run(FORWARD);
  }
  else if (rec == '8') {
    myMotor->setSpeed(210);
    myMotor->run(FORWARD);
  }
  else if (rec == '7') {
    myMotor->setSpeed(180);
    myMotor->run(FORWARD);
  }
  else if (rec == '6') {
    myMotor->setSpeed(150);
    myMotor->run(FORWARD);
  }
  else if (rec == '5') {
    myMotor->setSpeed(120);
    myMotor->run(FORWARD);
  }
  else if (rec == '4') {
    myMotor->setSpeed(90);
    myMotor->run(FORWARD);
  }
  else if (rec == '3') {
    myMotor->setSpeed(60);
    myMotor->run(FORWARD);
  }
  else if (rec == '2') {
    myMotor->setSpeed(30);
    myMotor->run(FORWARD);
  }
  else if (rec == '1') {
    myMotor->run(RELEASE);
  }
}
