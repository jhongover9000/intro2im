//IM Assignment 7: 3-Light Game
//By Joseph Hong
//Description: A simple game where you match the order of lights in order to win. The pattern will flash at the start, and you need
//             to match the pattern to win. If you lose, the all the lights will flash 3 times. If you win, the lights will turn on
//             one by one in a row. The red light *does* work, it just takes a few rounds before it's used in a pattern.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//lights (separate)
const int rLED = 2;   //port 2, red LED
const int gLED = 3;   //port 3, green LED
const int bLED = 4;   //port 4, blue LED
int lights[] = {rLED, gLED, bLED};

//buttons
const int rButton = 5; //port 5, red button
const int gButton = 6; //port 6, green button
const int bButton = 7; //port 7, blue button
int buttons[] = {rButton, gButton, bButton};

//lights (RGB LED)
const int rgbRED = 8;   //port 8, red LED
const int rgbGRE = 9;   //port 9, green LED
const int rgbBLU = 10;   //port 10, blue LED
int rgbLED[] = {rgbRED, rgbGRE, rgbBLU};

//stores which button is pressed (3 is the default)
int buttonPressed = 3;

//to count how many pattern lights the player has matched
int gameCounter = 0;
int phaseCounter = 0;

//pattern to follow (4 initial, 16 max). increases each phase by 4. if changing pattern lengths, make sure to change both variables!!
int patternLength = 4;
int patternIncr = 4;
int pattern[16];
//this is the pattern type, which is used in randomSeed(). according to the arduino reference, this makes more random numbers.
//however, if you have a specific number, you can create a consistent pattern (thought this was kinda clever hehe)
//update: I had this cool idea that I could change this every game, giving a new pattern every game
int patternType;

//whether or not game is over (to reset; starts as true and is set to false)
bool phaseEnd = true;
bool gameEnd = true;

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
  //rgb LED
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);

  

}
//====================================================================================================================================
//====================================================================================================================================
//Functions

//make new pattern (reset)
void newPattern() {
  randomSeed(patternType);
  for (int i = 0; i < patternLength; i++) {
    pattern[i] = round(random(3) );
  }
}

//display the pattern
void showPattern() {
  turnOffAll();
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

//reset rgb LED to off
void turnOffAllRGB() {
  for (int i : rgbLED) {
    digitalWrite(i, false);
  }
}

//next phase! this will light up the rgb LED with one color per turn (all three will result in white)
void nextPhase() {
  for (int i = 0; i < 3; i++) {
    turnOnOne(i % 3);
    delay(300);
    turnOffOne(i % 3);
    delay(300);
  }
  turnOffAll();
  digitalWrite(rgbLED[phaseCounter], true);
  patternLength += patternIncr;

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
  turnOffAllRGB();
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

  //if all phases have been cleared, end game
  if (phaseCounter == 3) {
    turnOffAll();
    delay(300);
    win();
    patternLength -= phaseCounter * patternIncr;
    phaseCounter = 0;
    gameEnd = true;
    phaseEnd = true;
  }

  //if game is not over, keep the game going
  if (!phaseEnd) {
    for (int i = 0; i <= patternLength; i++) { //for each button to be pressed in the sequence

      //wait for user input
      while (!phaseEnd) {
        //if button is pressed, turn on led
        if (buttonPressedCheck() && buttonPressed < 3) {
          turnOnOne(buttonPressed);
          delay(300);

          //if the button is the same as the light pattern, then break to next i
          if (checkPattern(buttonPressed, i)) {
            turnOffAll();
            gameCounter++;

            //if player matches entire pattern they move to next phase
            if (gameCounter == patternLength) {
              delay(300);
              nextPhase();
              phaseCounter++;
              phaseEnd = true;
              break;
            }

            break;
          }

          //otherwise end the game & reset values
          else {
            turnOffAll();
            delay(300);
            lose();
            patternLength -= phaseCounter * patternIncr;
            phaseEnd = true;
            gameEnd = true;
            break;
          }
        }
        //all lights are off otherwise (minus the RGB LED)
        else {
          turnOffAll();
        }
      }
    }
  }
  //if phase AND game is ended, then when a button is pressed reset
  else if (phaseEnd && gameEnd) {
    if (buttonPressedCheck()) {
      gameCounter = 0;
      phaseCounter = 0;
      //Set new pattern
      patternType = round(random(50));
      phaseEnd = false;
      gameEnd = false;
      turnOffAllRGB();
      newPattern();
      showPattern();
    }
  }
  //if phase is over, then move to next phase
  else if (phaseEnd) {
    delay(500);
    newPattern();
    showPattern();
    gameCounter = 0;
    phaseEnd = false;
  }

}
