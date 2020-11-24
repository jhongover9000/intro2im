//IM Assignment 10: Flappy Bird Knockoff (Arduino Side)
//By Joseph Hong
//Description: A simple game where you press a button to make the bird fly a little bit. The goal is to get it in between the pipes
//             and score as much as possible. If you hit a pipe, you lose. If you hit the ground you lose. The game gets progressively
//             faster the more points you score. Try to get 50 to win. I've never won.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//buttons
const int rButton = 2; //port 2, red button

//stores which button is pressed (1 is the default) - changed because the sync speed is too fast to use this format
//bool buttonPressed = false;
//bool buttonPressedPast = false;

//stores the string to be sent

//setup
void setup() {
  //button
  pinMode(2, INPUT_PULLUP);
  Serial.begin(9600);
  establishContact();
}


//====================================================================================================================================
//====================================================================================================================================
//Functions

//check if button is pressed. only returns true if it's been pressed after a release.
bool buttonPressedCheck() {
  if (!digitalRead(rButton)) {
      return true;
  }
  else {
    return false;
  }
}


//====================================================================================================================================
//====================================================================================================================================
//Execution

//pretty much the only function of this board is to push a button
void loop() {
  if (Serial.available() > 0) {
    int inByte = Serial.read();
    //if button is pressed then send that it has been pushed ('P')
    if (buttonPressedCheck()) {
      Serial.write('P');
    }
    else if (inByte != 'P'){
      Serial.write('A');
    }
  }
}

//used the code from SerialCallResponse from the Arduino examples; this establishes the connection between the board and processing
void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}
