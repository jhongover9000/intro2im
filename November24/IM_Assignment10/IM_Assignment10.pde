//IM Assignment 10: Flappy Bird Knockoff (Processing Side)
//By Joseph Hong
//Description: A simple game where you press a button to make the bird fly a little bit. The goal is to get it in between the pipes
//             and score as much as possible. If you hit a pipe, you lose. If you hit the ground you lose. The game gets progressively
//             faster the more points you score. Try to get 50 to win. I've never won.
//=============================================================================================================
//=============================================================================================================
//Imports
import java.util.ArrayList;     //for the size-changing array
import java.util.Random;        //for selecting a random integer
import processing.serial.*;    //import serial

//=============================================================================================================
//=============================================================================================================
//Global Variables

//Serial (from SerialCallResponse)
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
boolean firstContact = false;     // Whether we've heard from the microcontroller

//Random Integer Generator
Random rand = new Random();

//Screen Dimensions (change in setup as well if modifying)
float screenWidth = 288;
float screenHeight = 512;
int ground = 400;

//Score and Game Phase
int highScore = 0;

//Button pressed
boolean buttonPressed;

PImage birdImg;
ArrayList<PImage> obstacles = new ArrayList<PImage>();
ArrayList<PImage> backgrounds = new ArrayList<PImage>();

//Setup
void setup() {
  //Dimensions and Images
  size(288, 512);
  frameRate(20);
  loadImages();

  //Serial
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  println(Serial.list());
}

//=============================================================================================================
//=============================================================================================================
//Image and Sounds

//Load Images
void loadImages() {
  //Load bird
  birdImg = loadImage("bird.png");
  //Load obstacles and backgrounds
  for (int i = 0; i < 2; i++) {
    PImage tempPipe = loadImage("pipe" + String.valueOf(i) + ".png");
    PImage tempGround = loadImage("0" + String.valueOf(i) + ".png");
    obstacles.add(tempPipe);
    backgrounds.add(tempGround);
  }
}

//=============================================================================================================
//=============================================================================================================
//Classes

//Entity
class Entity {
  //Loc
  int locX;
  int locY;
  //Hitbox
  int hitRangeX1;
  int hitRangeX2;
  int hitRangeY1;
  int hitRangeY2;
  //Velocities
  float velX;
  float velY;

  int imgWidth;
  int imgHeight;

  //Constructor
  Entity(int locX, int locY, float velX, float velY) {
    this.locX = locX;
    this.locY = locY;
    this.velX = velX;
    this.velY = velY;
  }

  //Gravity
  boolean gravity() {
    if (locY + imgHeight/2 < ground) {
      velY += 0.2;
      //Keep the bird from falling too fast (easy mode)
      //if(velY > 3){
      //  velY = 3;
      //}
    }
    if (locY + imgHeight/2 >= ground) {
      return true;
    } else {
      return false;
    }
  }

  //Update locations and hitbox
  void updateLocRange() {
    locX += velX;
    locY += velY;

    hitRangeX1 = locX - imgWidth/2;
    hitRangeX2 = locX + imgWidth/2;
    hitRangeY1 = locY - imgHeight/2;
    hitRangeY2 = locY + imgHeight/2;
  }
}

//Bird
class Bird extends Entity {

  PImage img;
  boolean isAlive;

  //Constructor
  Bird(int locX, int locY, int velY) {
    super(locX, locY, 0, velY);
    img = birdImg;
    this.imgWidth = 36;
    this.imgHeight = 26;
    this.locX = locX;
    this.locY = locY;
    this.hitRangeX1 = locX - imgWidth/2;
    this.hitRangeX2 = locX + imgWidth/2;
    this.hitRangeY1 = locY - imgHeight/2;
    this.hitRangeY2 = locY + imgHeight/2;
    //Only moves up and down
    this.velY = velY;
    this.isAlive = true;
  }

  //Update (based on button)
  void update() {

    //Dies if hitting the ground
    if (locY == ground) {
      isAlive = false;
    }

    //Controllable if alive
    if (isAlive) {
      //If button was pressed, jump
      if (buttonPressed && velY > -2) {
        velY -= 5;
        if (velY < -5) {
          velY = -5;
        }
      } else {
        gravity();
      }
    }
    //If dead it goes straight to the ground.
    else {
      velY +=1;
      gravity();
    }


    updateLocRange();
  }


  void display() {
    pushMatrix();
    float rotation = map(velY, -10, 10, 310, 350);
    translate(locX, locY);
    rotate(radians(rotation));
    imageMode(CENTER);
    image(birdImg, 0, 0, imgWidth, imgHeight);
    popMatrix();
  }
}

//Obstacle: this class uses the locY as the middle Y of the obstacle
class Obstacle extends Entity {

  PImage topPipe;
  PImage bottomPipe;

  Obstacle(int locX, int locY, int velX) {
    super(locX, locY, velX, 0);
    this.locX = locX;
    this.locY = locY;
    //Only moves from side to side
    this.velX = -1 * velX;

    //Link images
    topPipe = obstacles.get(0);
    bottomPipe = obstacles.get(1);

    this.imgWidth = 52;
    this.imgHeight = 242;
  }

  //Update locations and hitbox
  void updateLocRange() {
    locX += velX;
    locY += velY;

    hitRangeX1 = locX - imgWidth/2;
    hitRangeX2 = locX + imgWidth/2;
    hitRangeY1 = locY - 75;
    hitRangeY2 = locY + 75;
  }

  //Update
  void update() {
    updateLocRange();
  }

  //Display: consists of two images (top and bottom pipe)
  void display() {
    imageMode(CENTER);
    image(topPipe, (int) locX, (int) locY - imgHeight/2 - 75);
    image(bottomPipe, (int) locX, (int) locY + imgHeight/2 + 75);
  }
}

class Stage {

  float middleX;  //to move the background
  int score;
  int pastScore;           //keep track of last score
  int stageSpeed;          //speed of obstacles & background
  boolean gameEnd;
  boolean gameWin;

  Bird birdie;
  ArrayList<Obstacle> pipes;
  ArrayList<Obstacle> deleteObjectList;

  //Constructor
  Stage() {
    this.birdie = new Bird((int) screenWidth/2, (int) screenHeight/2, 0);
    this.pipes = new ArrayList<Obstacle>();
    this.deleteObjectList = new ArrayList<Obstacle>();
    this.middleX = screenWidth/2;
    this.score = 0;
    this.pastScore = 0;
    this.stageSpeed = 2;
    this.gameEnd = false;
    this.gameWin = false;
  }

  //Update
  void update() {

    //If the bird is still in the air
    if (!birdie.gravity()) {
      //Add pipe if none left
      if (pipes.size() < 1) {
        Obstacle tempPipe = new Obstacle((int) screenWidth + 52, (int) random(75, ground - 75), stageSpeed);
        pipes.add(tempPipe);
      }

      //Update bird
      birdie.update();


      //Update pipes
      for (Obstacle o : pipes) {
        //If bird passed through pipes and the game hasn't ended, score ++
        if (o.locX + o.imgWidth <= screenWidth/2 ) {
          if (screenWidth/2 - stageSpeed/2 <= o.locX + o.imgWidth && o.locX + o.imgWidth <= screenWidth/2 + stageSpeed/2) {
            score++;
          }
          //Delete object if out of screen
          if (o.locX + o.imgWidth <= 0 ) {
            deleteObjectList.add(o);
          }
        }
        //If bird is within range of obstacles, make sure that it is between the pipes
        if (o.hitRangeX1 <= birdie.hitRangeX1 && birdie.hitRangeX1 <= o.hitRangeX2 || 
          o.hitRangeX1 <= birdie.hitRangeX2 && birdie.hitRangeX2 <= o.hitRangeX2) {
          //If the bird is in the hitbox of the pipes (collides), it dies
          if (!(o.hitRangeY1 <= birdie.hitRangeY1 && birdie.hitRangeY1 <= o.hitRangeY2) || 
            !(o.hitRangeY1 <= birdie.hitRangeY2 && birdie.hitRangeY2 <= o.hitRangeY2)) {
            birdie.isAlive = false;
          }
        }
        o.update();
      }
      pipes.removeAll(deleteObjectList);


      //Gets faster the higher the score
      if (pastScore != score && score%10 == 0) {
        //println("speedup");
        stageSpeed++;
      }

      middleX += stageSpeed;

      //If score is 50 (how?), you win
      if (score >= 50) {
        gameWin = true;
        gameEnd = true;
      }

      //Update past score
      pastScore = score;
    }
    //If game is over
    else {
      gameEnd = true;
    }
  }

  //Display
  void display() {
    //background 1, pipes, bird, background 2
    int imgNumber = 2;

    //Using the middleX to make the background "move"
    for (int i = 0; i < 2; i++) {

      int x = (int)(middleX/imgNumber) % (int)screenWidth;

      imageMode(CORNER);
      //Differentiate location of image for background and foreground
      if (i == 0) {
        image(backgrounds.get(i), 0, 0, screenWidth - (x), screenHeight, (int) x, 0, (int) screenWidth, (int) screenHeight);
        image(backgrounds.get(i), screenWidth - x, 0, x, screenHeight, 1, 0, (int) x, (int) screenHeight);
      } else {
        image(backgrounds.get(i), 0, ground, screenWidth - (x), screenHeight, (int) x, 0, (int) screenWidth, (int) screenHeight);
        image(backgrounds.get(i), screenWidth - x, ground, x, screenHeight, 1, 0, (int) x, (int) screenHeight);
      }
      imgNumber--;

      //Display the pipes and bird (once, after the initial background)
      if (i == 0) {
        for (Obstacle o : pipes) {
          o.display();
        }
        birdie.display();
      }
    }
    //Display score if playing
    if (!gameEnd) {
      //Display score
      fill(255);
      textAlign(LEFT, TOP);
      textSize(15);
      text("Score: " + score, 10, 10 );
    }
  }
}

//Game
class Game {
  Stage stage;
  String phase = "start";    //different phases are "start", "play", "end".

  //Constructor
  Game() {
    this.stage = new Stage();
  }

  //Update
  void update() {
    //Push to start
    if (phase == "start") {
      stage.display();
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Push Button to Play!", screenWidth/2, ground/2);
      if (buttonPressed) {
        phase = "play";
      }
    }
    //Play game
    if (phase == "play") {
      stage.update();
      stage.display();
      if (stage.gameEnd) {
        phase = "end";
      }
    }
    //Reset ability if button is pushed at gameover
    if (phase == "end") {
      if (stage.score > highScore) {
        highScore = stage.score;
      }
      //If game is over, display score (and if they won)
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(20);
      //display win/lose
      if (stage.gameWin) {
        text("You Win! How?! \n Score: " + stage.score + "  High Score: " + highScore + "\n Push Button to Restart", screenWidth/2, ground/2);
      } else {
        text("Game Over! \n Score: " + stage.score + "  High Score: " + highScore + "\n Push Button to Restart", screenWidth/2, ground/2);
      }
      if (buttonPressed) {
        stage = new Stage();
        phase = "start";
      }
    }
  }

  //Display
  void display() {
  }
}

//=============================================================================================================
//=============================================================================================================
//Execution

Game game = new Game();

//Draw
void draw() {
  game.update();
}

//Serial Event
void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  print(inByte);
  // if this is the first byte received, and it's an A, clear the serial
  // buffer and note that you've had first contact from the microcontroller.
  if (inByte == 'P') {
    myPort.clear();
    buttonPressed = true;
  } else { 
    myPort.clear();
    buttonPressed = false;
  }

  // Send a capital A to request new sensor readings:
  println("sent");
  myPort.write('A');
}
