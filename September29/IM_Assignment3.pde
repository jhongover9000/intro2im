//Introduction to Interactive Media Assignment 2: Repeating Art
//Joseph Hong
//Description: This is a (somewhat interactive) piece of digital art that represents "chance". The initial phase is made
//             up of lines that appear on the screen only when the circles, hidden from sight, come into contact with one
//             another perfectly such that their edges meet up. The second is made of lines that appear whenever any
//             circles are in contact, no matter their location. The circles themselves bounce against the boundaries but
//             never come to a full stop, meaning that art is constantly created. Phases can be changed by clicking the mouse.
//======================================================================================================================================================
//======================================================================================================================================================
//Imports
import java.util.ArrayList;


//======================================================================================================================================================
//======================================================================================================================================================
//Global Variables

int screenWidth = 500;              //width and height of screen (can be controlled from this section instead of declaring
int screenHeight = 500;             //later on in the setup function)
int circleCount = 100;               //number of circles used in the program
float circleSize = 20;              //size of circles (radius)
String lineAppearance = "equal";    //or "lessOrEqual"; decides when the line will appear (when circles touch, only once vs constantly)


//======================================================================================================================================================
//======================================================================================================================================================
//Class Definition

//circle class
class Circle {
  float locX;
  float locY;
  float velX;
  float velY;
  float r;

  //constructor
  Circle(float locX, float locY, float velX, float velY, float r) {
    this.locX = locX;
    this.locY = locY;
    this.velX = velX;
    this.velY = velY;
    this.r = r;
  }

  //used for checking movement of circles (testing)
  //void display() {
  //  stroke(50);
  //  ellipse(locX, locY, 2*r, 2*r);
  //}

  //update velocity & location of circle when hitting boundaries of screen
  void update() {
    if (locX >= screenWidth || locX <= 0) {
      velX*=-1;
    } else if (locY >= screenHeight || locY <= 0) {
      velY*=-1;
    }
    locX = locX + velX;
    locY = locY + velY;
  }
}


//object list class (stores all objects on screen in an array)
class ObjectList {
  ArrayList<Circle> circles = new ArrayList<Circle>();
  float lineColor;

  //constructor
  ObjectList() {
    for (int i = 0; i<50; i++) {
      Circle circle = new Circle(random(0, screenWidth), random(0, screenHeight), random(-5, 5), random(-5, 5), circleSize);
      circles.add(circle);
    }
  }

  //getter
  ArrayList<Circle> getCircles() {
    return circles;
  }

  //update locations of circles and draws lines between them (center to center) if they touch
  void updateAndDisplay() {
    for (int i = 1; i < list.getCircles().size()-1; i++) {    //basically, iterate through the list and for each circle, check to see if
      Circle temp1 = list.getCircles().get(i);                //it's in contact with any other circle in the list other than itself
      for (int j = 1; j < list.getCircles().size()-1; j++) {
        if (i==j) {continue;}  //skip the object selected at the start of iteration
        else {  //this section uses pyth. theorem of a^2+b^2=c^2 in order to calculate if two circles are touching or are in one another
          Circle temp2 = list.getCircles().get(j);
          if (lineAppearance == "equal") {  //this is where lines appear once when the circles' *edges* touch
            if (int(temp1.locX - temp2.locX)*int(temp1.locX - temp2.locX) + int(temp1.locY - temp2.locY)* int(temp1.locY - temp2.locY) == 4*circleSize*circleSize ) {
              stroke(lineColor);
              line(temp1.locX, temp1.locY, temp2.locX, temp2.locY);
            }
          } else if (lineAppearance == "lessOrEqual") {  //this is where lines appear whenever the circles are in contact w/ each other
            if (int(temp1.locX - temp2.locX)*int(temp1.locX - temp2.locX) + int(temp1.locY - temp2.locY)* int(temp1.locY - temp2.locY) <= 4*circleSize*circleSize ) {
              stroke(lineColor);
              line(temp1.locX, temp1.locY, temp2.locX, temp2.locY);
            }
          }
        }
        temp1.update();    //update the velocities/locations of the circles
      }
    }

    ////display circles (for testing purposes)
    //void display() {
    //  for (Circle i : list.getCircles()) {
    //    i.display();
    //  }
    //}
  }
}


//======================================================================================================================================================
//======================================================================================================================================================
//Creation of Objects and Initialization

//object creation
ObjectList list = new ObjectList();

//setup
void setup() {
  size(500, 500);
  background(0);
  frameRate(30);
};


//======================================================================================================================================================
//======================================================================================================================================================
//Drawing Execution
void draw() {
  if (frameCount < 10000) {                    //just to make it stop at some point in time, because I realized this program kinda kills your battery
    if (frameCount%1000 < 500) {               //color changes into different shades of gray every 500 frames
      list.lineColor = random(190, 240);
    } else {
      list.lineColor = random(10, 60);
    }
    list.updateAndDisplay();                  //calls the function of the ObjectList, updating and displaying the screen
  }
}

void mouseClicked() {
  background(0);
  if (lineAppearance == "equal") {
    lineAppearance = "lessOrEqual";
  } else if (lineAppearance == "lessOrEqual") {
    lineAppearance = "equal";
  }
}
