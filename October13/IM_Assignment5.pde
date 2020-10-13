//IM Assignment 5
//Joseph Hong
//Description: The image gets crazier and crazier the more you click. You're basically really, really high. Each click adds
//             effects, but from the 4th click random images start to appear on the screen. They bounce around the screen
//             and just make things a lot crazier. After a certain number of clicks, you "overdose" and can reset the screen.
//             I have no idea what came across me or why I decided to make this.
//============================================================================================================================
//============================================================================================================================
//Imports
import java.util.Random;       //for selecting a random integer (as opposed to a float)

//============================================================================================================================
//============================================================================================================================
//Global Variables & Setup

//user directory
String cmd = System.getProperty("user.dir");

//screen sizes (change in setup as well)
int screenWidth = 500;
int screenHeight = 377;

//Number of times the screen has been clicked
int thatHighTho = 0;

//Number of white pixels
int whitePixels;
boolean overDose = false;

//main image + arrays for others
PImage mainImage;
ArrayList<PImage> randomImage = new ArrayList<PImage>();

ObjectList listEntities = new ObjectList();

color[] rgb = {color(100, 0, 0), color(0, 100, 0), color(0, 0, 100)};
int colorChangeValue;
int colorChangeSpeed = 20;

float rTint;
float gTint;
float bTint;


//Random Integer Generator
Random rand = new Random();

void setup() {
  size(500, 337);
  frameRate(30);
  mainImage = loadImage("background.jpg");
  for (int i = 0; i < 3; i++) {
    PImage temp = loadImage("img0" + String.valueOf(i) + ".png");
    randomImage.add(temp);
  }
}

//============================================================================================================================
//============================================================================================================================
//Functions

//Change pixels to one of R, G, or B
void change2RGB() {

  //Going back and forth between getting darker and brighter (emphasis on closet r/g/b value)
  if (frameCount%50 < 25) {
    colorChangeValue+=4;
  } else if (frameCount%50 > 25) {
    colorChangeValue-=4;
  }

  loadPixels();

  for (int i = 0; i < pixels.length; i++) {
    float r = red(mainImage.pixels[i]);
    float g = green(mainImage.pixels[i]);
    float b = blue(mainImage.pixels[i]);

    //constrain size
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);

    //Change pixel to closest RGB value (whichever has the highest value)
    if (compare(r, b, g)) {
      pixels[i] = color(r + rTint + colorChangeValue, g + gTint + colorChangeValue/2, b + bTint + colorChangeValue/2);
    } else if (compare(g, r, b)) {
      pixels[i] = color(r + rTint + colorChangeValue/2, g + gTint + colorChangeValue, b + bTint + colorChangeValue/2);
    } else if (compare(b, r, g)) {
      pixels[i] = color(r + rTint + colorChangeValue/2, g + gTint + colorChangeValue/2, b + bTint + colorChangeValue);
    } else {
      if (i>0) {
        pixels[i] = color(pixels[i-1]);
      }
    }
  }

  //If the mouse is clicked again, add tints. colorChangeSpeed dictates how fast the colors change.
  if (frameCount%10 == 0) {
    if (thatHighTho >= 2) {
      addTint(rgb[frameCount%3]);
    }
  }

  updatePixels();
}

//Add tint to entire screen
void addTint(color col) {
  loadPixels();
  rTint = red(col);
  gTint = green(col);
  bTint = blue(col);
}

//Blur
void tripping() {
  for (int i = 0; i < 10000; i++) {
    int x = rand.nextInt(mainImage.width);
    int y = rand.nextInt(mainImage.height);

    float r = red(mainImage.pixels[x + y * mainImage.width]);
    float g = green(mainImage.pixels[x + y * mainImage.width]);
    float b = blue(mainImage.pixels[x + y * mainImage.width]);
    noStroke();
    fill(r, g, b, 100);
    ellipse(x, y, 2, 2);
  }
}


//Comparison function
boolean compare(float x, float y, float z) {
  if (x > y && x > z) {
    return true;
  } else {
    return false;
  }
}

//Reset image and values
void reset() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    float r = red(mainImage.pixels[i]);
    float g = green(mainImage.pixels[i]);
    float b = blue(mainImage.pixels[i]);
    pixels[i] = color(r, g, b);
  }
  updatePixels();
  overDose = false;
  thatHighTho = 0;
  colorChangeValue = 0;
  colorChangeSpeed = 0;
  rTint = gTint = bTint = 0;
}


//============================================================================================================================
//============================================================================================================================
//Classes

class Object {
  float locX;
  float locY;
  float velX = rand.nextInt(4)+1;  
  float velY = rand.nextInt(4)+1;
  float rotation = 0;
  float opacity = 200;

  PImage img;
  float imgHeight = 80;
  float imgWidth = 80;

  Object(float locX, float locY, PImage img) {
    this.locX = locX;
    this.locY = locY;
    this.img = img;
  }

  //Update location
  void update() {
    if (locX >= screenWidth || locX <= 0) {
      velX *= -1;
    }
    if (locY >= screenHeight || locY <= 0) {
      velY *= -1;
    }
    locX += velX;
    locY += velY;
    rotation++;
  }

  //Display Image
  void display() {
    pushMatrix();
    translate(locX, locY);
    rotate(radians(rotation));
    imageMode(CENTER);
    tint(255, opacity);
    image(img, 0, 0, imgWidth, imgHeight);
    popMatrix();
  }
}


//Class of object list
class ObjectList {
  ArrayList<Object> objects = new ArrayList<Object>();

  //update and display all objects
  void updateAndDisplay() {
    for (Object i : objects) {
      i.update();
      i.display();
    }
  }

  //speed up objects by increment, reduce opacity by increment
  void speedUp() {
    for (Object i : objects) {
      i.velX++;
      i.velY++;
      i.opacity --;
    }
  }
}


//============================================================================================================================
//============================================================================================================================
//Draw

void draw() {
  //if you haven't clicked 30 times, then the artwork keeps going.
  if (thatHighTho < 30) {
    if (thatHighTho == 0) {
      imageMode(CORNER);
      image(mainImage, 0, 0);
    }  
    if (thatHighTho >= 1) {
      change2RGB();
      if (thatHighTho >=3) {
        tripping();
      }
      listEntities.updateAndDisplay();
    }
  } 
  //if you go over 30 clicks, you... overdose
  else {
    overDose = true;
    background(255);
    fill(0);
    textAlign(CENTER);
    text("Enlightenment? Shangri La? Whatever they call it... I think you've reached it. \n \n Click to Play Again.", width/2, height/2);
  }
}

void mouseClicked() {
  //increment thatHighTho, then add a new object if you're at that point
  thatHighTho++;
  if (thatHighTho > 3) {
    Object newThing = new Object(mouseX, mouseY, randomImage.get(thatHighTho%3));
    listEntities.objects.add(newThing);
    listEntities.speedUp();
    colorChangeValue += 5;
  }
  //reset if over
  if (overDose) {
    while (listEntities.objects.size() > 0) {
      listEntities.objects.clear();
    }
    reset();
    setup();
  }
}
