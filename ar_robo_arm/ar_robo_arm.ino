/* ============================================
  Educational_robot_arm arduino and processing code is placed under the MIT license
  Copyright (c) 2020 kimkimsh

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  ===============================================
*/

#include <Servo.h>

String value; // Delcare String to get the data from Processing

int servo_pin1 = 3;
int servo_pin2 = 4;
int servo_pin3 = 5;
int servo_pin4 = 6;

unsigned long motor_nb = 7;
String s_deg; // Delcare String to get the degree from the data
unsigned long i_deg = 7;

Servo servo1, servo2, servo3, servo4;

void setup()
{
  Serial.begin(9600);
  servo1.attach(servo_pin1);
  servo2.attach(servo_pin2);
  servo3.attach(servo_pin3);
  servo4.attach(servo_pin4);

  servo1.write(90);
  servo2.write(90);
  servo3.write(90);
  servo4.write(50);
}

void loop() {

  if (Serial.available())
  {
    // get the data from Processing
    value = Serial.readStringUntil('e');
  }
  value.trim();
  motor_nb = value[1]; // get the motor ID from the data
  s_deg = value.substring(3, value.length()); //get the degree from the data
  i_deg = s_deg.toInt();  //Convert the degree value to integer

  switch (motor_nb)
  {
    case '1' :
      servo1.write(i_deg);
      break;
    case '2' :
      servo2.write(i_deg);
      break;
    case '3' :
      servo3.write(i_deg);
      break;
    case '4' :
      servo4.write(i_deg);
      break;
  }
}
