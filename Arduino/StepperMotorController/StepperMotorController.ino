#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); // Object for the motor shield
Adafruit_StepperMotor *leftMotor = AFMS.getStepper(200, 1); // Connect motor with 200 steps/rev on port #1

int speeds[2];

// Variables for Serial string parsing
String in;
int commaIndex= -1;
char charBuffer[5];

int L = 0; // speed of left motor
int R = 0; // speed of right motor


// Pins
int LED = 9;
int rightMotor = 11;


void setup() {
  Serial.begin(115200);

  pinMode(LED, OUTPUT);
  pinMode(rightMotor, OUTPUT);

  AFMS.begin();

  speeds[0] = 80;
  speeds[1] = 120;


  analogWrite(rightMotor, speeds[1]);
  leftMotor->setSpeed(speeds[0]);

  analogWrite(LED, 0);
}

void loop() {
  setSpeeds();

  // set motor speeds
  analogWrite(rightMotor, speeds[1]);
  leftMotor->setSpeed(speeds[0]);
  if(speeds[0] > 0) {
    leftMotor->step(1, FORWARD, DOUBLE);  
  }
}

void setSpeeds() {
  if(Serial.available() > 0){

    in = Serial.readStringUntil('\n');
    commaIndex = in.indexOf(',');

    in.substring(0, commaIndex).toCharArray(charBuffer, 5);
    L = atoi(charBuffer);

    in.substring(commaIndex + 1).toCharArray(charBuffer, 5);
    R = atoi(charBuffer);

    speeds[0] = L;
    speeds[1] = R; 

    analogWrite(LED, map(speeds[0], 0, 2000, 0, 255));
  }
}

