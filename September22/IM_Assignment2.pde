//Introduction to Interactive Media Assignment 2: Repeating Art
//Joseph Hong
//Description: This is a dynamic piece of art that uses randomization to constantly dish out
//             new pieces of "art" every 10 frames.
//======================================================================================================================================================
//======================================================================================================================================================
//Fuctions

//used to make a line go down the screen at a given x value
void lineDown(float locX) {
  line(locX, 0, locX, height);
}

//used to make a line go across the screen at a given y value
void lineCross(float locY) {
  line(0, locY, width, locY);
}

//uses a while loop to randomly add lines on the screen to create graphic art
void makeArt() {
  int iterationCount = 1;
  while(iterationCount < 500){
    if(iterationCount%2 == 1){stroke(0);}    //switches between black and white lines with each iteration
    else{stroke(255);}                       
    float randX = random(0, width);          //selects random coordinates
    float randY = random(0, height);
    lineDown(randX);                         //draws lines at those coordinates
    lineCross(randY);
    iterationCount++;                        //increment the iteration count (which affects
                                             //the start/stop of the function as well as the color of lines)
  }
  
}


//======================================================================================================================================================
//======================================================================================================================================================
//Setup and Initialization

void setup() {
  size(400, 400);
  background(255);
  frameRate = 10;
}


//======================================================================================================================================================
//======================================================================================================================================================
//Drawing Execution

void draw() {
  if(frameCount%10 == 0){
    //create a new piece every 10 frames
    background(0);
    makeArt();
    
    //this bit below puts the word "art" at the center of the screen in alternating colors
    textSize(80);
    if(frameCount%100 <50){
      fill(0);}
     else{fill(255);}
    textAlign(CENTER);
    text("art.",width/2,height/2);
  }
}
