//IM Assignment 8: LED Escape Room
//By Joseph Hong
//Description: Match the right potentiometer and photoresistor value combo in order to proceed to the next stage. Flipping the switch
//             will start the room and turn on the lights; flipping it again will turn it off and restart the game.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//LEDs
const int rLED = 5;           //port 5, red LED
const int gLED = 4;           //port 4, green LED
const int bLED = 3;           //port 3, blue LED
const int yLED = 2;           //port 2, yellow LED
int lights[] = {rLED, gLED, bLED, yLED};
const int powerLED = 6;       //port 6, power (green) LED

//Buttons & Switch
const int toggleSwitch = 13;  //port 13, toggle switch
const int gButton = 12;       //port 12, green button
const int yButton = 11;       //port 11, yellow button
int buttons[] = {gButton, yButton};
int buttonPressed = 2;        //checks which button is pressed

//Conditionals
bool buttonPressedOne = false;
bool buttonPressedTwo = false;
bool switchSwitched = false;

//Whether or not game is over (to reset; starts as true and is set to false)
int roomType;
bool gameEnd = true;

//Class for lock (stores whether it's complete or not as well as the type)
class Lock {
  public:
    int lockNum;
    int completionReq;        //lock type (i.e. potentiometer value + photoresist value, potentiometer*2 on button click, etc.)
    int startVal;             //starting value (this is changed depending on the lock type)
    int keyVal;          //value to unlock lock
    bool isComplete = false;

    //constructor
    Lock::Lock(int& lockNum, int completionReq, int startVal) {
      this->lockNum = lockNum;
      this->completionReq = completionReq;
      //change value according to completion requisite
      if (completionReq == 0) {          //switch + potentiometer + photoresistor
        keyVal = startVal + 350;
      }
      else if (completionReq == 1) {     //button + potentiometer
        keyVal = startVal * 2;
      }
      else if (completionReq == 2) {     //potentiometer
        keyVal = startVal;
      }
      else if (completionReq == 3) {     //switch + button
        keyVal = (int)random(2, 4);
      }
    }
};

//Locks
Lock* locks[4];
int locksComplete = 0;

//Setup
void setup() {

  //Inputs
  pinMode(13, INPUT_PULLUP);  //switch
  pinMode(12, INPUT_PULLUP);  //buttons
  pinMode(11, INPUT_PULLUP);

  //Outputs
  pinMode(5, OUTPUT); //4 locks
  pinMode(4, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(2, OUTPUT);

  //Serial
  Serial.begin(9600);


}


//====================================================================================================================================
//====================================================================================================================================
//Functions

//Initialize Escape Room (add new random values based on new seed)
void initialize() {
  for (int i = 0; i < 4; i++) {
    Lock* temp = new Lock(i, (int)random(4), (int)random(1023));
    //    Serial.print(temp->completionReq);
    //    Serial.print(" Key: ");
    //    Serial.println(temp->keyVal);
    locks[i] = temp;
  }
}

//Turn on a specific led
void turnOnOne(int num) {
  digitalWrite(lights[num], true);
}

//Turn on all leds
void turnOnAll() {
  for (int i : lights) {
    digitalWrite(i, true);
  }
}

//Turn off a specific led
void turnOffOne(int num) {
  digitalWrite(lights[num], false);
}

//Reset all leds to off
void turnOffAll() {
  for (int i : lights) {
    digitalWrite(i, false);
  }
}

//Check if button is pressed (and how many)
int buttonPressedCheck(int potPosition) {
  if (digitalRead(toggleSwitch)) {
    switchSwitched = true;
    analogWrite(powerLED, potPosition);
  }
  else if (!digitalRead(toggleSwitch)) {
    switchSwitched = true;
    analogWrite(powerLED, false);
  }
  if (!digitalRead(buttons[0])) {
    if (buttonPressedOne && buttonPressed != 0) {
      buttonPressedTwo = true;
      //Serial.print("buttonPressed2");
    }
    else {
      buttonPressedOne = true;
      //Serial.print("buttonPressed");
    }
    buttonPressed = 0;
    return potPosition * 2;
  }
  else if (!digitalRead(buttons[1])) {
    if (buttonPressedOne && buttonPressed != 1) {
      buttonPressedTwo = true;
      //Serial.print("buttonPressed2");
    }
    else {
      buttonPressedOne = true;
      //Serial.print("buttonPressed");
    }
    buttonPressed = 1;
    return potPosition * 2;
  }
  else {
    buttonPressed = 2;
    buttonPressedOne = false;
    buttonPressedTwo = false;
    return potPosition;
  }
}

//Set a poteniometer + photoresistor value
void checkOne(Lock& lock, int potPosition, int photoResist) {
  //  Serial.print(potPosition + photoResist);
  //  Serial.print(" Key: ");
  //  Serial.println(lock.keyVal);

  //Compare value of potentimeter + photoresistor with key value
  if (potPosition + photoResist >= lock.keyVal - 20 && potPosition + photoResist <= lock.keyVal + 20) {
    //Serial.println("checkOneComplete");
    if (!lock.isComplete) {
      lock.isComplete = true;
      locksComplete++;
    }
  }
}

//When button is pressed potentiometer values are multiplied by 2
void checkTwo(Lock& lock, int potPosition) {
  //  Serial.print(potPosition);
  //  Serial.print(" (2) Key: ");
  //  Serial.println(lock.keyVal);

  //Light up the lock (hint)
  if (buttonPressedTwo) {
    digitalWrite(lights[lock.lockNum], true);
  }
  else if (!buttonPressedTwo && !lock.isComplete) {
    digitalWrite(lights[lock.lockNum], false);
  }

  //Compare value of potentimeter with key value
  if (potPosition >= lock.keyVal - 10 && potPosition <= lock.keyVal + 10) {
    //Serial.println("check2Complete");
    if (!lock.isComplete) {
      lock.isComplete = true;
      locksComplete++;
    }
  }
}

//Just potentiometer & switch
void checkThree(Lock& lock, int potPosition) {
  //  Serial.print(potPosition);
  //  Serial.print(" (3) Key: ");
  //  Serial.println(lock.keyVal);

  //Compare value of potentimeter with key value
  if (potPosition >= lock.keyVal - 10 && potPosition <= lock.keyVal + 10) {
    //Serial.println("check3Complete");
    if (!lock.isComplete) {
      lock.isComplete = true;
      locksComplete++;
    }
  }
}

//Switch & Buttons
void checkFour(Lock& lock) {

  //Light up the lock (hint)
  if (buttonPressedTwo) {
    digitalWrite(lights[lock.lockNum], true);
  }
  else if (!buttonPressedTwo && !lock.isComplete) {
    digitalWrite(lights[lock.lockNum], false);
  }

  int tempVal = 0;
  //max value is 7, but the key values range from 2-3
  if (switchSwitched) {
    tempVal += 7;
  }
  if (buttonPressedOne) {
    tempVal -= 4;
  }
  if (buttonPressedTwo) {
    tempVal -= 1;
  }

  //  Serial.print(tempVal);
  //  Serial.print(" (4) Key: ");
  //  Serial.println(lock.keyVal);

  if (tempVal == lock.keyVal) {
    //Serial.println("check4Complete");
    if (!lock.isComplete) {
      lock.isComplete = true;
      locksComplete++;
    }
  }
}

//Update Locks
void updateLocks(int potPosition, int photoResist) {
  for (Lock* i : locks) {
    //Serial.println("check");
    //    Serial.print("Lock Num: ");
    //    Serial.print(i->lockNum);
    //    Serial.print("Complete: ");
    //    Serial.println(i->isComplete);

    //if lock is unlocked, light up the LED if it isn't on yet
    if (i->isComplete) {
      if (!digitalRead(lights[i->lockNum]) ) {
        digitalWrite(lights[i->lockNum], true);
        delay(100);
      }
    }
    else {
      if (i->completionReq == 0) {
        //Serial.print("checking 1");
        checkOne(*i, potPosition, photoResist);
      }
      else if (i->completionReq == 1) {
        //Serial.print("checking 2");
        //light up the lock that has req 1 (hint). if you solve it, the light will stay on.
        if (buttonPressedOne) {
          digitalWrite(lights[i->lockNum], true);
        }
        else {
          digitalWrite(lights[i->lockNum], false);
        }
        checkTwo(*i, potPosition);
      }
      else if (i->completionReq == 2) {
        //Serial.print("checking 3");
        checkThree(*i, potPosition);
      }
      else if (i->completionReq == 3) {
        //Serial.print("checking 4");
        checkFour(*i);
      }
    }
  }



}

//update game
void updateGame() {
  if (locksComplete == 4) {
    victory();
    gameEnd = true;
  }
}

//start sequence
void start() {
  for (int i = 0; i < 4; i++) {
    turnOnOne(i % 4);
    delay(300);
    turnOffOne(i % 4);
    delay(300);
  }
}

//start sequence
void victory() {
  turnOffAll();
  for (int i = 0; i < 8; i++) {
    turnOnOne(i % 4);
    delay(300);
    turnOffOne(i % 4);
    delay(300);
  }
}

//====================================================================================================================================
//====================================================================================================================================
//Execution

void loop() {

  //Set up analog input
  int potPosition = analogRead(A0);
  int photoResist = analogRead(A1);

  if (!gameEnd) {
    //Update values
    potPosition = buttonPressedCheck(potPosition);
    //Serial.println(potPosition);
    updateLocks(potPosition, photoResist);
    delay(500);
    updateGame();
  }
  //If game is over, reset the game (and randomize seed)
  else {
    buttonPressedCheck(potPosition);
    if (buttonPressedOne) {
      start();
      roomType = rand() % 50;
      randomSeed(roomType);
      initialize();
      gameEnd = false;
      locksComplete = 0;
    }
  }

}
