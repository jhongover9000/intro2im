### The Journ(ey)al

[Day 1](journal.md#day-1); [Day 2](journal.md#day-2); [Day 3](journal.md#day-3); [Day 4](journal.md#day-4); [Day 5](journal.md#day-5); [Day 6](journal.md#day-6); [Day 7](journal.md#day-7); [Day 8](journal.md#day-8); [Day 9](journal.md#day-9)

#### Day 1 (11/11)

I'm thinking of trying to make a game similar to the Tap Tap series (which for some reason doesn't exist anymore on the App Store), where you tap on incoming "beats" (orbs) that come down the screen according to the beat of the song. This used to be one of my favorite pastimes, but now it's gone (replaced by others, which are fun, but just don't have that same nostalgia. I realize now that the Tap Tap games may have been removed due to infringing rights for privately-owned music, but I won't let that taint my memories of the game).

I think I'll have to use buttons on the arduino, since I don't have enough photoresistors to imitate the "touch" or just actual touch sensors. I have no idea how I'll program the orb sequences (I may have to hardcode this data, using a CSV file or something) but I'm thinking of making a scoring system based on how close to the center of the orb you are when you press the button (I realize that there might be delays between the arduino and program but that's something I'll figure out later).

What I know I'll need is a start page (instructions & stuff), a music selection page, and the actual game screen. I'll also need to use a sound file library and find a way to handle the rhythm bit (if I can make it automatically, that'd be even better). This time, I'll figure out how to make those separate files and use them so it's easier to read for others (in my defense, I used Sublime so I just collapsed everything I didn't need).

Why am I starting so early? There are a *lot* of things that are coming up soon, so I thought it best to get things done faster. I remember how ~~terrible-and-sleep-depriving-to-the-point-of-breakdowns~~ exhausting it was because all my assignments and midterms were in the same week, and I don't want to go through that again. However, I have a bunch of stuff due this week so I may not get back to this until next week.

#### Day 2 (11/20)

So, some mistakes were made and I didn't realize that we had another assignment on top of the musical instrument one. I had to work on that, so I didn't do much in terms of the final project. Right now, I'm really wondering what I should do. Should I continue with this idea? If so, I have a general gist of how I want to do the project, in terms of the menu and the game. However, it seems kind of... boring. Yes, it's cool and all, but for some reason it doesn't feel all that innovative. Yeah, it's a knockoff game, but right now that's just about all I can do. Thinking of making the menu as a bubble shooter kind of thing but... Whoa. I think I may have lost motivation for this game. That was fast. I'm going to think of new ideas and get back to this.

#### Day 3 (11/22)

I said it jokingly in my assignment, but what if I actually made an escape room or something? Like have a breadboard of random sensors and things, then use each of those? It's fun, and it won't be a knockoff of anything. The question, however, is how to randomize something like that. I know it's kind of going overboard, but I want to think about things like that as well. In the case that I don't randomize it, that means that I need to implement some kind of feature that'll make it exciting. Maybe a timer.

#### Day 4 (11/24)

Speaking of timers... Not a lot of time left until I need to start working on the project for **sure**. I don't want things to turn out like last time, so I need to pick an idea and stick to it. I'm not doing Tap Tap, I might do an escape room, and I have an idea for one of the things. It's a vault where you place a cup of water on top of the dial to see if there's a click. Really cool, saw it on a TV show. Want to implement that. Also, what the prof said about using the same sensor or switch for multiple functions made me think about how I might be able to use the same things for different purposes...

#### Day 5 (11/26)

A bank heist. That's what I can make. Thought of it just now, as everything clicked together. It's fun, new, and innovative. I can also add a timer so that people need to move fast (and hopefully miss out on any bugs that might exist hehe). The question now is what features there should be and how I can make it work. Last time, all I needed was one button. But this time, I'm thinking of using almost all of the sensors that I have. This is gonna be a tough one. Will I have enough time? If not, I can just stick with the vault by itself (meaning I'll work on that first, then go to the others if I have time). Yeah, it works. Eskettit (let's get it).

![](journal_sketch1.jpg)

#### Day 6 (11/28)

Thought of some new stage possibilities, as well as a sort-of storyline. Thinking of making the game something of a VN (virtual novel; these are common in Japan and are basically stories where you choose your path) with characters and narrations. Maybe for the instruction section, it can be like a heist rehersal where you learn the basics of all the sensors and how to use them. The game itself will be a lot harder, of course, so the instruction will be more of a tutorial. I think I'll call it "Rehersal" instead of "Instructions" to make it seem more realistic (haha). This section will allow the player to get used to the various sensors in the game. In addition, I think I'll make the game a sort of DIY breadboard. This will make it harder for the player (they need to select the right tool and place it in the right place), and it'll also save space on the board for me (hehe).

Started on the basic classes, but ran into issues right away regarding how I'm going to be categorizing these things. I think I might have a separate class called "Lock" and "Stage". Locks will consist of an array of integers (the code, which can be assigned using the random function; the parameters of the function will be set in the constructor, as well as the number of digits in the passcode) and have a method of checking a specific index with a number. Getting it wrong will reset the stage (or end the game, depending on the stage itself). Stages will have locks and other information, depending on what tool (sensor) is needed.

#### Day 7 (11/30)

Drew out a storyboard of sorts for a guide for me to use. This actually took a lot longer than I expected, as I needed to come up with ideas and think of what sensors or parts of the breadboard I could use.

![](journal_sketch2.jpg)

As you can probably see, I marked almost all of the stages as optional. The reason behind this is because I actually started the coding process for locks, dials, and water cups. With the time that I have, and the work that I need to complete aside from IM, I need to think realistically. I plan on finishing the vault stage first, then see how much time I have before implementing everything else. Thinking about how I'm making this into a VN of sorts means that there's another layer of added complexity with character dialogues and looking for images that I can use (I think I know what I'll use, though; I have assets from a mobile game called SAO Memory Defrag, planning on using the toughest looking guys there).

The Lock class is a bit more complicated than I thought, especially when it comes to the dial locks. They're combinations, but the thing is that because the potentiometer isn't a free-spin sensor, I need to code it so that whenever a digit is matched, the player needs to turn the potentiometer in the opposite direction in order to get to the next number. This is the code:

          //set initial value (first digit)
          int val1 = (int)random(startNum,endNum);
          passcode.add(startVal);
          //when a value is selected, this becomes the endpoint value for the next number
          //this forces a player to turn right, then left, then right... (like a lock dial)
          for (int i = 0; i < length-1; i += 2) {
            int val2 = (int)random(startNum,val1);
            passcode.add(val2);
            val1 = (int)random(val2,endNum);
            passcode.add(val3);
          }

I don't know if I can refine this further, but what I need to do now is either ensure that the passcode of the dial locks will always be odd in length or use the .remove() function to match the size of the array to the length of the passcode.

#### Day 8 (12/1)

Finished the water cup coding. It was actually rather simple, and it's kind of addicting to play with. I'm talking about how it ripples. It uses an arc whose height increases but only has half of it drawn, giving the illusion that the surface of the water is dipping down. Here's the code:

        //Ripple effect (just a dip in the water, nothing complicated)
        void ripple(){
            if(frameCounter <= 5){
                rippleDepth = frameCounter;
            }
            else if(frameCounter > 5){
                rippleDepth = 10 - frameCounter;
            }
            arc(locX, locY, 110, rippleDepth, 0, PI);
            frameCounter++;
            if(frameCounter >= 10){
              frameCounter = 0;
                isRippling = false;
            }
        }

    //Display
    void display(){
        //base of cup
        line(locX - 50, locY + 50, locX + 50, locY + 50);
        //sides
        line(locX - 50, locY + 50, locX - 60, locY - 50);
        line(locX + 50, locY + 50, locX + 60, locY -50);
        //water
        if(!isRippling){
            noFill();
            line(locX - 55, locY, locX + 55, locY);
        }
        else{
            ripple();
        }
    }

I linked the rippling to a mouse click and spent a few minutes clicking. It's rather addicting and soothing. In any case, I didn't actually finish the Lock class because I'm not really sure what I need in terms of data members. I started on the Dial class, but I also hit a sort-of wall thinking about the methods that I need for the class–– especially because I'm trying to make the lock reset if the player overturns (turns too much past) the digit. I'm thinking of making them have to reset by turning the dial to 0 again and then starting over. I remember how the potentiometer sometimes gives random values, so I need to make sure that a jump will not be counted as an overturn. Maybe I'll use a function that checks how far away from the previous value the current value is. Since it's unlikely that someone will be able to turn the potentiometer fast enough (or will *want* to; remember that this is a vault dial), if I make sure it's within 10-20 of the past value it should be enough, since I'm going to divide the potentiometer into 100 numbers (divide by 100 so that every 10 values is one number and the last is 14 in size). I also need to make the dial *spin*, so that means I'll have to use the rotation() function, too. Wow, this thing just keeps on getting more and more complicated. Well, off to work.

#### Day 9 (12/2)

Okay, so I looked over the Lock coding for the dial and realized I could make the system work by checking whether i is even or not; if it's even, that means that I perform the (int)random(startNum,val1), but make it so that val1 is actually a reference that points to the index before i (so basically using .get(i-1) ). This means that i will start at 1 rather than 0. This is the result:

                for (int i = 1; i < length; i++) {
                    int temp;
                    //if even, (int)random(startNum,passcode.get(i-1))
                    if(i%2 ==0){
                        temp = (int)random(startNum,passcode.get(i-1));
                        passcode.add(temp);
                    }
                    //if odd, (int)random(val2,endNum)
                    else if(i%2 == 1){
                        temp = (int)random(passcode.get(i-1),endNum);
                        passcode.add(temp);
                    }
                }

While making the circuit (still haven't actually decided how to do that either), I ended up removing a button so I'm only using 3. Makes the game easier, but also leaves room for more wires. What I'm worried about is the analog. I've created a sort-of workaround by making it so the player needs to plug in the right wire before starting the stage. This may be quite complicated, but it's fun to do nonetheless. Will work more tomorrow; I had an assignment due today so I worked on that most of the day.
