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

final int screenWidth = 852;
final int screenHeight = 480;

int highScore;

PImage vaultDialImg;
ArrayList<SoundFile> vaultDialSounds;
SoundFile dialTick;
SoundFile dialClick;
SoundFile dialClack;

int savedTime;
int timeRemaining = 300000;        //time, in milliseconds

int buttonPressed;
int potPosition;
int distance;

//Game game = new Game();
int dialLength = 10;

//Serial (from SerialCallResponse)
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
boolean firstContact = true;		 // Whether we've heard from the microcontroller
String val;

void setup() {
  size(852, 480);

  //Setup for Timer
  savedTime = millis();

  //Sound
  Sound s = new Sound(this);
  s.volume(0.2);
  vaultDialSounds = new ArrayList<SoundFile>();
  dialTick = new SoundFile(this, "dialTick.wav");
  dialClick = new SoundFile(this, "dialClick.wav");
  dialClack = new SoundFile(this, "dialClack.wav");
  vaultDialSounds.add(dialTick);
  vaultDialSounds.add(dialClick);
  vaultDialSounds.add(dialClack);


  vaultDialImg = loadImage("vaultDial.png");

  //Serial
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}


//=======================================================================================================================
//=======================================================================================================================
//Images and Sounds (Loading Functions)

//Load Images
void loadImages() {
}

void muteSounds(ArrayList<SoundFile> sounds) {
  for (SoundFile s : sounds) {
    if (s.isPlaying()) {
      s.stop();
    }
  }
}

void reduceTime() {
  timeRemaining -= 100;
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


//Dial dial = new Dial(1, 99, screenWidth / 2, screenHeight / 2, 200, 200);
VaultStage stage = new VaultStage();
void draw() {

  background(240);
  //Timer
  displayTime();

  stage.display();
  //dial.update(num);
  //dial.display();
}

//Serial Event
void serialEvent(Serial myPort) {
  //read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  //if you got any bytes other than the linefeed:
  myString = trim(myString);
  println(myString);
  myPort.clear();
  
  //split the string at the commas and convert the sections into integers:
  int sensors[] = int(split(myString, ','));

  // if(game.gameState == "drill"){
  // if (sensors.length > 1){
  //   distance = sensors[0];
  //   drillOn = sensors[1];
  // }
  // }
  // else if(game.gameState == "keypad"){

  // }

  //else if(game.gameState == "vault"){
  if (sensors.length > 1) {
    potPosition = sensors[0];
    buttonPressed = sensors[1];
    stage.update(potPosition, buttonPressed);
    //writing output
    //output += gameStage;
    
    //can be used with beefier computers..? basically the program lights up the dials that have been completed on the breadboard
    //if (stage.completedDials.size() > 0) {
    //  int i = 0;
    //  //add each finished dial to the 
    //  for (; i < stage.completedDials.size() - 1; i++) {
    //    output += ",";
    //    output += stage.completedDials.get(i);
    //  }
    //  output += ",";
    //  output += stage.completedDials.get(i);
    //}
    
  }
  //}


  // send a byte to ask for more data:
  myPort.write(3);
  //gameState is saved as a string, not an integer?
  //myPort.write(gameState);
}
