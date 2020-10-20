//IM Assignment 6 (Midterm): A Game.
//Joseph Hong
//Description:
//
//=======================================================================================================================
//=======================================================================================================================
//Imports
import java.util.ArrayList;    //for the size-changing array
import java.util.Random;       //for selecting a random integer (as opposed to a float)
import java.io.File;

//=======================================================================================================================
//=======================================================================================================================
//Global Variables & Setup

String cmd = System.getProperty("user.dir");


int screenWidth = 1080;
int screenHeight = 720;

int ground = 500;

CharacterFile krt = new CharacterFile("kirito", 44, 0);
Player player = new Player();

void setup() {
  size(1200, 800);
  frameRate(30);
  loadImages(krt);
  player.linkImageSets(krt);
}

//=======================================================================================================================
//=======================================================================================================================
//Images

//function used to load images (given a character name, index in image array, identifier of first image, 
void loadImages(CharacterFile characterName) {

  for (int i = 0; i < characterName.numImages; i++) {
    String numBuffer;        //to match the image identifier
    if (i > 9) {
      numBuffer = "0";
    } else if (i > 99) {
      numBuffer = "";
    } else {
      numBuffer = "00";
    }
    PImage p = loadImage(characterName.name + numBuffer + String.valueOf(i) + ".png");
    characterName.moveSets.add(p);
  }
}

//=======================================================================================================================
//=======================================================================================================================
//Classes


//Overall Entities (Basically All Objects On-Screen)
class Entity {
  float locX = 900;
  float locY = 450;
  float velX;  
  float velY;

  PImage img;

  int imgHeight;
  int imgWidth;

  int dir = 1;    //direction (-1 means facing left)
  boolean still;      //still, as opposed to moving (walking)

  boolean gravity() {
    if (locY + imgHeight/2 < ground) {
      velY += 0.3;
    } else if (locY + imgHeight/2 >= ground) {
      velY = ground - (locY + imgHeight);
      if (locY + imgHeight/2 > ground) {
        velY = ground - (locY + imgHeight);
      }
    }
    if (locY + imgHeight == ground) {
      return true;
    } else {
      return false;
    }
  }

  void update() {
    locX += velX;
    locY += velY;
  }
}

//Player Class
class Player extends Entity {

  //Stores images for character
  ArrayList<PImage> moveSets;
  ArrayList<PImage> moveSetsExtra;
  int moveIndexStart;
  int moveIndexStop;
  float moveFramePoint;      //This is the variable that stores the decimal values (for adjusting frame speed)
  float moveFrameIncrementor;
  int moveFrame;
  int imgHeight = 345;
  int imgWidth = 500;

  //When standing
  Tuple still = new Tuple(0, 7);
  Tuple normalATK = new Tuple(8, 11);
  Tuple burstATK = new Tuple(12, 17);
  Tuple knockbackATK = new Tuple(18, 24);
  Tuple walk = new Tuple(25, 29);
  Tuple guard = new Tuple(30, 32);
  Tuple guardTransition = new Tuple(33, 36);
  //When crouching
  Tuple crouchStill = new Tuple(10, 11);
  Tuple crouchATK = new Tuple(10, 11);
  Tuple crouchGuard = new Tuple(10, 11);
  //When jumping
  Tuple jump = new Tuple(37, 43);
  //When hit
  Tuple hit = new Tuple(10, 11);

  //Stats
  int currentLevel;
  float maxHP;          //total health points
  float currentHP;        //current health points
  float maxDamage;        //initial damage points (before level multipliers)
  float currentDamage;      //current damage points
  float maxMP;
  float currentMP;

  //These three are the present "position" booleans
  boolean isStanding = true;       //check if standing
  boolean isCrouching = false;      //check if crouching
  boolean isJumping = false;        //check if jumping

  //These three are the past "position" booleans
  boolean wasStanding = false;
  boolean wasCrouching = false;
  boolean wasJumping = false;

  //Each position boolean has three present "action" booleans. If all three are false, the player is still
  boolean isAttacking = false;     //attacking or not
  boolean isGuarding = false;      //guarding (reduce damage taken)
  boolean isWalking = false;     //walking or not

  //Each position boolean has three past "action" booleans
  boolean wasAttacking = false;
  boolean wasGuarding = false;
  boolean wasWalking = false;

  //Check if player is transitioning from one move to another (only for certain ones)
  boolean isTransitioning = false;

  //Attack type
  int attackType;

  //Getting hit will override all movements and send through hit animation
  boolean isHit = false;
  int hitCounter = 0;

  //when initializing the character, use to link the image arrays to the character
  void linkImageSets(CharacterFile characterName) {
    this.moveSets = characterName.moveSets;
    this.moveSetsExtra = characterName.moveSetsExtra;
  }

  //Set all current positions to false (usually followed by setting one position to true)
  void setCurrentPosFalse() {
    isStanding = false;
    isCrouching = false;
    isJumping = false;
  }

  //Set all current positions to false (usually followed by setting one position to true)
  void setPastPosFalse() {
    wasStanding = false;
    wasCrouching = false;
    wasJumping = false;
  }

  //Set all current actions to false (usually followed by setting one action to true)
  void setCurrentActionFalse() {
    isAttacking = false;
    isGuarding = false;
    isWalking = false;
  }

  //Set all past actions to false (usually followed by setting one action to true)
  void setPastActionFalse() {
    wasAttacking = false;
    wasGuarding = false;
    wasWalking = false;
  }

  //reset all current positions/actions
  void resetCurrent() {
    setCurrentPosFalse();
    setCurrentActionFalse();
  }

  //reset all past positions/actions
  void resetPast() {
    setPastPosFalse();
    setPastActionFalse();
  }

  //Checks the amount of health left and displays it
  void checkHealth() {
    //Tint the screen red when health is below 10%?
  }

  //Change move set and player image frame count
  void changeMoveSet(Tuple moveParameters, float moveFrameIncrementor) {
    this.moveFrame = 0;
    this.moveFramePoint = 0;
    this.moveFrameIncrementor = moveFrameIncrementor;
    this.moveIndexStart = moveParameters.x;
    this.moveIndexStop = moveParameters.y;
  }

  void transitionSet() {
    //if passive before, change move set to the transition. while wasStill is true, keep adding frames
    //once the frames have all gone through, then change the moveset to the actual guarding
  }

  void attack() {
    //divided into 3 attacks and 1 special move. check which one it is. if crouching only 1 works,
    //if jumping, cannot attack.
  }

  //check whether the move set has been completed (for attacking, jumping)
  boolean moveSetComplete(){
    if(moveFramePoint + moveIndexStart >= moveIndexStop){
    return true;
    }else{return false;}
  }

  void updateLastAction() {
    //Update true position booleans
    if (isStanding) {
      wasStanding = true;
    } else {
      wasStanding = false;
    }
    if (isCrouching) {
      wasCrouching = true;
    } else {
      wasCrouching = false;
    }
    if (isJumping) {
      wasJumping = true;
    } else {
      wasJumping = false;
    }
    //Update true action booleans
    if (isAttacking) {
      wasAttacking = true;
    } else {
      wasAttacking = false;
    }
    if (isGuarding) {
      wasGuarding = true;
    } else {
      wasGuarding = false;
    }
    if (isWalking) {
      wasWalking = true;
    } else {
      wasWalking = false;
    }
  }

  //returns a value to see if player's last action was still
  boolean wasStill() {
    if (!wasAttacking && !wasGuarding && !wasJumping && !wasWalking) {
      return true;
    } else {
      return false;
    }
  }


  void update() {

    //Update player gravity
    gravity();

    //Otherwise, check for the changed command. Keypressed will ensure that only one current position
    //and movement will be set as true.    
    if (!isHit) {
      
      //Jumping
      if (isJumping) {
        //If the player just started jumping
        if (!wasJumping) {
          changeMoveSet(jump, 0.3);
          velY = -7;
        }
        //If player is in the process of jumping
        else {
          //If rising up
          if (velY <= 0) {
            if (moveFramePoint >= 2) {
              moveFrameIncrementor = 0;
              moveFramePoint = 2;
            }
          }
          //If falling down
          else if (velY > 0) {
            moveFrameIncrementor = 0.2;
            if (moveFramePoint > 6) {
              moveFrameIncrementor = 0;
              moveFramePoint = 6;
            }
          }
          //If hitting the ground, automatically go into still mode
          if (moveSetComplete()) {
            changeMoveSet(still, 0.4);
            isJumping = false;
            wasJumping = false;
            isStanding = true;
          }
          //moveFrame += moveFrameIncrementor;
        }
      }

      //Standing
      else if (isStanding) {

        //if walking
        if (isWalking) {
          if (!wasWalking) {
            changeMoveSet(walk, 0.3);
          }
          velX = dir*7;
        }//if walking end

        //if attacking
        else if (isAttacking) {

          if (!wasAttacking) {
            if (attackType == 0) {
              changeMoveSet(normalATK, 0.3);
            } else if (attackType == 1) {
              changeMoveSet(burstATK, 0.3);
            } else {
              changeMoveSet(knockbackATK, 0.3);
            }
            moveFrameIncrementor = 0.3;
          }
        }//if attacking end

        //if guarding
        else if (isGuarding) {

          if (!wasGuarding) {
            changeMoveSet(guard, 0.6);
            velX = 0;
          } else {
            if (moveFramePoint >= 2) {
              moveFrameIncrementor = 0;
              moveFramePoint = 2;
            }
          }
        }//if guarding end

        //if still
        else {
          velX = 0;
          //if coming out of guarding or standing up, undergo transition set before still
          if (isTransitioning || wasCrouching || wasGuarding) {
            isTransitioning = true;
            wasCrouching = false;
            wasGuarding = false;
            //go backwards in frames
            if (moveFrame > 0) {
              moveFrameIncrementor = -0.6;
            } 
            //when frames hit 0, change to still
            else if (moveFrame <= 0) {
              changeMoveSet(still, 0.4);
              isTransitioning = false;
            }
          }
          //else, just transition to still (after attack/jump)
          else {
            //check if player was still in previous frame; if not, change the moveset
            if ( !wasStill() || !wasStanding ) {
              changeMoveSet(still, 0.4);
              //reset all past positions/actions and only set wasStanding to true
              setPastActionFalse();
              wasStanding = true;
            }
          }
        }//Still End
      }//Standing End

      //Crouching
      else if (isCrouching) {
      }  //Crouching End
    }  //If not hit End


    //If Hit
    else {
      gravity();
    }

    //Update past position and action
    updateLastAction();

    //Update location and velocity (keep player from going out of bounds)
    if (locX - imgWidth/4 < 0 && dir == -1) {
      velX = 0;
    }
    locX += velX;
    locY += velY;  


    //Increment frame
    moveFramePoint += moveFrameIncrementor;
    print("\n moveframe: " + moveFrame);
    print("\n moveframestart: " + moveIndexStart);
    print("\n moveframestop: " + moveIndexStop);
    moveFrame = (int) moveFramePoint % (moveIndexStop - moveIndexStart + 1);

    //Select image for display
    img = moveSets.get( (moveIndexStart + moveFrame) );
    print("\n moveframe: " + (moveIndexStart + moveFrame) );
  }//end update

  void display() {
    imageMode(CENTER);
    if (dir == 1) {
      image(img, locX, locY, imgWidth, imgHeight);
    } else {
      image(img, locX, locY, imgWidth, imgHeight, 928, 0, 0, 640);
    }
  }

  //void display() {
  //}//end display
}

//Enemy Class
class Enemy extends Player {
}

//Game Class
class Game {
}

//Pair Class (for pairing elements)
class Tuple {
  final int x;
  final int y;
  Tuple(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

//Character File Class (for setup)
class CharacterFile {
  //Used as identifier for image loading
  String name;
  //Number of images associated with character (normal)
  int numImages;
  //Number of images associated with character (extra)
  int numImagesExtra;
  //Array of all in-game movesets for character
  ArrayList<PImage> moveSets = new ArrayList<PImage>();
  //Array of all pre-game movesets for character
  ArrayList<PImage> moveSetsExtra = new ArrayList<PImage>();

  CharacterFile(String name, int numImages, int numImagesExtra) {
    this.name = name;
    this.numImages = numImages;
    this.numImagesExtra = numImagesExtra;
  }
}

//===================================================================================================================
//===================================================================================================================
//Functions



//===================================================================================================================
//===================================================================================================================
//Game Execution

void draw() {
  background(0);
  player.update();
  player.display();
}

//keypressed
//need to make isAttacking true while the frames are in motion (hence while moveFrames <= (Tuple.x-Tuple.y) )
void keyPressed() {
  //down (D)
  if (keyCode == 83) {
    player.isWalking = false;
    player.isGuarding = true;
  }
  //up (W)
  else if (keyCode == 87) {
    if (!player.wasJumping) {
      player.isJumping = true;
    }
  }
  //left (A)
  else if (keyCode == 65) {
    if(!player.isGuarding){
      player.isWalking = true;
      player.dir = -1;
    }
  }
  //right (D)
  else if (keyCode == 68) {
    if (!player.isGuarding){
    player.isWalking = true;
    player.dir = 1;
    }
  }
}

void keyReleased() {

  //down (D)
  if (keyCode == 83) {
    player.isGuarding = false;
  }
  //up (W)
  else if (keyCode == 87) {
  }
  //left (A)
  else if (keyCode == 65) {
    player.isWalking = false;
  }
  //right (D)
  else if (keyCode == 68) {
    player.isWalking = false;
  }
}
