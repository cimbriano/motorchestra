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
int commaIndex= -1;
char charBuffer[5];



int L = 0;
int R = 0;

int LED = 9;


void setup() {
  Serial.begin(115200);
  
  pinMode(LED, OUTPUT);
  
  AFMS.begin();
  
  speeds = new int[2];
  speeds[0] = 80;
  speeds[1] = 80;
  
  //TEMP
  leftMotor->setSpeed(speeds[0]);
  rightMotor->setSpeed(speeds[1]);
  //END TEMP
  
  analogWrite(LED, 0);
}

void loop() {
  
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

    
      in = Serial.readStringUntil('\n');
      commaIndex = in.indexOf(',');
      
      in.substring(0, commaIndex).toCharArray(charBuffer, 5);
      L = atoi(charBuffer);
      
      in.substring(commaIndex + 1).toCharArray(charBuffer, 5);
      R = atoi(charBuffer);
      
//      speeds[0] = (L == 0) ? 0 : MIN_SPEED + STEP_SIZE * (L - 1); // subtract 1 from value of L and R because speed 0 is off and
//      speeds[1] = (R == 0) ? 0 : MIN_SPEED + STEP_SIZE * (R - 1); // speed 1 is  MIN_SPEED

      speeds[0] = L; // subtract 1 from value of L and R because speed 0 is off and
      speeds[1] = R; // speed 1 is  MIN_SPEED
      
      analogWrite(LED, map(speeds[0], 0, 2000, 0, 255));
  }

}
