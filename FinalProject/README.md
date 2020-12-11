### Final Project: Bank Heist

#### The Idea and Result

So, how did this idea spring up in my head? Well, I'm not really sure, either. Initially, I was planning on doing something similar to the Tap Tap series (basically games that you had to tap the right beats to a song) using either the buttons or photoresistors, which is something entirely different from this. But I guess what stopped me from doing it was because it was something that had already been done and I knew how to implement it. I dunno why I do this to myself, but I wanted to try something that hadn't been done (or at least to my knowledge). So I fiddled around with the sensors, thinking about what they could do and how I could make it into a game or a contraption of some sort. I knew that making something like an RC car was a possibility, but I never really explored it because I didn't want to burn down *all* the bridges behind me, ya know?

Well, that's when I remembered being bummed that the potentiometer only turned like 270 degrees or something rather than turning all 360. I thought that it'd have been cool to make it into a dial of some kind, then *boom*. I thought I could make a vault dial with the thing. One thing led to another and I came up with the idea of a game simulating a bank heist, whose final stage (or second to last) would be opening a vault.

So, the game. It's a bank heist simulation that consists of two stages (look at the journal to see how many I wanted to make vs the actual number I made because of my lack of experience with Arduino and debugging), a keypad (presumably for a door) and a vault dial. There's a timer going on in the background, and when it reaches 0 you lose. Also, if you mess up while working, you will either lose time or lose the game (depends on difficulty, read on).

I can't say that I'm overjoyed with how things turned out, seeing as I wasn't able to add all the stages I wanted to, but it's still fun to play. Here are screeshots of the game's menu screen:

![](IM_AssignmentFinal_Screenshot01.png)

![](IM_AssignmentFinal_Screenshot02.png)

As you can see, the UI for the menu is pretty similar to that of my midterm project, SAO: ReVisited. That's because it's pretty much the same code that I created for the UI on that project. I spent hours making a block of code that would dynamically create a menu based on the inputs of an inital location and I thought it was a waste not to use it. Maybe recoloring it might've been a cool idea, though. Anyway, the features are the same. Instructions, changing the background, the music for the menu, all of it's there. Okay, so on to the main game.

![](IM_AssignmentFinal_Screenshot03.png)
![](IM_AssignmentFinal_Screenshot04.png)
![](IM_AssignmentFinal_Screenshot05.png)

This is what you get when you hit "Depart": the difficulty selection screen. I was planning on having animations on it, just like my midterm project, but I didn't have the time so I just made it differentiated by colors. Anyway, three difficulties, each has different penalties for mistakes. The easiest stage (Shoplifter) gives you the most time and the least penalties, the normal stage (Bank Robber) a little less time and a little more penalties, and the extreme stage (Phantom Thief) the least time and harshest penalty (you lose automatically if you make a single mistake). So, pick and choose your stage, then we move onto the first stage: the keypad.

![](IM_AssignmentFinal_Screenshot06.png)
![](IM_AssignmentFinal_Screenshot07.png)

So, the stage is comprised of two parts, the Processing end and the Arduino end. When the stage starts, the Arduino creates a randomly generated code for the passcode and sends it to Processing, which receives it and decrypts it into the actual passcode. The encryption is very simple; it's a matrix of numbers from 1-9, which happens to be what the keypad is. I tried to make this connection a little bit less subtle (but still hard to get right away) by adding the colored wires, which imply that it may just be a matrix. In order to solve this, the player needs to go to the Arduino and play a light game, which starts with a button press. The lights will be in pairs of 2, incremented by 2 each stage. Once you reach the end of the game, a button push will show the entire code (the coordinates) again. With this information, you need to unlock the keypad by matching the light pairs to their digits; the first is the row, the second the column. Getting the code wrong will result in your time being decreased, but getting it right will make the numbers flash green. Finish that, and you'll know.

![](IM_AssignmentFinal_Screenshot08.png)

Then you move on to the second (and last) stage, the vault, which uses the buttons and the potentiometer.

![](IM_AssignmentFinal_Screenshot09.png)
![](IM_AssignmentFinal_Screenshot10.png)

The vault is what took the most time to code as it required a lot of moving parts. There's the water cup, which tells you if you have the right digit or not as well as which vault you've selected (selection can be made using the buttons on the Arduino), and there's the dial. Not to mention there are *three* dials. Here, you need to put on your ~~stethoscope~~ earphones and *listen*. I actually recommend you start the game with earphones, because the first click will occur in the chapter intro screen. The game will tell you which dial you need to work on (next) when you reach the right digit on the right dial by using audio panning. Also, don't turn the dial too fast or you might lose your grip ;P

![](IM_AssignmentFinal_Screenshot11.png)

When you change dials, your last position will be saved until you get back to it. In order to start a dial, you need to match the potentiometer to the last position that the dial was in (you'll know because of the ghost dial, which keeps track of your current position) before it starts moving along with your input. Anyway, whenever you complete a dial, the red arrow at the top of the dial will turn green (this will take some time, as there are 10 digits to a dial–– making 30 digits total for the vault stage passcode). Complete all the dials, and you'll know. There's a satisfying clack.

![](IM_AssignmentFinal_Screenshot13.png)

And that's the game! You can reset the game by clicking the SPACE bar, which the game tells you after a while. I suddenly just realized that I've basically written a walkthrough of the game, which is *not* what I was planning to do. I feel like I've become one of those IGN guides or something...

Also, if you're wondering, when you lose the game it looks like this.

![](IM_AssignmentFinal_Screenshot14.png)

#### The Arduino & Schematic

I'm saving my complaints and problems till later, so for now I'll just post a picture of my circuit and a schematic. Very simple; just three buttons, three LEDs, and a potentiometer. Here they are:

![](IM_AssignmentFinal_Photo01.jpg)

![](IM_AssignmentFinal_Schematic.jpg)

#### The Code

#### Difficulties

#### Some Pretty-Cool-Ideas-That-Actually-Made-It-Into-The-Game
