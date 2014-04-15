#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); // Object for the motor shield
Adafruit_StepperMotor *rightMotor = AFMS.getStepper(200, 2); // Connect motor with 200 steps/rev on port #1

const int NUM_MOTOR_STEPS = 4;
const int STEP_INCREMENT = 2;

// Pins
int speedIn = 1;

int R;

void setup() {
  Serial.begin(9600);
  AFMS.begin();
  
  R = 80;
  
  rightMotor->setSpeed(R);
}

void loop() {
  R = analogRead(speedIn);
  Serial.println(R);

  // set motor speed
//  rightMotor->setSpeed(R);
  
  // run motor
  if(R > 0) {
    rightMotor->onestep(BACKWARD, DOUBLE);  
  }
}
