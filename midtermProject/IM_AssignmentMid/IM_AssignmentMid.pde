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

//This method of retrieving the current directory doesn't work with processing
//String cmd = System.getProperty("user.dir");

//Random Integer Generator
Random rand = new Random();

int screenWidth = 720;
int screenHeight = 480;

int characterImageWidth = 300;
int characterImageHeight = 207;

int ground = 300;

CharacterFile krt = new CharacterFile("kirito", 60, 0);



ArrayList<CharacterFile> characters = new ArrayList<CharacterFile>();


Player player = new Player(characterImageWidth/2, characterImageHeight/2+ground);
Enemy enemy = new Enemy(characterImageWidth, characterImageHeight/2+ground, 2);

void setup() {
  size(720, 480);
  frameRate(30);
  loadImages(krt);
  characters.add(krt);
  player.linkImageSets(characters.get(0));
  enemy.linkImageSets(characters.get(0));
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
  float locX;
  float locY;
  float velX;  
  float velY;

  PImage img;

  int imgHeight;
  int imgWidth;

  int dir;            //direction

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
  String charName;
  int moveIndexStart;
  int moveIndexStop;
  float moveFramePoint;      //This is the variable that stores the decimal values (for adjusting frame speed)
  float moveFrameIncrementor;
  int moveFrame;
  int imgHeight = characterImageHeight;
  int imgWidth = characterImageWidth;

  //When standing
  Tuple still = new Tuple(0, 7);
  Tuple normalATK = new Tuple(8, 11);
  Tuple burstATK = new Tuple(12, 17);
  Tuple knockbackATK = new Tuple(18, 24);
  Tuple walk = new Tuple(25, 29);
  Tuple guard = new Tuple(30, 32);
  Tuple guardTransition = new Tuple(33, 36);
  //When crouching
  Tuple crouch = new Tuple(33, 36);
  Tuple crouchATK = new Tuple(44, 47);
  Tuple crouchGuard = new Tuple(48, 50);
  //When jumping
  Tuple jump = new Tuple(37, 43);
  //When hit
  Tuple hitStand = new Tuple(51, 54);
  Tuple hitJump = new Tuple(51, 54);
  Tuple hitCrouch = new Tuple(55, 59);

  //Stats
  float currentEXP = 0;
  float maxEXP = 10;
  int currentLevel = 1;
  float levelMultiplier = currentLevel * 0.1;
  float maxHP = 100*currentLevel;            //total health points
  float currentHP = maxHP;        //current health points
  float maxMP = 10*currentLevel;             //total mana points
  float currentMP = maxMP;         //current mana points
  float maxDP = 20*currentLevel;             //damage points
  int blockCount = 10;          //number of blocks (guards) available; refreshes on level up

  //Display
  String displayText = "";
  int displayCount = 0;

  //These three are the present "position" booleans
  boolean isStanding = true;       //check if standing
  boolean isCrouching = false;      //check if crouching
  boolean isJumping = false;        //check if jumping

  //These three are the past "position" booleans
  boolean wasStanding = false;
  boolean wasCrouching = false;
  boolean wasJumping = false;

  //Each position boolean has three present "action" booleans. If all three are false, the player is still.
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

  Player(int locX, int locY) {
    this.locX = locX;
    this.locY = locY;
    this.imgWidth = imgWidth;
    this.imgHeight = imgHeight;
  }

  //when initializing the character, use to link the image arrays to the character
  void linkImageSets(CharacterFile characterName) {
    this.moveSets = characterName.moveSets;
    this.moveSetsExtra = characterName.moveSetsExtra;
    this.charName = characterName.name;
  }

  //Display stats
  void statBar() {
    //Frame
    noStroke();
    fill(200);
    quad(0,0,200,0,160,50,0,50);
    
    //Name
    textAlign(RIGHT);
    stroke(0);
    textSize(20);
    text("YO",5,5);
    noStroke();

    //HP Bar
    fill(180);
    quad(5,15,180,15,180-10,25,5,25);
    if (currentHP/maxHP > 0.7) {
      fill(0, 220, 0);
    } else if (currentHP/maxHP > 0.3) {
      fill(220, 220, 0);
    } else if (currentHP/maxHP > 0) {
      fill(220, 30, 0);
    }
    quad(5,15,180*(currentHP/maxHP),15,180*(currentHP/maxHP)-10,25,5,25);

    //MP Bar
    fill(180);
    quad(5,30,160,30,160-5,35,5,35);
    fill(0, 130, 230);
    quad(5,30,160*(currentMP/maxMP),30,160*(currentMP/maxMP)-5,35,5,35);
    
    //EXP Bar
    fill(180);
    quad(5,40,150,40,145,42,5,42);
    fill(0, 180, 230);
    if(currentEXP > 0){
    quad(5,40,150*(currentEXP/maxEXP),40,145*(currentEXP/maxEXP)-5,42,5,42);
    }
  }

  //Checks the amount of health left and displays it
  void checkHealth() {
    //Tint the screen red when health is below 20%?
    if (currentHP/maxHP <= 0.2) {
      loadPixels();

      for (int i = 0; i < pixels.length; i++) {
        float r = red(pixels[i]);
        float g = green(pixels[i]);
        float b = blue(pixels[i]);

        //constrain size
        r = constrain(r, 0, 255);
        g = constrain(g, 0, 255);
        b = constrain(b, 0, 255);
        //tint screen
        pixels[i] = color(r + 10, g, b);
      }
    }
  }

  //Level Up!!
  void levelUp() {
    levelMultiplier = currentLevel * 0.1;
    currentLevel++;
    maxHP += 20*levelMultiplier;
    maxMP += 10*levelMultiplier;
    maxDP += 10*levelMultiplier;
    currentHP = maxHP;
    currentMP += 10;
    maxEXP = maxEXP*1.5;
    currentEXP = 0;
  }


  //Display notifier text (no MP, cannot use attack, etc.)
  void displayNotif(String notif) {
    displayText = notif;
    displayCount = 0;
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
  void setCurrentActionsFalse() {
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
    setCurrentActionsFalse();
  }

  //reset all past positions/actions
  void resetPast() {
    setPastPosFalse();
    setPastActionFalse();
  }

  //Change move set and player image frame count
  void changeMoveSet(Tuple moveParameters, float moveFrameIncrementor) {
    this.moveFrame = 0;
    this.moveFramePoint = 0;
    this.moveFrameIncrementor = moveFrameIncrementor;
    this.moveIndexStart = moveParameters.x;
    this.moveIndexStop = moveParameters.y;
  }

  //check whether the move set has been completed (for attacking, jumping)
  boolean moveSetComplete() {
    if (moveFramePoint + moveIndexStart >= moveIndexStop) {
      return true;
    } else {
      return false;
    }
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

  //returns a value to see if player's current action is still
  boolean isStill() {
    if (!isAttacking && !isGuarding && !isJumping && !isWalking) {
      return true;
    } else {
      return false;
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

  void updateLoc(){
     //Update location and velocity (keep player from going out of bounds)
    if (locX - imgWidth/4 < 0 && dir == -1) {
      velX = 0;
    }
    locX += velX;
    locY += velY;  
  }


  void update() {

    //Update player gravity
    gravity();

    //Otherwise, check for the changed command. Keypressed will ensure that only one current position
    //and movement will be set as true.    
    if (!isHit) {
      //If jumping
      if (isJumping) {

        //If player has started jumping
        if (isStanding && !isAttacking && !isGuarding) {
          isStanding = false;
          changeMoveSet(jump, 0.3);
          velY = -10;
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
          if (gravity()) {
            if (isWalking) {
              changeMoveSet(walk, 0.3);
            }
            isJumping = false;
            isStanding = true;
          }
        }
      }//jumping end

      else if (isCrouching && !wasCrouching) {
        velX = 0;
        isWalking = false;
        isCrouching = true;
        changeMoveSet(crouch, 0.2);
      }

      //If attacking
      else if (isAttacking) {

        //No movement
        velX = 0;

        //If player just started attacking
        if (!wasAttacking) {
          if (attackType == 0 && isStanding) {
            changeMoveSet(normalATK, 0.3);
          } else if (attackType == 0 && isCrouching) {
            changeMoveSet(crouchATK, 0.2);
          } else if (attackType > 0 && isCrouching) {
            displayNotif("Cannot Use Attack!");
          } else if (attackType == 1 && currentMP >= 5) {
            changeMoveSet(burstATK, 0.3);
            currentMP -= 5;
          } else if (attackType == 2 && currentMP >= 5) {
            changeMoveSet(knockbackATK, 0.3);
            currentMP -= 5;
          }
        }

        //Once moveset is complete, go back to still
        if (moveSetComplete()) {
          if (isWalking && isStanding) {
            changeMoveSet(walk, 0.3);
          }
          isAttacking = false;
        }
      }//end attacking

      //If walking
      else if (isWalking) {
        if (isStanding) {
          if (!wasWalking) {
            changeMoveSet(walk, 0.3);
          }
          velX = dir*7;
        }
      }//walking end

      //If guarding
      else if (isGuarding) {

        //No movement
        velX = 0;

        //If starting to guard
        if (!wasGuarding) {
          if (isStanding) {
            changeMoveSet(guard, 0.6);
          } else if (isCrouching) {
            changeMoveSet(crouchGuard, 0.3);
          }
        }

        //Keeps player in 'blocking' frame
        if (moveFramePoint >= 2) {
          moveFrameIncrementor = 0;
          moveFramePoint = 2;
        }
      }//guarding end

      //If still
      if (isStill()) {
        //No movement
        velX = 0;

        //If standing
        if (isStanding) {
          //if coming out of guarding or standing up, undergo transition animation
          if (isTransitioning || wasCrouching || wasGuarding) {
            //This value doesn't affect anything else, which makes it useful in tracking if a transition is happening
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
            }
          }
        }

        //If crouching
        else if (isCrouching) {
          //If coming out of guarding, undergo transition animation
          if (wasGuarding|| isTransitioning) {
            //This value doesn't affect anything else, which makes it useful in tracking if a transition is happening
            isTransitioning = true;
            wasGuarding = false;
            //go backwards in frames
            if (moveFrame > 0) {
              moveFrameIncrementor = -0.1;
            }
            //when frames hit 0, change to still
            else if (moveFrame < 0.5) {
              changeMoveSet(crouch, 0.2);
              moveFramePoint = 2;
              isTransitioning = false;
            }
          } else if (wasAttacking && !isAttacking) {
            changeMoveSet(crouch, 0.2);
            moveFramePoint = 2;
          } else if (!wasCrouching) {
            changeMoveSet(crouch, 0.2);
          }
          //This makes the player stay in the 'crouch' frame until mouse button is released
          else {
            if (moveFramePoint > 3.8) {
              moveFrameIncrementor = 0.05;
              moveFrameIncrementor *= -1;
            }
            if (moveFramePoint < 2.1 && moveFrameIncrementor < 0) {
              moveFrameIncrementor *= -1;
            }
          }
        }
      }//still end
    }  //If not hit End


    //If Hit (when not guarding)
    else {

      //Reset all actions
      if (hitCounter == 0) {
        if (isStanding) {
          velX = -1*dir;
          setCurrentActionsFalse();
          isStanding = true;
          changeMoveSet(hitStand, 0.2);
        } else if (isCrouching) {
          velX = -1*dir;
          setCurrentActionsFalse();
          isCrouching = true;
          changeMoveSet(hitCrouch, 0.2);
        } else if (isJumping) {
          velX = -1*dir;
          isJumping = true;
          changeMoveSet(hitJump, 0.2);
        }
      }
      //If jumping, stay hit until hitting the ground. Else, wait until animation is complete.
      if (isJumping) {
        if (gravity()) {
          velX = 0;
          changeMoveSet(still, 0.4);
          resetCurrent();
          isStanding = true;
          isHit = false;
          hitCounter = 0;
        }
      } else if (moveSetComplete()) {
        if (isStanding) {
          changeMoveSet(still, 0.4);
          isHit = false;
          hitCounter = 0;
        } else if (isCrouching) {
          changeMoveSet(crouch, 0.2);
          moveFramePoint = 3;
          isHit = false;
          hitCounter = 0;
        }
      } else {
        hitCounter++;
      }
    }

    //Update past position and action
    updateLastAction();

    updateLoc();


    //Increment frame
    moveFramePoint += moveFrameIncrementor;
    moveFrame = (int) moveFramePoint % (moveIndexStop - moveIndexStart + 1);

    //Select image for display
    img = moveSets.get( (moveIndexStart + moveFrame) );
  }//end update

  void display() {
    //print("\n Frame Start: " + moveIndexStart + "    Frame Stop: " + moveIndexStop);
    //print("\n Frame: " + moveFrame + "    Frame Inc: " + moveFrameIncrementor);
    //print("\n isWalking: " + isWalking + "    wasWalking: " + wasWalking + "\n isJumping: " + isJumping + "    wasJumping: " + wasJumping +
    //  "\n isStill(): " + isStill() +"    wasStill(): " + wasStill() + "\n isAttacking: " + isAttacking + "    wasAttacking: "
    //  + wasAttacking + "\n isStanding: " + isStanding + "    wasStanding: " + wasStanding);
    imageMode(CENTER);
    if (dir == 1) {
      image(img, locX, locY, imgWidth, imgHeight);
    } else {
      image(img, locX, locY, imgWidth, imgHeight, 928, 0, 0, 640);
    }

    //Display HUD
    statBar();

    //Display notifications (if exist)
    if (displayText != "") {
      if (displayCount < 20) {
        stroke(255);
        textSize(16);
        textAlign(CENTER);
        if (isCrouching) {
          text(displayText, locX, locY - imgHeight/6);
        } else {
          text(displayText, locX, locY - imgHeight/4);
        }
        displayCount++;
      } else {
        displayText = "";
      }
    }
  }//end display
}

//Enemy Class
class Enemy extends Player {

  //This number decides which function is called (which move)
  int completeCount;

  //Constructor (location, image size, level)
  public Enemy(int locX, int locY, int level) {
    super(locX, locY);
    this.locX = locX;
    this.locY = locY;
    this.currentLevel = level;
  }

  //Show health bar


  //Distance between player
  float distance(Player player) {
    return abs(player.locX - locX);
  }

  //Distance between ally
  float distanceAlly(Enemy ally) {
    return abs(ally.locX - locX);
  }

  //Jump
  void jump() {
    isJumping = true;
  }

  //Crouch
  void crouch() {
    isCrouching = true;
  }

  //Walk Left
  void walkLeft() {
    isWalking = true;
    dir = -1;
  }

  //Walk Right
  void walkRight() {
    isWalking = true;
    dir = 1;
  }

  //Stop Walking
  void stopWalking() {
    isWalking = false;
    velX = 0;
  }

  //Attack (given type argument)
  void attack(int attackType) {
    isAttacking = true;
    this.attackType = attackType;
  }

  //Guard
  void guard() {
    isGuarding = true;
  }

  //Stop guarding
  void stopGuard() {
    isGuarding = false;
  }

  //Update location of enemy
  void updateLoc(){
    locX += velX/2;
    locY += velY;  
  }

  void enemyUpdate(Stage stage) {

    //Always face player
    if (player.locX > locX) {
      dir = 1;
    } else if (player.locX < locX) {
      dir = -1;
    }

    //If player is not in hitting range, walk towards player. Jump if player is jumping.
    if (distance(player) >= imgWidth/2) {
      if (isGuarding) {
        stopGuard();
      }
      if (frameCount%180 == 30) {
        attack(1);
      } else
        if (player.locX > locX) {
          walkRight();
        } else if (player.locX < locX) {
          walkLeft();
        }
      if (distance(player) < imgWidth && player.locY > locY) {
        jump();
      }
    }

    //Once in hitting range, select a move randomly
    else if (distance(player) < imgWidth/2) {
      if (moveSetComplete()) {
        completeCount++;
      }
      if (isWalking) {
        isWalking = false;
        changeMoveSet(still, 0.4);
      } else if ( completeCount > 30 ) {
        setCurrentActionsFalse();
        int diceRoll = rand.nextInt(6);
        if (diceRoll%3 == 0) {
          attack(0);
        } else if (diceRoll%2 == 1) {
          guard();
        }
        completeCount = 0;
      }
    }

    

    update();
    //locX -= stage.middleX;

    // print("\n Frame Start: " + moveIndexStart + "    Frame Stop: " + moveIndexStop );
    // print("\n Frame: " + moveFrame + "    Frame Inc: " + moveFrameIncrementor + "    Frame Point: " + moveFramePoint);
    // print("\n isWalking: " + isWalking + "    wasWalking: " + wasWalking + "\n isJumping: " + isJumping + "    wasJumping: " + wasJumping +
    //   "\n isStill(): " + isStill() +"    wasStill(): " + wasStill() + "\n isAttacking: " + isAttacking + "    wasAttacking: "
    //   + wasAttacking + "\n isStanding: " + isStanding + "    wasStanding: " + wasStanding + "\n isGuarding: " + isGuarding + "    wasGuarding: " + wasGuarding);
  }
}

//Stage Class
class Stage {
  int stageWidth = screenWidth*5;
  int stageHeight = screenHeight;
  int g = ground;
  int middleX = 0;
  int level;
  int bossStage = 0;          //
  boolean newStage = true;    //gets set to false when the stage starts

  Player player;

  //Store objects of flying objects, enemies, and backgrounds
  ArrayList<Entity> projectiles = new  ArrayList<Entity>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<PImage> background = new ArrayList<PImage>();

  Stage(int level, Player player, ArrayList<PImage> background, int bossStage) {
    this.level = level;
    this.player = player;
    this.background = background;
    this.bossStage = bossStage;
  }

  //Update
  void update() {
    if (newStage) {
      if (bossStage > 0) {
        stageWidth = screenWidth;
        Enemy boss = new Enemy(stageWidth/(stageWidth*5), ground, 20);
      }
      newStage = false;
    } else {
      //Every 100 counts, spawn a random enemy in a random location
      if (frameCount%100 == 0) {
        Enemy temp = new Enemy(rand.nextInt(stageWidth), ground + characterImageHeight/2, level);
        temp.linkImageSets(characters.get(rand.nextInt(characters.size())));
        enemies.add(temp);
      }
    }
  }

  //Display
  void display() {
  }
}

//Game Class
class Game {
  int gameState = 0;
  int middleX;

  Game() {

    //Menu
    if (gameState == 0) {
    }

    //Stage
    else if (gameState == 1) {
    }

    //Game Over
    else if (gameState == 2) {
    }
  }

  void update() {
  }
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
  enemy.enemyUpdate();
  enemy.display();
  player.update();
  player.display();
}

//keypressed
//need to make isAttacking true while the frames are in motion (hence while moveFrames <= (Tuple.x-Tuple.y) )
void keyPressed() {

  //down (D)
  if (keyCode == 83) {
    if (player.isStanding && (player.isStill() || player.wasStill() || player.wasWalking) ) {
      player.isCrouching = true;
      player.isStanding = false;
      
    }
  }

  //up (W)
  else if (keyCode == 87) {
    if (player.isStill() || player.wasWalking) {
      player.isJumping = true;
    }
  }

  //left (A)
  else if (keyCode == 65) {
    if (player.isStanding && !player.isCrouching && (player.isStill() || player.wasStill() || player.wasWalking) ) {
      player.isWalking = true;
      player.dir = -1;
    }
  }

  //right (D)
  else if (keyCode == 68) {
    if (player.isStanding && !player.isCrouching && (player.isStill() || player.wasStill() || player.wasWalking)) {
      player.isWalking = true;
      player.dir = 1;
    }
  }

  //burst attack (C)
  else if (keyCode == 88) {
    if (!player.isJumping && (player.isStill() || player.wasStill() || player.wasWalking) ) {
      player.isAttacking = true;
      player.attackType = 1;
    }
  }

  //knockback attack (V)
  else if (keyCode == 67) {
    if (!player.isJumping && (player.isStill() || player.wasStill() || player.wasWalking) ) {
      player.isAttacking = true;
      player.attackType = 2;
    }
  } else if (keyCode == 89) {
    player.isHit = true;
    player.currentHP -= 10;
  }
}

void keyReleased() {
  
  //down (S)
  if (keyCode == 83) {
    if(!player.isJumping || !player.wasJumping){
    player.isCrouching = false;
    if ((keyCode != 65 && keyCode != 68) && !player.wasJumping && !player.isAttacking || !player.wasAttacking) {
      player.isStanding = true;
    }
  }
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

void mouseClicked() {
  if (mouseButton == LEFT) {
    if (!player.isJumping && (player.isStill() || player.wasStill() || player.wasWalking || player.isCrouching) ) {
      player.isAttacking = true;
      player.attackType = 0;
    }
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    if (!player.isAttacking) {
      player.isWalking = false;
      player.isGuarding = true;
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
  } else if (mouseButton == RIGHT) {
    player.isGuarding = false;
  }
}
