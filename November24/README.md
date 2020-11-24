### Assignment 10: Flappy Bird Knockoff

So. I don't actually know if this will work, but I want to make a remake of Flappy Bird using a button. It's a super simple interaction, I *know*, but it's kinda hard to get creative with this, given the limited skills, time, and resources that I have. I thought of making an escape room, Escape Room 2.0, but that'll either be the final project or just something I make in my free time.

#### The Idea and Result

I don't really think I need to introduce Flappy Bird, but it's basically a game where you tap the screen to make a bird on the screen fly. Every tap makes it go up by a certain amount, and if you don't tap the screen it'll fall to the ground. Also, there are obstacles that you need to avoid hitting, too.

![](flappybirdpic)

So that's the game. What I made ended up being really similar (because I got my hands on the image assets, yay!); here it is:

![](IM_Assignment10_Pic.png)
![](IM_Assignment10_Screenshot1.png)
![](IM_Assignment10_Screenshot2.png)
![](IM_Assignment10_Screenshot3.png)

#### The Schematic

So, the interaction here between Arduino and Processing is extremely simple: just a button click. So, just a single button.

![](IM_Assignment10_Schematic.jpg)

#### Difficulties

One problem I came across was trying to get the two programs to communicate to one another. For some reason, they just weren't, even though the right things were being sent to the programs. Turns out that the problem was that the system I used in order to prevent button holding was making the byte sent to Processing from the Arduino disappear amongst the hundreds of other bytes that were being sent in a split second. Once I got rid of the anti-holding part of the code, it worked. At the expense of looking sophisticated, but as long as it works it's good... right?
