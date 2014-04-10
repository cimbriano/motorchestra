#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); // Object for the motor shield
Adafruit_StepperMotor *leftMotor = AFMS.getStepper(200, 1); // Connect motor with 200 steps/rev on port #1
Adafruit_StepperMotor *rightMotor = AFMS.getStepper(513, 2); // Connect motor with 513 steps/rev on port #2

const int MIN_SPEED = 60;
const int STEP_SIZE = 20;

void setup() {
  Serial.begin(9600);
  
  AFMS.begin();
  
  //TEMP
  leftMotor->setSpeed(10);
  rightMotor->setSpeed(10);
  //END TEMP
}

void loop() {
  int* speeds = getSpeeds();
  
  // set motor speeds
  //rightMotor->setSpeed(speeds[0]);
  //leftMotor->setSpeed(speeds[1]);
  
  // run the motors
  //if (speeds[0] > MIN_SPEED - STEP_SIZE) {
    rightMotor->step(200, FORWARD, DOUBLE);
  //}
  delay(1000);
  //if (speeds[1] > MIN_SPEED - STEP_SIZE) {
    leftMotor->step(200, FORWARD, DOUBLE);
    delay(1000);
  //}
}

int* getSpeeds() {
  String in = Serial.readStringUntil('\n');
  int speedArray[2];
  
  // parse input string from format L,R where L and R are speeds between 0-9
  int L = in.charAt(0) - '0';
  int R = in.charAt(2) - '0';
  
  speedArray[0] = MIN_SPEED + STEP_SIZE * (L - 1); // subtract 1 from value of L and R because speed 0 is off and
  speedArray[1] = MIN_SPEED + STEP_SIZE * (R - 1); // speed 1 is  MIN_SPEED
  
  return speedArray;
}
