//IM Assignment 11 (Final): Bank Heist.
//Joseph Hong
//Description: 
//=======================================================================================================================
//=======================================================================================================================
//Imports
import java.util.ArrayList;    //for the size-changing array
import java.util.Random;       //for selecting a random integer (as opposed to a float)
import java.io.File;
import processing.sound.*;
import processing.serial.*;		//import serial

//=======================================================================================================================
//=======================================================================================================================
//Global Variables and Setup

final int screenWidth = 896;
final int screenHeight = 504;

//Random Integer Generator
Random rand = new Random();

int highScore;

//UI Stuff for game
PFont font; 
SoundFile openingOST;
SoundFile button;
SoundFile stageOST1;
SoundFile stageOST2;
SoundFile bossOST;
SoundFile defeat;
SoundFile victory;

//Assets
PImage vaultDialImg;
ArrayList<SoundFile> vaultDialSounds;
SoundFile dialTick;
SoundFile dialClick;
SoundFile dialClack;
ArrayList<PImage> menuBackgrounds;

int savedTime;
int timeRemaining = 300000;        //time, in milliseconds
int timeReducer = 100;

//Sesnors & Things
int distance;                            //distance sensor
ArrayList<Integer> passcodeCoords;       //light game
int buttonPressed;                       //buttons
boolean buttonPushed;                    //if button is being held down
int potPosition;                         //potentiometer

//Game game = new Game();
int dialLength = 10;
int[] keyPadInput;
int keyPadLength = 8;

//Checkers for Mouse
boolean mouseClicked;
boolean mouseReleased;

//Serial (from SerialCallResponse)
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
boolean firstContact = true;		 // Whether we've heard from the microcontroller
String val;

void setup() {
  size(896, 504);

  //Setup for Timer
  savedTime = millis();

  font = createFont("SAOUITT-Regular.ttf", 32);

  //Sound
  Sound s = new Sound(this);
  s.volume(0.2);
  openingOST = new SoundFile(this, "openOST.mp3");
  defeat = new SoundFile(this, "18 Sad.mp3");
  victory = new SoundFile(this, "victory.mp3");
  button = new SoundFile(this, "button_click.wav");
  vaultDialSounds = new ArrayList<SoundFile>();
  dialTick = new SoundFile(this, "dialTick.wav");
  dialClick = new SoundFile(this, "dialClick.wav");
  dialClack = new SoundFile(this, "dialClack.wav");
  vaultDialSounds.add(dialTick);
  vaultDialSounds.add(dialClick);
  vaultDialSounds.add(dialClack);

  //Images
  vaultDialImg = loadImage("vaultDial.png");
  menuBackgrounds =  new ArrayList<PImage>();
  loadMenuBackgrounds(7);

  //Serial
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}


//=======================================================================================================================
//=======================================================================================================================
//Images and Sounds (Loading Functions)

//Load Menu Backgrounds
void loadMenuBackgrounds(int numImages) {
  for (int i = 0; i < numImages; i++) {
    String numBuffer;
    if (i > 9) {
      numBuffer = "";
    } else if (i > 99) {
      numBuffer = "";
    } else {
      numBuffer = "0";
    }
    PImage p = loadImage("menubackground" + numBuffer + String.valueOf(i) + ".jpg");
    menuBackgrounds.add(p);
  }
}

void muteSounds(ArrayList<SoundFile> sounds) {
  for (SoundFile s : sounds) {
    if (s.isPlaying()) {
      s.stop();
    }
  }
}

void reduceTime(int timeReducer) {
  timeRemaining -= timeReducer;
}

void displayTime() {
  int passedTime = millis();
  int subtract = passedTime - savedTime;
  timeRemaining -= subtract;
  savedTime = passedTime;
  textSize(15);
  textAlign(CENTER);
  fill(0);
  // textFont(words, 50);
  // text(String.valueOf((timeRemaining/1000) % 60)+ , 350, 175);
  // text(":", 300, 175);
  // text(String.valueOf((timeRemaining/(1000 * 60)) % 60), 250, 175);
  text(String.valueOf((timeRemaining/(1000 * 60)) % 60) + ":" + String.valueOf((timeRemaining/1000) % 60), screenWidth - 200, 50);
}

//=======================================================================================================================
//=======================================================================================================================
//Classes



//=======================================================================================================================
//=======================================================================================================================
//Execution

//Autocrack Assets
//int num = 0;


Game game = new Game();

void draw() {
  game.play();
}

//Serial Event
void serialEvent(Serial myPort) {
  //read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  //if you got any bytes other than the linefeed:
  myString = trim(myString);
  println(myString);


  //split the string at the commas and convert the sections into integers:
  int sensors[] = int(split(myString, ','));

  ////if drill
  //if (game.gameState == 2) {
  //  if (sensors.length > 1) {
  //    distance = sensors[0];
  //    if (sensors[1] == 1) {
  //      buttonPushed = true;
  //    } else { 
  //      buttonPushed = false;
  //    }
  //  }
  //}
  //if keypad
  if (game.gameState == 3) {
    if (sensors.length > 1) {
      keyPadInput = sensors;
      game.practiceKeyPad.update(keyPadInput);
    }
  }
  //if vault
  else if (game.gameState == 4) {
    if (sensors.length > 1) {
      potPosition = sensors[0];
      buttonPressed = sensors[1];
      game.practiceDial.update(potPosition);
    }
  }
  
  int output = game.gameState;
  myPort.write(output);
}

void mouseReleased() {
  mouseReleased = true;
}

void keyReleased() {
  //SPACE -- RESET GAME OR NEW STAGE
  if (keyCode == 32) {
    //Reset Game
    if (game.gameState == 1 || game.gameState == 4 || game.gameState == 5) {
      game = new Game();
    }
  }
}
