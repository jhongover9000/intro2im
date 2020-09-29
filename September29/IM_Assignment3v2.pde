//IM Assignment 3: OOP Game/Art
//Joseph Hong
//Description: This is a fun little game where you shoot orbs to pop the ones at the top of the screen. If colors match,
//             orbs adjacent to the orb hit will also pop. You can adjust aim and speed with the location of your mouse
//             (further from the orb = faster). The game ends when you pop all of the orbs.
//===================================================================================================================================
//===================================================================================================================================
//Imports
import java.util.ArrayList;    //for the size-changing array
import java.util.Random;       //for selecting a random integer (as opposed to a float)

//===================================================================================================================================
//===================================================================================================================================
//Global Variables

//screen dimensions (need to change on the setup function if you change these; they're only for the class creation)
int screenWidth = 300;
int screenHeight = 300;

int orbSize = 15;      //size of orbs
int startRowNum = 3;    //number of rows of orbs at the start

color[] colors = {color(255, 200, 200), color(200, 255, 200), color(200, 200, 255)};  //set of colors to choose from (for orbs)

//Random Integer Generator
Random rand = new Random();

//===================================================================================================================================
//===================================================================================================================================
//Class Building

//orbs in game
class Orb {
  //data: radius of orbs, location, velocity, and color
  int radius = orbSize;
  int x;                  
  int y;
  int vx;
  int vy;
  color c;


  //statuses: hidden (for when orbs have been popped), moving (for when an orb is shot from the bottom)
  boolean hidden = false;
  boolean moving = false;

  
  //Constructor
  Orb(int x, int y, int vx, int vy, color c) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.c = c;
  }

  //Update
  void update() {
    //bounce off of boundaries
    if (x + orbSize > screenWidth || x - orbSize < 0) {
      vx*=-1;
    } else if (y + orbSize > screenHeight || y - orbSize < 0) {
      vy*=-1;
    }
    //update velocities
    x += vx;
    y += vy;
  }


  //Display
  void display() {
    //if not popped, display orb with color
    if (!hidden) {
      stroke(100);
      fill(c);
      ellipse(x, y, 2*radius, 2*radius);
    }
  }
}


//Group of orbs that are still (at the top of screen)
class StillOrbs {
  //array of orbs at the top of screen
  ArrayList<Orb> orbList = new ArrayList<Orb>();
  
  //Constructor
  StillOrbs() {
    int tempX = orbSize;
    int tempY = orbSize;
    
    //places orbs in rows relative to screen width, uses the startRowNum to determine how many rows of orbs to put
    while (tempY <= orbSize + (startRowNum-1)*orbSize*2) {
      Orb tempObj = new Orb(tempX, tempY, 0, 0, colors[rand.nextInt(3)]);
      orbList.add(tempObj);
      tempX += (orbSize*2);
      if (tempX + orbSize > screenWidth) {
        tempX = orbSize;
        tempY += (orbSize*2);
      }
    }
  }
  
  //Getter
  ArrayList<Orb> getList() {
    return orbList;
  }

  //Empty update function (for the sake of simplifying coding for the Game object)
  void update() {
  }
  
  
  //Display each orb in the array
  void display() {
    for (Orb i : orbList) {
      i.display();
    }
  }
}


//Class for entire game
class Game {
  StillOrbs topField = new StillOrbs();  //array of orbs
  Orb bottomField = new Orb(screenWidth/2, screenHeight-orbSize, 0, 0, colors[rand.nextInt(3)]);  //starting orb (shooting one)
  int points = 0;    //point counter
  boolean finished = false;    //determine whether game is in play or not

  //Update (this part is the complicated part)
  void update() {
    //iterates through the orbs at the top and checks if the player's orb has hit them and pops according to conditions & gives points
    for (int i = 0; i < topField.getList().size(); i++) {
      //if the colors don't match and an orb is hit (calculated through Pythagorean Theorem), no orbs are popped and the player's orb resets
      if ((int(topField.getList().get(i).x - bottomField.x)*int(topField.getList().get(i).x - bottomField.x) + int(topField.getList().get(i).y - bottomField.y)* int(topField.getList().get(i).y - bottomField.y) <= 4*orbSize*orbSize ) && (!topField.getList().get(i).hidden) && topField.getList().get(i).c != bottomField.c) {
        bottomField.moving = false;
        bottomField.vx = bottomField.vy = 0;
        bottomField.x = screenWidth/2;
        bottomField.y = screenHeight-orbSize;
        bottomField.c = colors[rand.nextInt(3)];
      } 
      //if the colors match and the player's orb hits a passive orb (calculated through Pythagorean Theorem), then the conditions are looked through while the player's orb is reset
      else if ((int(topField.getList().get(i).x - bottomField.x)*int(topField.getList().get(i).x - bottomField.x) + int(topField.getList().get(i).y - bottomField.y)* int(topField.getList().get(i).y - bottomField.y) <= 4*orbSize*orbSize ) && (!topField.getList().get(i).hidden) && (topField.getList().get(i).c == bottomField.c)) {
        bottomField.moving = false;
        bottomField.vx = bottomField.vy = 0;
        bottomField.x = screenWidth/2;
        bottomField.y = screenHeight-orbSize;
        bottomField.c = colors[rand.nextInt(3)];
        
        //condition 1: if the passive orb that got hit is in the middle (not the two sides of the screen), it is popped and the adjacent
        //orbs are checked (whether they have the same color). If they meet those conditions, and are not yet popped, then they are
        //hidden and points are rewarded to the player for each orb that is popped (hidden).
        if (topField.getList().get(i).x > orbSize && topField.getList().get(i).x < screenWidth - orbSize) {
          topField.getList().get(i).hidden = true;
          points++;
          if (topField.getList().get(i-1).c == topField.getList().get(i).c && !topField.getList().get(i-1).hidden) {
            topField.getList().get(i-1).hidden = true;
            points++;
          }
          if (topField.getList().get(i+1).c == topField.getList().get(i).c && !topField.getList().get(i+1).hidden) {
            topField.getList().get(i+1).hidden = true;
            points++;
          }
          if (topField.getList().get(i).y > orbSize) {  //this is to check if there's a row above (for adjacent top orb)
            if (topField.getList().get(i-screenWidth/(orbSize*2)).c == topField.getList().get(i).c && !topField.getList().get(i-screenWidth/(orbSize*2)).hidden) {
              topField.getList().get(i-screenWidth/(orbSize*2)).hidden = true;
              points++;
            }
          }
        } 
        
        //condition 2: if the passive orb that got hit is located on the far left of the screen, then only the adjacent top and right
        //orbs are checked (since the left is not actually the left, as all the orbs are in a list)
        else if (topField.getList().get(i).x == orbSize) {
          topField.getList().get(i).hidden = true;
          points++;
          if (topField.getList().get(i+1).c == topField.getList().get(i).c && !topField.getList().get(i+1).hidden) {
            topField.getList().get(i+1).hidden = true;
            points++;
          }
          if (topField.getList().get(i).y > orbSize) {
            if (topField.getList().get(i-screenWidth/(orbSize*2)).c == topField.getList().get(i).c && !topField.getList().get(i-screenWidth/(orbSize*2)).hidden) {
              topField.getList().get(i-screenWidth/(orbSize*2)).hidden = true;
              points++;
            }
          }
        } 
        
        //condition 3: if the passive orb that got hit is located on the far right of the screen, then only the adjacent top and left
        //orbs are checked (since the right is not actually the right, as all the orbs are in a list)
        else if (topField.getList().get(i).x == screenWidth - orbSize) {
          topField.getList().get(i).hidden = true;
          points++;
          if (topField.getList().get(i-1).c == topField.getList().get(i).c && !topField.getList().get(i-1).hidden) {
            topField.getList().get(i-1).hidden = true;
            points++;
          }
          if (topField.getList().get(i).y > orbSize) {
            if (topField.getList().get(i-screenWidth/(orbSize*2)).c == topField.getList().get(i).c && !topField.getList().get(i-screenWidth/(orbSize*2)).hidden) {
              topField.getList().get(i-screenWidth/(orbSize*2)).hidden = true;
              points++;
            }
          }
        }
      }

    }
    
    //end game if all orbs are hidden
    if (points == topField.getList().size()) {    
      finished = true;
    }
    
    //update both objects in class
    topField.update();
    bottomField.update();
  }
  
  //Display
  void display() {
    topField.display();
    bottomField.display();
  }
}


//===================================================================================================================================
//===================================================================================================================================
//Initialization

//Game Creation
Game game = new Game();

//Setup
void setup() {
  size(300, 300);
  frameRate(20);
}


//===================================================================================================================================
//===================================================================================================================================
//Program Execution

//Draw
void draw() {
  //While the game is not finished, the program will continue to update and display the game
  if(!game.finished){
    background(255);
    game.update();
    game.display();
    fill(0);
    textSize(10);
    textAlign(LEFT);
    text("Points:" + String.valueOf(game.points), orbSize, screenHeight - orbSize);
  }
  //if the game ended, then the game will display that the player has won.
  else{
    background(255);
    stroke(0);
    textSize(40);
    textAlign(CENTER);
    text("You Win!\n" + "Score: " + String.valueOf(game.points), screenWidth/2, screenHeight/2 - orbSize);
  }
}

void mouseClicked() {
  //This bit maps the location of the mouse to the velocity of the player's orb when it's shot.
  if (!game.bottomField.moving) {
    game.bottomField.moving = true;
    if (mouseX < screenWidth/2) {
      game.bottomField.vx = (int)map(mouseX, screenWidth/2, 0, 0, -10);
      print(game.bottomField.vx);
    } else if (mouseX > screenWidth/2) {
      game.bottomField.vx = (int)map(mouseX, screenWidth/2, screenWidth, 0, 10);
    } else if (mouseX == screenWidth/2) {
      game.bottomField.vx = 0;
    }
    game.bottomField.vy = (int)map(mouseY, screenHeight, screenHeight/2, 0, -10);
  }
  //When the orb is moving (and you know it's not gonna be a good hit), you can reset the orb by clicking it again.
  else{
    game.bottomField.moving = false;
    game.bottomField.vx = game.bottomField.vy = 0;
    game.bottomField.x = screenWidth/2;
    game.bottomField.y = screenHeight-orbSize;
    game.bottomField.c = colors[rand.nextInt(3)];
  }
}



