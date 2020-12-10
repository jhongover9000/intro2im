/*Game*/
/*This is the overarching class that contains all of the stages.*/

//Game
class Game {
  int gameState = 0;

  //Setting main menu image
  int menuImageNum;
  PImage menuImage = new PImage();
  boolean newGame;
  int diffSelect;

  boolean newStage;
  int newStageCounter;
  int backgroundSet;

  KeyPad practiceKeyPad;
  Dial practiceDial;

  VaultStage vault;
  KeyPad keypad;

  int colorChange;              //alternates colors for background on game over
  boolean gameClear;


  Game() {
    this.gameState = 0;
    this.menuImageNum = 0;
    this.newGame = true;

    this.diffSelect = 0;

    this.newStage = true;
    this.newStageCounter = 0;
    this.backgroundSet = 0;

    practiceKeyPad = new KeyPad(3*screenWidth/4, 2*screenHeight/3, 50, 4);
    practiceDial = new Dial(0, 99, screenWidth/2, screenHeight/3, 300, 300);

    vault = new VaultStage();
    keypad = new KeyPad(3*screenWidth/4, 2*screenHeight/3, 50, keyPadLength);
  }

  void nthMenuButton(int n, int game, float firstButtonX1, float firstButtonX2, float firstButtonY1, float firstButtonY2, String word) {
    //Increment n times
    for (int i = 0; i < n; i++) {
      firstButtonY1 = firstButtonY2 + screenHeight/48;
      firstButtonY2 = firstButtonY1 + screenHeight/12;
    }

    if ( ( firstButtonX1 < mouseX && mouseX < firstButtonX2) && (firstButtonY1 < mouseY && mouseY < firstButtonY2) ) {
      fill(230);
      //If mouse is pressed while hovering over option, return gameState
      if (mouseReleased) {
        //Add sound effect of button being selected
        if (!button.isPlaying()) {
          button.play();
        }
        mouseReleased = false;
        gameState = game;
      }
    } else {
      fill(200);
    }
    rect(firstButtonX1, firstButtonY1, (firstButtonX2 - firstButtonX1), (firstButtonY2 - firstButtonY1) );
    textAlign(CENTER, CENTER);
    textFont(font);
    textSize(20);
    fill(100);
    text(word, firstButtonX1 + (firstButtonX2 - firstButtonX1)/2, firstButtonY1 + (firstButtonY2 - firstButtonY1)/2);

    //Stay in Main Menu if no option is selected
  }

  //Play Function
  void play() {

    //Music
    //Stop others, play right file
    if (gameState <= 2 && (newGame || !openingOST.isPlaying()) ) {
      if (victory.isPlaying()) {
        victory.stop();
      }
      if (defeat.isPlaying()) {
        defeat.stop();
      }
      if (!openingOST.isPlaying()) {
        openingOST.play();
        openingOST.amp(0.1);
      }
    }
    //Game (I want absolute silence, especially for the dial)
    else if ((2 < gameState && gameState < 9) && newStage) {
      if (victory.isPlaying()) {
        victory.stop();
      }
      if (defeat.isPlaying()) {
        defeat.stop();
      }
      if (openingOST.isPlaying()) {
        openingOST.stop();
      }
      //Game Over
      else if (gameState == 9 && !defeat.isPlaying()) {
        if (victory.isPlaying()) {
          victory.stop();
        }
        defeat.play();
        defeat.amp(0.1);
      }
      //Victory
      else if (gameState == 10 && !victory.isPlaying()) {
        if (defeat.isPlaying()) {
          defeat.stop();
        }
        victory.play();
        victory.amp(0.1);
      }
    }

    //Menu
    if (gameState == 0) {
      //Choose background for screen (random every 500 counts)
      if (newGame || frameCount%500 == 0) {
        menuImageNum = rand.nextInt(menuBackgrounds.size());
        menuImage = menuBackgrounds.get(menuImageNum);
        newGame = false;
      }
      imageMode(CENTER);
      image(menuImage, screenWidth/2, screenHeight/2, screenWidth, screenHeight);

      //Display Main Menu
      fill(230);
      rect(screenWidth/20, screenHeight/9, (5*screenWidth/12), screenHeight/6);
      textAlign(CENTER, CENTER);
      textSize(40);
      fill(100);
      text("the HEIST", screenWidth/20 + (5*screenWidth/12) / 2, screenHeight/9 + screenHeight/12 );

      //Set location of first button
      float firstButtonX1 = screenWidth/20;
      float firstButtonX2 = screenWidth/20 + screenWidth/4;
      float firstButtonY1 = screenHeight/2;
      float firstButtonY2 = screenHeight/2+screenHeight/12;

      //Start Game
      nthMenuButton(0, 5, firstButtonX1, firstButtonX2, firstButtonY1, firstButtonY2, "Depart");

      //Instructions
      nthMenuButton(1, 3, firstButtonX1, firstButtonX2, firstButtonY1, firstButtonY2, "Practice");

      //Exit
      nthMenuButton(2, 7, firstButtonX1, firstButtonX2, firstButtonY1, firstButtonY2, "Exit");

      //Change Background
      nthMenuButton(3, 6, firstButtonX1, firstButtonX2, firstButtonY1, firstButtonY2, "Change Background");
    }


    //Practice Selection Screen
    else if (gameState == 1) {
      //Display instructions
      background(0);
      textAlign(CENTER);
      textSize(32);
      fill(200);
      text("Instructions", screenWidth/2, screenHeight/8);
      textAlign(LEFT);
      textSize(12);
      text("Move around with WASD. \nGuard: Right Hold (Mouse)\n" +
        "Guard decreases damage received, and prevents player from flinching.\n\nNormal Attack: Left Click (Mouse)" +"Specials: require MP, but are stronger.\n" + 
        "Burst Attack: X (5 MP)   \nUltra Attack: C (10 MP)\n\nLevel up to increase and restore HP, MP, and Damage.\n\n" +
        "Press SPACE to go back to Main Menu.", screenWidth/20, screenHeight/4, screenWidth/3, screenHeight-screenHeight/12);
    }
    //Drill practice
    else if (gameState == 2) {
    }

    //Keypad practice 
    else if (gameState == 3) {
      myPort.write(3);
      if (newStage) {
        if (newStageCounter < 200) {
          background(0);
          textSize(32);
          textAlign(CENTER, CENTER);
          text("PROLOGUE: THE BASICS (2)", screenWidth/2, screenHeight/2);
          newStageCounter++;
        } else {
          keyPadLength = 4;
          newStageCounter = 0;
          newStage = false;
        }
      } else {
        background(240);
        practiceKeyPad.display();
      }
      //pause a moment before moving to next stage
      if (practiceKeyPad.isComplete) {
        if (newStageCounter < 50) {
          newStageCounter++;
        } else {
          newStageCounter = 0;
          gameState = 4;
        }
      }
    }

    //Vault practice
    else if (gameState == 4) {
      myPort.write(4);
      if (newStage) {
        if (newStageCounter < 200) {
          background(0);
          textSize(32);
          textAlign(CENTER, CENTER);
          text("PROLOGUE: BASICS (3)", screenWidth/2, screenHeight/2);
          newStageCounter++;
        } else {
          dialLength = 3;
          newStage = false;
        }
      } else {
        background(240);
        practiceDial.display();
      }
      //pause a moment before moving to main menu
      if (practiceDial.isUnlocked) {
        if (newStageCounter < 50) {
          newStageCounter++;
        } else {
          newStageCounter = 0;
          gameState = 0;
        }
      }
    }

    //Difficulty Selection
    else if (gameState == 5) {
      background(0);
      //if on right, highlight right (shoplifter dif)
      if ((0 < mouseX && mouseX < screenWidth/3)) {
        fill(30);
        rect(screenWidth/2, 0, screenWidth/2, screenHeight);
        textAlign(CENTER);
        textSize(32);
        fill(200);
        text("Shoplifter", screenWidth/6, screenHeight/8);
        if (mouseReleased) {
          mouseReleased = false;
          //set difficulty and change game state
          diffSelect = 0;
          gameState = 7;
        }
      }
      //else if, highlight middle (bank robber)
      else if ((screenWidth/3+1 < mouseX && mouseX < 2*screenWidth/3)) {
        fill(30);
        rect(0, 0, screenWidth/2, screenHeight);
        if (mouseReleased) {
          mouseReleased = false;
          //set difficulty and change game state
          diffSelect = 1;
          gameState = 7;
        }
      }
      //else, highlight left (master thief dif)
      else if ((2*screenWidth/3+1 < mouseX && mouseX < screenWidth)) {
        fill(30);
        rect(0, 0, 5*screenWidth/6, screenHeight);
        if (mouseClicked) {
          mouseReleased = false;
          //set difficulty and change game state
          diffSelect = 2;
          gameState = 7;
        }
      }
      textAlign(CENTER);
      textSize(32);
      fill(200);
      text("Phantom Thief", screenWidth/2, screenHeight/8);
    }

    // //Drill Stage
    // else if (gameState == 6) {
    //   if (newStage) {

    //   }
    // else{
    //   background(240);
    // stage.display();}


    //   //If time runs out, move to game over.
    //   if (timeRemaining == 0) {
    //     gameState = 4;
    //   }

    //   //If stage is complete
    //   if (drill.isComplete) {
    //     gameState = 5;
    //   }
    // }
    //Keypad Stage
    else if (gameState == 7) {
      if (newStage) {
        if (newStageCounter < 200) {
          background(0);
          textSize(32);
          textAlign(CENTER, CENTER);
          text("CHAPTER 2: THE KEYPAD", screenWidth/2, screenHeight/2);
          newStageCounter++;
        } else {
          keyPadLength = 8;
          newStageCounter = 0;
          newStage = false;
        }
      } else {
        background(240);
        keypad.display();
      }
      //pause a moment before moving to next stage
      if (keypad.isComplete) {
        if (newStageCounter < 100) {
          newStageCounter++;
        } else {
          newStage = true;
          newStageCounter = 0;
          gameState = 8;
        }
      }
    }
    //Vault Stage
    else if (gameState == 8) {
      if (newStage) {
        if (newStageCounter < 200) {
          background(0);
          textSize(32);
          textAlign(CENTER, CENTER);
          text("CHAPTER 3: THE VAULT", screenWidth/2, screenHeight/2);
          newStageCounter++;
        } else {
          dialLength = 10;
          newStageCounter = 0;
          newStage = false;
        }
      } else {
        background(240);
        vault.display();
      }
      //pause a moment before moving to next stage
      if (keypad.isComplete) {
        if (newStageCounter < 50) {
          newStageCounter++;
        } else {
          newStage = true;
          newStageCounter = 0;
          gameState = 10;
        }
      }
    }

    //Game Over & Reset (with space bar)
    else if (gameState == 9) {
      background(0);
      //Display level & score
      textAlign(CENTER, CENTER);
      fill(100);
      textSize(32);
      text("Defeat... \nLevel stageNum sco", screenWidth/2, screenHeight/2 );
    }

    //Game Complete
    else if (gameState == 10) {
      //Game end
      background(0);
      //Display level & score
      textAlign(CENTER, CENTER);
      fill(100);
      textSize(32);
      text("Congratulations! You Win! \nLevel: ", screenWidth/2, screenHeight/2 );
    }

    //Change Background
    else if (gameState == 6) {
      menuImageNum = rand.nextInt(menuBackgrounds.size());
      menuImage = menuBackgrounds.get(menuImageNum);
      //Move to main menu
      gameState = 0;
    }

    //Exit
    else if (gameState == 7) {
      exit();
    }
  }
}
