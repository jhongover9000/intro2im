

//IM Assignment 10: Flappy Bird Knockoff (Arduino Side)
//By Joseph Hong
//Description: A simple game where you press a button to make the bird fly a little bit. The goal is to get it in between the pipes
//             and score as much as possible. If you hit a pipe, you lose. If you hit the ground you lose. The game gets progressively
//             faster the more points you score. Try to get 50 to win. I've never won.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//lights (RGB LED)
const int rLED = 2;     //port 2, red LED
const int gLED = 4;     //port 4, green LED
const int bLED = 6;     //port 6, blue LED
int lights[] = {bLED, gLED, rLED};

//buttons
const int rButton = 3;  //port 3, red button
const int gButton = 5;  //port 5, green button
const int bButton = 7;  //port 7, blue button
int buttons[] = {bButton, gButton, rButton};

//sonar sensor
const int trigPin = 8;    //connects to the trigger pin
const int echoPin = 9;    //connects to the echo pin

//light game variables
bool firstGame = true;    //ensures that the initialization of the game only happens once
int patternType;          //uses randomSeed() to designate a specific pattern
int patternIncr = 2;      //increment by 2 each phase
int patternLength = 2;    //current pattern length
int pattern[16];          //stores the current pattern for the phase
int passcodeLength = 6;  //passcode length (actual length of digits in passcode is passcodeLength/2)
int passcode[16];         //stores entire pattern, to be sent to Processing

int phaseCounter = 0;     //number of phases completed
int gameCounter = 0;      //number of matched lights in each phase (I know it doesn't make sense but it does in my head)
int phaseEndCount = 3;    //phaseEndCount-1 * patternIncr = number of digits in passcode
bool phaseEnd = true;     //phase ended?
bool gameEnd = true;      //game ended?



//Serial things
int inByte = 0;         //received input
int buttonPressed = 0;  //stores which button is pressed
int potPosition = 0;    //potentiometer
float distance = 0;     //stores the distance measured by the distance sensor

//setup
void setup() {
  //leds
  pinMode(rLED, OUTPUT);
  pinMode(gLED, OUTPUT);
  pinMode(bLED, OUTPUT);

  //button
  pinMode(rButton, INPUT_PULLUP);
  pinMode(gButton, INPUT_PULLUP);
  pinMode(bButton, INPUT_PULLUP);

  //sonar sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT_PULLUP);

  //set up passcode for keypad
  randomSeed(analogRead(A5));
  patternType = (int)random(0, 50);
  initializePasscode();

  Serial.begin(9600);
  establishContact();
}


//====================================================================================================================================
//====================================================================================================================================
//Functions

//check if button is pressed (update buttonPressed value) if not, default value (is decided depending on whether it's a keypad stage)
bool buttonPressedCheck(boolean isKeyPad) {
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
    //if keypad stage, default is 3
    if (isKeyPad) {
      buttonPressed = 3;
    }
    //else, button remains constant
    else {
      buttonPressed = buttonPressed;
    }
    return false;
  }
}


//returns distance (from DistanceSensor example)
float getDistance()
{
  float echoTime;                   //variable to store the time it takes for a ping to bounce off an object
  float calculatedDistance;         //variable to store the distance calculated from the echo time

  //send out an ultrasonic pulse that's 10ms long
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  echoTime = pulseIn(echoPin, HIGH);      //use the pulsein command to see how long it takes for the
  //pulse to bounce back to the sensor

  calculatedDistance = echoTime / 148.0;  //calculate the distance of the object that reflected the pulse (half the bounce time multiplied by the speed of sound)

  return calculatedDistance;              //send back the distance that was calculated
}




//====================================================================================================================================
//====================================================================================================================================
//Execution

//pretty much the only function of this board is to push a button
void loop() {
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
//    char readData[10] = "0000000000";
    // get incoming byte:
    inByte = Serial.read();
//    Serial.print("I received: ");
//    Serial.println(inByte,DEC);

//    //change the received information into a string
//    String input = "";
//    int index = 0;
//    while (readData[index] != '0') {
//      input += readData[index];
//      index++;
//    }
    //Serial.println(input);

    //This was a fun little bit I was going to add to make things more complicated but my computer can't handle making all the inputs
    //so I had to can this part of multiple outputs from Processing into Arduino.
    //    //Comma Splitter (extracted and modified from github repo mattfelsen)
    //    String inputs[4];
    //    int counter = 0;
    //    int lastIndex = 0;
    //
    //    //Iterate through the string and split each comma, placing values in array
    //    for (int i = 0; i < input.length(); i++) {
    //      //Loop through each character and check if it's a comma
    //      if (input.substring(i, i + 1) == ",") {
    //        //Grab the piece from the last index up to the current position and store it
    //        inputs[counter] = input.substring(lastIndex, i);
    //        //Update the last position and add 1, so it starts from the next character
    //        lastIndex = i + 1;
    //        //Increase the position in the array that we store into
    //        counter++;
    //      }
    //      //If we're at the end of the string (no more commas to stop us)
    //      if (i == input.length() - 1) {
    //        // Grab the last part of the string from the lastIndex to the end
    //        inputs[counter] = input.substring(lastIndex, i);
    //      }
    //    }

    //if vault stage, send 2 values: the button that is pressed and the potentiometer value
    if (inByte == 1) {
      //read potentiometer
      potPosition = analogRead(A0);
      //button pressed
      buttonPressedCheck(false);
      //send values:
      Serial.print(potPosition);
      Serial.print(",");
      Serial.println(buttonPressed);

      //can be used with beefier computers..? idk. mine can't handle it. basically the program lights up the dials that have been
      //completed on the breadboard
      //      //check if there are dials that have been unlocked
      //      int arrayLength = sizeof(inputs)/sizeof(inputs[0]);
      //      //if more than 1 then that means there is another value (which comes from the vault stage class)
      //      if(arrayLength > 1){
      //        //for each dial, turn on corresponding light
      //        for(int i = 1; i < arrayLength; i++){
      //          String temp = inputs[i];
      //          turnOnOne(atoi(temp.c_str()));
      //        }
      //      }
    }

    //if drilling stage, send 2 values: if button is pressed (1 or 0) and the distance (int)
    else if (inByte == 2) {

      //distance sensor
      distance = getDistance();
      Serial.print((int)distance);
      Serial.print(",");

      //check button pressed
      if (buttonPressedCheck(false)) {
        Serial.println(1);
      }
      else {
        Serial.println(0);
      }
    }

    //if keypad stage, begins game and reports to processing the code
    else if (inByte == 3) {
      //send passcode to Processing
      sendCode();
      //begin light game for player to figure out code
      lightGame();
    }

  }
}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");   // send an initial string
    delay(300);
  }
}
