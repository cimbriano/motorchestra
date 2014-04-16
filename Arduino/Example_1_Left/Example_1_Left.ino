#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); // Object for the motor shield
Adafruit_StepperMotor *motor = AFMS.getStepper(200, 2); // Connect motor with 200 steps/rev on port #1

String in;
int rpm = 0;
char charBuffer[5];

// Spinning Parameters
const int NUM_MOTOR_STEPS = 10;
const int STEP_INCREMENT = 2;
const int DEFAULT_SPEED = 2;

void setup() {
  Serial.begin(115200);
  AFMS.begin();
  
  rpm = DEFAULT_SPEED;
  motor->setSpeed(rpm);
}

void loop() {
  setRpm();

  // set motor speeds
  motor->setSpeed(rpm);
  if(rpm > 0) {
    for(int i = 0; i < NUM_MOTOR_STEPS; i += STEP_INCREMENT) {
      motor->step(STEP_INCREMENT, FORWARD, DOUBLE);  
    }
  }
}

void setRpm() {
  if(Serial.available() > 0){

    in = Serial.readStringUntil('\n');
    in.trim();
    
    in.toCharArray(charBuffer, 5);
    rpm = atoi(charBuffer);
  }
}

