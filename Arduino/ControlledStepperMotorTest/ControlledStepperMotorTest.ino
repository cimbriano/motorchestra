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

// Connect a stepper motor with 200 steps per revolution (1.8 degree)
// to motor port #2 (M3 and M4)
Adafruit_StepperMotor *myMotor = AFMS.getStepper(513, 2);

int speed = 100;
boolean goForward = true;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
//  Serial.println("Stepper test!");

  AFMS.begin();  // create with the default frequency 1.6KHz
//  AFMS.begin(5000);  // OR with a different frequency, say 1KHz
  
  myMotor->setSpeed(speed);
}

void loop() {
  getSpeed();
  
  myMotor->setSpeed(speed);  // 10 rpm  
  if(goForward){
    myMotor->step(513, FORWARD, DOUBLE);
  }else {
    myMotor->step(513, BACKWARD, DOUBLE);
  }

}

void getSpeed() {
  
  if(Serial.available() > 0 ){
    char rec = Serial.read();
    
    if (rec == 'q') {
      speed = speed + 50;
      goForward = !goForward;
    }
    else if (rec == 'a') {
      speed = speed - 10;
    } else if (rec == 'w'){
      speed = speed + 1;
    } else if (rec == 's') {
      speed = speed - 1;
    } 
    

  }
  
}
