//IM Assignment 9: Adjustable Keyboard (Musical)
//By Joseph Hong
//Description: A simple musical keyboard where you can raise the scale and octaves of the keyboard. You can also play sharp notes of
//             some keys (the same ones on a keyboard) by holding a finger against the photoresistor (imitating touch). Note that you
//             need to have decent lighting for the sharp feature to work properly.
//====================================================================================================================================
//====================================================================================================================================
//Global Variables & Setup

//LEDs
const int yLED = 8;       //port 8, yellow LED
const int bLED = 9;       //port 9, blue LED
const int gLED = 10;      //port 10, green LED
const int rLED = 11;      //port 11, red LED
int leds[] = {rLED, gLED, bLED, yLED};
const int powerLED = 12;  //port 12, power LED (green)


//Keyboard Keys
const int yButton = 3;    //port 3, yellow button
const int bButton = 4;    //port 4, blue button
const int gButton = 5;    //port 5, green button
const int rButton = 6;    //port 6, red button
int keys[] = {rButton, gButton, bButton, yButton};
int keyNum = 4;    //stores pressed button value

//Buzzer
const int buzzer = 13;

//Keyboard Initialization
int startOctave = 1;                //octaves min is 0
int endOctave = 9;                  //octaves max is 10
int octaveCount = endOctave - startOctave;
int totalNotes = octaveCount * 7;
int segmentCount = totalNotes / 4;
int segmentSize = 1024 / segmentCount;

//Notes
const float noteC = 16.35 * pow (2, startOctave - 1);
const float noteD = 18.35 * pow (2, startOctave - 1);
const float noteE = 20.60 * pow (2, startOctave - 1);
const float noteF = 21.83 * pow (2, startOctave - 1);
const float noteG = 24.50 * pow (2, startOctave - 1);
const float noteA = 27.50 * pow (2, startOctave - 1);
const float noteB = 30.87 * pow (2, startOctave - 1);
float notes[] = {noteC, noteD, noteE, noteF, noteG, noteA, noteB};

//Sharps
const float sharpC = 17.32 * pow (2, startOctave - 1);
const float sharpD = 19.45 * pow (2, startOctave - 1);
const float sharpF = 23.12 * pow (2, startOctave - 1);
const float sharpG = 25.96 * pow (2, startOctave - 1);
const float sharpA = 29.14 * pow (2, startOctave - 1);
float sharps[] = {sharpC, sharpD, sharpF, sharpG, sharpA};

//Keyboard Array
int pastPotPosition = 0;      //this stores the past value of potPosition (saves processing power in check)
float keyboardNotes[4];

//Booleans
bool isOn = false;   //this determines whether the keyboard's 'power' is on
bool isSharp = false;     //this determines if the sound to be played is a sharp
bool keyPressed = false;  //this determines whether one of the keys is pressed

//Setup
void setup() {
  //Input
  pinMode(2, INPUT_PULLUP);   //'power' switch

  pinMode(3, INPUT_PULLUP);   //keys for keyboard (yellow, blue, green, red)
  pinMode(4, INPUT_PULLUP);
  pinMode(5, INPUT_PULLUP);
  pinMode(6, INPUT_PULLUP);

  pinMode(7, INPUT_PULLUP);   //photoresistor imitates touch for sharp note

  //Output
  pinMode(12, OUTPUT);        //'power' LED

  pinMode(8, OUTPUT);         //keyboard key LEDs (yellow, blue, green, red)
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);

  pinMode(13, OUTPUT);        //buzzer

  //Begin Serial
  Serial.begin(9600);
}
//====================================================================================================================================
//====================================================================================================================================
//Functions

//Check button pressed (default value 4)
bool keyPressedCheck() {
  if (!digitalRead(keys[0])) {
    keyNum = 0;
    return true;
  }
  else if (!digitalRead(keys[1])) {
    keyNum = 1;
    return true;
  }
  else if (!digitalRead(keys[2])) {
    keyNum = 2;
    return true;
  }
  else if (!digitalRead(keys[3])) {
    keyNum = 3;
    return true;
  }
  else {
    keyNum = 4;
    return false;
  }
}

//Turn on a specific LEDs
void turnOnOne(int num) {
  digitalWrite(leds[num], true);
}

//Turn on all LEDs
void turnOnAll() {
  for (int i : leds) {
    digitalWrite(i, true);
  }
}

//Turn off a specific LED
void turnOffOne(int num) {
  digitalWrite(leds[num], false);
}

//Reset all LEDs to off
void turnOffAll() {
  for (int i : leds) {
    digitalWrite(i, false);
  }
}

//Check for sharp
boolean checkSharp(int photoResist) {
  //Serial.println(photoResist);
  if (photoResist > 400) {
    return false;
  }
  else {
    return true;
  }
}

//Check scale and return the start index of 4 notes. This is done using the patterns that appear every 2 iterations for both odd and
//even phases. Every two iterations, the even phase increases a note by 1 starting from C and the odd does the same but starting from
//G. Using this pattern, I created a function that returns the starting index of the four notes that can be played. When you don't have
//enough buttons, you need to find a workaround.
int returnStartIndex(int potPosition) {
  //Finds which segment (of 4 notes) potentiometer is currently at.
  int scaleNum = (int)(potPosition) / segmentSize;
  //Serial.println( scaleNum );
  //If scale number is even, return the value of the scale number modulus 14 divided by 2
  if (scaleNum % 2 == 0) {
    //Serial.println( (scaleNum % 14) / 2 );
    return ( (scaleNum % 14) / 2);
  }
  //If odd, return (3+(scaleNum%14+1)/2)%6. The modulus 7 is because the numbers go over 7 (array size) when calculating the pattern.
  else {
    //Serial.println( (3 + ( (scaleNum % 14) + 1) / 2) % 7 );
    return (3 + ( (scaleNum % 14) + 1) / 2) % 7;
  }
}

//Takes first index and update 4 keys for keyboard
void updateKeyNotes(int startKeyIndex) {
  for (int i = 0; i < 4; i++) {
    //Serial.print((startKeyIndex + i)%7);
    keyboardNotes[i] = notes[(startKeyIndex + i) % 7];
  }
  //Serial.println("");
}

//Scale octave of keyboard depending on potentiometer
int scaleOctave(int potPosition) {
  int scaleNum = potPosition / segmentSize;
  int keyNumber = scaleNum * 4 + keyNum;
  int octaveNum = keyNumber / 7;
  int multiplier = 1;
  for (int i = 0; i < octaveNum; i++) {
    multiplier *= 2;
  }
  //Serial.println(multiplier);
  return multiplier;
}

//Update keyboard
void updateKeyboard(int potPosition) {
  if (pastPotPosition != potPosition) {
    updateKeyNotes(returnStartIndex(potPosition));
  }
}

//Play note (take into account other sensors before playing note)
void playNote(int potPosition, int photoResist, int keyNum) {
  turnOffAll();
  turnOnOne(keyNum);
  //Serial.println(keyNum);
  //If note is not sharp
  if (!checkSharp(photoResist)) {
    tone(buzzer, keyboardNotes[keyNum]*scaleOctave(potPosition), 1000);
    delay(100);
    //Serial.println( keyboardNotes[keyNum] );
  }
  //Else (if sharp is not activated)
  else {
    //If C, C#
    if (keyboardNotes[keyNum] == noteC) {
      tone(buzzer, sharps[0]*scaleOctave(potPosition), 1000);
      delay(100);
    }
    //If D, D#
    else if (keyboardNotes[keyNum] == noteD) {
      tone(buzzer, sharps[1]*scaleOctave(potPosition), 1000);
      delay(100);
    }
    //If F, F#
    else if (keyboardNotes[keyNum] == noteF) {
      tone(buzzer, sharps[2]*scaleOctave(potPosition), 1000);
      delay(100);
    }
    //If G, G#
    else if (keyboardNotes[keyNum] == noteG) {
      tone(buzzer, sharps[3]*scaleOctave(potPosition), 1000);
      delay(100);
    }
    //If A, A#
    else if (keyboardNotes[keyNum] == noteA) {
      tone(buzzer, sharps[4]*scaleOctave(potPosition), 1000);
      delay(100);
    }
    //Else, return the normal (non-sharp) value
    else {
      tone(buzzer, keyboardNotes[keyNum]*scaleOctave(potPosition), 1000);
      delay(100);
    }
  }
}

//====================================================================================================================================
//====================================================================================================================================
//Execution

void loop() {

  //Set analog values as variables
  int potPosition = analogRead(A0);
  int photoResist = analogRead(A1);

  //Serial.println(potPosition);


  //On or Off
  if (digitalRead(2) == 0) {
    digitalWrite(powerLED, false);
    isOn = false;
  }
  else {
    digitalWrite(powerLED, true);
    isOn = true;
  }

  //If on, play
  if (isOn) {
    //update keyboard
    updateKeyboard(potPosition);
    //if key is pressed, then light up LED and play note
    if (keyPressedCheck() && keyNum < 4) {
      playNote(potPosition, photoResist, keyNum);
      keyPressed = true;
    }
    else if (keyNum == 4) {
      turnOffAll();
      noTone(buzzer);
      keyPressed = false;
    }
  }

}
