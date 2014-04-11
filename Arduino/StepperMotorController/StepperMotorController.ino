#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); // Object for the motor shield
Adafruit_StepperMotor *leftMotor = AFMS.getStepper(200, 1); // Connect motor with 200 steps/rev on port #1
Adafruit_StepperMotor *rightMotor = AFMS.getStepper(513, 2); // Connect motor with 513 steps/rev on port #2

const int MIN_SPEED = 60;
const int STEP_SIZE = 20;
const int NUM_MOTOR_STEPS = 4;
const int STEP_INCREMENT = 2;

int* speeds;

String in;


int L = 0;
int R = 0;

int LED = 13;


void setup() {
  Serial.begin(9600);
  
  pinMode(LED, OUTPUT);
  
  AFMS.begin();
  
  speeds = new int[2];
  speeds[0] = 80;
  speeds[1] = 80;
  
  //TEMP
  leftMotor->setSpeed(speeds[0]);
  rightMotor->setSpeed(speeds[1]);
  //END TEMP
}

void loop() {
  digitalWrite(LED, LOW);
  
  setSpeeds();
  
  // set motor speeds
  rightMotor->setSpeed(speeds[0]);
  leftMotor->setSpeed(speeds[1]);
  
  // run the motors
  for(int i = 0; i < NUM_MOTOR_STEPS; i = i + STEP_INCREMENT){
    if(speeds[0] > 0) {
      leftMotor->step(STEP_INCREMENT, FORWARD, DOUBLE);  
    }
    
    if(speeds[1] > 0) {
      rightMotor->step(STEP_INCREMENT, FORWARD, DOUBLE);      
    }

  }
  
  
  //if (speeds[0] > MIN_SPEED - STEP_SIZE) {
//    rightMotor->step(200, FORWARD, DOUBLE);
  //}
//  delay(1000);
  //if (speeds[1] > MIN_SPEED - STEP_SIZE) {
//    leftMotor->step(200, FORWARD, DOUBLE);
//    delay(1000);
  //}
}

void setSpeeds() {
  if(Serial.available() > 0){
    
    digitalWrite(LED, HIGH);
    
    in = Serial.readStringUntil('\n');
//    L = Serial.read() - '0';
//    R = Serial.read() - '0';
    
    digitalWrite(LED, LOW);
    // parse input string from format L,R where L and R are speeds between 0-9
    L = in.charAt(0) - '0';
    R = in.charAt(2) - '0';
  
    speeds[0] = (L == 0) ? 0 : MIN_SPEED + STEP_SIZE * (L - 1); // subtract 1 from value of L and R because speed 0 is off and
    speeds[1] = (R == 0) ? 0 : MIN_SPEED + STEP_SIZE * (R - 1); // speed 1 is  MIN_SPEED
  }
}
