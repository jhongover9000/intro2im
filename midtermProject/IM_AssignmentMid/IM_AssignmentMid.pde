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

int ground = screenHeight - 100;


void setup() {
	size(1200, 800);
}

//=======================================================================================================================
//=======================================================================================================================
//Images

//function used to load images (given a character name, index in image array, identifier of first image, 
void loadImages(CharacterFile characterName) {

  for (int i = 0; i <= moveSetCount; i++) {
    String numBuffer;        //to match the image identifier
    if (i > 9) {
      numBuffer = "00";
    } else if (i > 99) {
      numBuffer = "0";
    } else {numBuffer = "";}
    PImage p = loadImage(cmd + "/" + characterName.name + "/" + numBuffer + String.valueOf(i));
    characterName.get(moveSetIndex).add(moveSetIndex, p);
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

	float imgHeight;
	float imgWidth;
	
	int dir = 1;    //direction (-1 means facing left)
	boolean still;      //still, as opposed to moving (walking)

	void gravity() {
		if (locY > ground) {
		}
	}

	void update() {
		locX += velX;
		locY += velY;
	}

	void display(){
		update();
		imageMode(CENTER);
		if(dir == 1){
			image(img, locX, locY, imgWidth, imgHeight);
		}
		else{
			image(img, locX, locY, imgWidth, imgHeight, imgWidth, 0, 0, imgHeight)
		}
	}
}

//Player Class
class Player extends Entity {

	//Stores images for character
    ArrayList<PImage> moveSets;
    ArrayList<PImage> moveSetsExtra;
    int moveIndexStart;
    int moveIndexStop;
    float moveFramePoint;			//This is the variable that stores the decimal values (for adjusting frame speed)
    float moveFrameIncrementor;
    int moveFrame;
    
	//When standing
	Tuple still = new Tuple(0,7);
	Tuple normalATK = new Tuple(8,11);
	Tuple burstATK = new Tuple(12,17);
	Tuple knockbackATK = new Tuple(18,24);
	Tuple walk = new Tuple(25,29);
	Tuple guard = new Tuple(30,32);
	Tuple guardTransition = new Tuple(33,)
	//When crouching
	Tuple crouchStill = new Tuple(10,11);
	Tuple crouchATK = new Tuple();
	Tuple crouchGuard = new Tuple();
	//When jumping
	Tuple jump = new Tuple();
	//When hit
	Tuple hit = new Tuple();

	//Stats
	int currentLevel;
	float maxHP;          //total health points
	float currentHP;        //current health points
	float maxDamage;        //initial damage points (before level multipliers)
	float currentDamage;      //current damage points
	float maxMP;
	float currentMP;
    
    //These three are the present "position" booleans
	boolean isStanding;       //check if standing
    boolean isCrouching;      //check if crouching
	boolean isJumping;        //check if jumping

    //These three are the past "position" booleans
    boolean wasStanding;
    boolean wasCrouching;
    boolean wasJumping;

    //Each position boolean has three present "action" booleans. If all three are false, the player is still
	boolean isAttacking;     //attacking or not
	boolean isGuarding;      //guarding (reduce damage taken)
    boolean isWalking;		 //walking or not
    
    //Each position boolean has three past "action" booleans
    boolean wasAttacking;
    boolean wasGuarding;
    boolean wasWalking;

    //Attack type
    int attackType;
    
    //Getting hit will override all movements and send through hit animation
    boolean isHit = false;
    int hitCounter = 0;
    
    //when initializing the character, use to link the image arrays to the character
    void linkImageSets(CharacterFile characterName){
        this.moveSets = characterName.moveSets;
        this.moveSetsExtra = characterName.moveSetsExtra;
    }
    
    //Set all current statuses to false (usually followed by setting one status to true)
    void setCurrentStatusFalse(){
        isStanding = false;
        isCrouching = false;
        isJumping = false;
    }

    //Set all current statuses to false (usually followed by setting one status to true)
    void setPastStatusFalse(){
        wasStanding = false;
        wasCrouching = false;
        wasJumping = false;
    }

    //Checks the amount of health left and displays it
    void checkHealth(){
    	//Tint the screen red when health is below 10%?
    }

    //Change move set and player image frame count
    void changeMoveSet(Tuple moveParameters, float moveFrameIncrementor){
    	this.moveFrame = 0;
    	this.moveFramePoint = 0;
    	this.moveFrameIncrementor = moveFrameIncrementor;
    	this.moveIndexStart = moveParameters.x;
    	this.moveIndexStop = moveParameters.y;
    }

    void transitionSet(){
    	//if passive before, change move set to the transition. while wasStill is true, keep adding frames
    	//once the frames have all gone through, then change the moveset to the actual guarding
    }

    void attack(){
    	//divided into 3 attacks and 1 special move. check which one it is. if crouching only 1 works,
    	//if jumping, cannot attack.
    }

    void updateLastAction(){
    	//Update position booleans
    	if(isStanding){wasStanding == true;}
    	else if(isCrouching){wasCrouching == true;}
    	else if(isJumping){wasJumping == true;}
    	//Update action booleans
    	if(isAttacking){wasAttacking == true;}
    	else if(isGuarding){wasGuarding == true;}
    	else if(isWalking){wasGuarding == true;}
    }

    
	void update() {

		//Update player gravity
		gravity();

		//Otherwise, check for the changed command. Keypressed will ensure that only one current position
		//and movement will be set as true.		
		if(!isHit){
			//Jumping
			if (isJumping) {
				//If the player just started jumping
				if (!wasJumping){
					changeMoveSet(jump, 0.3);
					velY = -10;
				}
				//If player is in the process of jumping
				//jumping needs to make frames slow down as it reaches moveIndexStart+Stop/2 and then speed up
				//as the player reaches the ground (maybe link it to player velocity with mapping)
				else{
					//If rising up
					if(velY <= 0){
						moveFrame = (int)map(velY, -5, 0, 0, 2);
					}
					//If falling down
					else if (velY > 0){
						moveFrame = (int)map(velY, 0, 3, 3, 7);
					}
					//If hitting the ground, automatically go into still mode
					if ((ground - locY) == (ground - imgHeight/2)) {
						changeMoveSet(still, 0.4);
						isJumping = false;
						isStanding = true;
					}
					//moveFrame += moveFrameIncrementor;
				}
			}

			//Standing
			else if (isStanding) {

				//If walking
				if (isWalking){
					if(!wasWalking){
						changeMoveSet(walk);
						moveFrameIncrementor = 0.3;
					}
					velX = dir*3;
				}

				//if attacking
				else if (isAttacking) {

					if(!wasAttacking){
						if(attackType = 0){
							changeMoveSet(normalATK);
						}
						else if(attackType = 1){
							changeMoveSet(burstATK);
						}
						else{changeMoveSet(knockbackATK);}
						moveFrameIncrementor = 0.3;
					}

				}

				//if guarding
				else if(isGuarding){

					if(!wasGuarding){
						changeMoveSet(guard, 0.3);
					}

					if(moveFrame >= 2){
						moveFrame = 2;
					}

				}

				//if still
				else{

					if(wasCrouching){
						
					}


					//if coming out of guarding, undergo transition set (go backwards in frames) then become still
					else if(wasGuarding){
						if(moveFrame > 0){
							moveFrameIncrementor = -0.3;
						}
						else if(moveFrame == 0){
							changeMoveSet(still, 0.4);
						}
					}

					else{
						changeMoveSet(still, 0.4);
					}

				}

			} 

			//Crouching
			else if (isCrouching){

			}

		}

		
		//If Hit
		else{}
	
		//If the command from the keys hasn't changed, just keep going through the frames
		if(isJumping == wasJumping && isStanding == wasStanding && isCrouching == wasCrouching){
			if(isAttacking == wasAttacking && isGuarding == wasGuarding && isStill == wasStill){
				moveFrame++;
			}
		}	

		//Update past position and action
		updateLastAction();

		//Increment frame
		moveFramePoint += moveFrameIncrementor;
		moveFrame = (int)moveFramePoint;

		//Select image for display
		img = moveSets[moveIndexStart + moveFrame];
	}

	void display(){

	}

}

//Enemy Class
class Enemy extends Player {
}

//Game Class
class Game {
}

//Pair Class (for pairing elements)
class Tuple<ElementX, ElementY> {
	final X x;
	final Y y;
	Tuple(ElementX x, ElementY y) {
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
	ArrayList<PImage> moveSets;
	//Array of all pre-game movesets for character
	ArrayList<PImage> moveSetsExtra;

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


//keypressed
//need to make isAttacking true while the frames are in motion (hence while moveFrames <= (Tuple.x-Tuple.y) )
