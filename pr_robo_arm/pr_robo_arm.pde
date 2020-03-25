/* ============================================
  pr_robot_arm arduino and processing code is placed under the MIT license
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

import processing.serial.*;

// Serial object
Serial myport;

// ChildApplet object
ChildApplet child;

float cx1, cy1, cx2, cy2, cx3, cy3, cx4, cy4;
float arc_width, arc_height;

String mystring;

int x = 100;
int y = 200;
int z = 100;

// 'Get_value' object
Get_value g1, g2, g3, g4;

void settings() {
  size(800, 800);
}

void setup()
{
  // initialize ChildApplet
  child = new ChildApplet();
  textSize(30);
  textAlign(CENTER);
  // connecting Serial port
  myport=new Serial(this, Serial.list()[0], 9600);


  //set location for arc1, arc2, arc3, arc4
  cx1 = width/4;
  cy1 = height/3;
  cx2 = width/4*3;
  cy2 = height/3;
  cx3 = width/4;
  cy3 = height/4*3;
  cx4 = width/4*3;
  cy4 = height/4*3;

  // set width and height of arc
  arc_width = width/3;
  arc_height = width/3;

  // set get value object
  g1 = new Get_value(cx1, cy1);
  g2 = new Get_value(cx2, cy2);
  g3 = new Get_value(cx3, cy3);
  g4 = new Get_value(cx4, cy4);
}

void draw()
{
  drawBackground();
  delay(50);
}

void mouseDragged()
{
  // Checking if the mouse point is in an area of the arc
  if (mouseY < cy1 && dist(mouseX, mouseY, cx1, cy1) < (arc_width/2))
  {
    g1.get_rad_deg();
    mystring = "s1," + String.valueOf(g1.deg)+"e"; // Set the data to Arduino (protocall form : "s(id of motor),(degree),e")
    myport.write(mystring);  // send the data to Arduino
  } else if (mouseY < cy2 && dist(mouseX, mouseY, cx2, cy2) < (arc_width/2))
  {
    g2.get_rad_deg();
    mystring = "s2," + String.valueOf(g2.deg)+"e";
    myport.write(mystring);
  } else if (mouseY < cy3 && dist(mouseX, mouseY, cx3, cy3) < (arc_width/2))
  {
    g3.get_rad_deg();
    mystring = "s3," + String.valueOf(g3.deg)+"e";
    myport.write(mystring);
  } else if (mouseY < cy4 && dist(mouseX, mouseY, cx4, cy4) < (arc_width/2))
  {
    g4.get_rad_deg();
    mystring = "s4," + String.valueOf(g4.deg)+"e";
    if(g4.deg > 50)
    {
      mystring = "s4,50e";
    }
    
    myport.write(mystring);
  }
} 

// Define Get_value class
class Get_value
{
  float rad;
  int deg;
  float Gcx, Gcy;
  float a, b;
  Get_value(float cx, float cy)
  {
    Gcx = cx;
    Gcy = cy;
  }
  void get_rad_deg()
  {
    a = Gcy - mouseY;
    b = Gcx - mouseX;

    //get radian angle from center of the are to mouse point
    rad = atan(a/b);
    if (rad <= PI/2 && rad>0)
    {
      rad += PI;
    }

    //get degree angle
    if (rad<0)
    {
      deg = round(map(-rad, 0, PI, 0, 180));
    } else
    {
      deg = round(map(TWO_PI-rad, 0, PI, 0, 180));
    }
  }
}

// Define the function to draw arc
void draw_arc(float cx, float cy, float aw, float ah, float rad, int deg, String m_nb)
{
  fill(0);
  rect(cx-aw/2, cy-ah/2-80, aw, 70);
  fill(255);
  textSize(50);
  text(m_nb, cx, cy-ah/2-20);
  fill(0, 0, 255);
  arc(cx, cy, aw, ah, PI, TWO_PI, CHORD); //Draw the blue arc
  fill(255);
  if (rad<=0)  //Draw the white arc as the radian angle
  {
    arc(cx, cy, aw, ah, rad, 0, PIE);
  } else
  {
    arc(cx, cy, aw, ah, rad, TWO_PI, PIE);
  }
  fill(0);
  textSize(40);
  text(deg, cx, cy+40);
} 

void drawBackground()
{
  background(150);
  draw_arc(cx1, cy1, arc_width, arc_height, g1.rad, g1.deg, "MOTOR1");
  draw_arc(cx2, cy2, arc_width, arc_height, g2.rad, g2.deg, "MOTOR2");
  draw_arc(cx3, cy3, arc_width, arc_height, g3.rad, g3.deg, "MOTOR3");
  draw_arc(cx4, cy4, arc_width, arc_height, g4.rad, g4.deg, "MOTOR4");
}


// define ChildApplet class 
class ChildApplet extends PApplet {
  //JFrame frame;


  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(800, 800, P3D);
  }

  public void setup() {
    lights();
  }

  public void draw() {
    background(0); 
    lights(); 

    pushMatrix();

//draw first(ground) link
    fill(0, 255, 0); 
    translate(width/2, height-100, -100); 
    rotateY(-g1.rad-HALF_PI); // rotate first joint as motor1 angle
    box(x, y, z);

//draw second link
    fill(255, 0, 0); 
    translate(0, -y/2, 0);
    rotateX(-HALF_PI-g2.rad); // rotate second joint as motor2 angle
    translate(0, -y/2, 0);
    box(x, y, z);

// draw third link
    fill(0, 0, 255); 
    translate(0, -y/2, 0);
    rotateX(g3.rad+HALF_PI); // rotate third joint as motor3 angle
    translate(0, -y/2, 0);
    box(x, y, z);

    popMatrix();
  }
}
