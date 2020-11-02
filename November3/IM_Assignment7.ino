//IM Assignment 7: 3-Light Game
//By Joseph Hong
//Description: A simple game where you match the order of lights in order to win. The pattern will flash at the start, and you need
//             to match the pattern to win. If you lose, the all the lights will flash 3 times. If you win, the lights will turn on
//             one by one in a row. The red light *does* work, it just takes a few rounds before it's used in a pattern.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//lights
const int rLED = 2;   //port 2, red LED
const int gLED = 3;   //port 3, green LED  
const int bLED = 4;   //port 4, blue LED
int lights[] = {rLED, gLED, bLED};

//buttons
const int rButton = 5; //port 5, red button
const int gButton = 6; //port 6, green button
const int bButton = 7; //port 7, blue button
int buttons[] = {rButton, gButton, bButton};

//stores which button is pressed (3 is the default)
int buttonPressed = 3;

//to count how many pattern lights the player has matched
int gameCounter = 0;

//pattern to follow (6 lights). if changing pattern length, make sure to change both variables!!
int patternLength = 6;
int pattern[6];

//whether or not game is over (to reset; starts as true and is set to false)
bool gameEnded = true;

//setup
void setup() {
  //leds
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  //buttons
  pinMode(5, INPUT_PULLUP);
  pinMode(6, INPUT_PULLUP);
  pinMode(7, INPUT_PULLUP);

}
//====================================================================================================================================
//====================================================================================================================================
//Functions

//make new pattern (reset)
void newPattern() {
  for (int i = 0; i < patternLength; i++) {
    pattern[i] = round(random(0, 3) );
    //Serial.begin(9600);
    //Serial.println(pattern[i]);
  }
}

//display the pattern
void showPattern() {
  for (int i = 0; i < patternLength; i++) {
    turnOnOne(pattern[i]);
    delay(300);
    turnOffOne(pattern[i]);
    delay(300);
  }
}

//check if button is pressed (update buttonPressed value) if not value is 3
bool buttonPressedCheck() {
  if (!digitalRead(buttons[0])) {
    buttonPressed = 0;
    return true;
  }
  else if (!digitalRead(buttons[1])) {
    buttonPressed = 1;
    return true;
  }
  else if (!digitalRead(buttons[2])) {
    buttonPressed = 2;
    return true;
  }
  else {
    buttonPressed = 3;
    return false;
  }
}

//check if user input is same as the current light on the pattern
bool checkPattern(int userInput, int patternNumber) {
  if (userInput == pattern[patternNumber] ) {
    return true;
  }
  else {
    return false;
  }
}

//turn on a specific led
void turnOnOne(int num) {
  digitalWrite(lights[num], true);
}

//turn on all leds
void turnOnAll() {
  for (int i : lights) {
    digitalWrite(i, true);
  }
}

//turn off a specific led
void turnOffOne(int num) {
  digitalWrite(lights[num], false);
}

//reset all leds to off
void turnOffAll() {
  for (int i : lights) {
    digitalWrite(i, false);
  }
}

//win sequence
void win() {
  for (int i = 0; i < 9; i++) {
    turnOnOne(i % 3);
    delay(300);
    turnOffOne(i % 3);
    delay(300);
  }
}

//lose sequence
void lose() {
  for (int i = 0; i < 3; i++) {
    turnOnAll();
    delay(300);
    turnOffAll();
    delay(300);
  }

}
//====================================================================================================================================
//====================================================================================================================================
//Execution

void loop() {


  if (!gameEnded) {
    for (int i = 0; i <= patternLength; i++) { //for each button to be pressed in the sequence
      //wait for user input
      while (!gameEnded) {
        //if button is pressed, turn on led
        if (buttonPressedCheck() && buttonPressed < 3) {
          turnOnOne(buttonPressed);
          delay(300);
          //if the button is the same as the light pattern, then break to next i
          if (checkPattern(buttonPressed, i)) {
            turnOffAll();
            gameCounter++;
            //if player matches entire pattern they win
            if (gameCounter == patternLength) {
              win();
              gameEnded = true;
            }
            break;
          }
          //otherwise end the game
          else {
            turnOffAll();
            delay(300);
            lose();
            gameEnded = true;
            break;
          }
        }
        //all lights are off otherwise
        else {
          turnOffAll();
        }
      }
    }
  }
  //if game is ended, then when a button is pressed reset
  else {
    if (buttonPressedCheck()) {
      newPattern();
      showPattern();
      gameCounter = 0;
      gameEnded = false;
    }
  }

}
