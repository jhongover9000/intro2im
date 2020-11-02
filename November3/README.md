### Assignment 7: 3-Light Game

This is a simple game where you match the order of lights to a pattern shown at the beginning. If you win, the lights will blink one at a time, alternating in color. If you lose, all three lights will blink at once. Here's a pic:

![](IM_Assignment7_Picture.jpg)

Here's the schematic:

![](IM_Assignment7_Schematic.jpg)

#### The Idea

![](Among_Us_Task.jpg)

When I heard "a puzzle using 3 lights and buttons" I immediately thought of this thing. I remembered it from when I played Among Us, where there was a task where you had to follow the order of buttons that lit up. I thought that I'd create something similar (but on a much smaller scale).

#### Difficulties

So, when I first started, I wanted to use the STL vector but realized that it wasn't working. Like at *all*. Turns out downloading and using libraries is a lot more complicated than I thought it was, because I kept getting "error compiling for board arduino uno" as an exception, which made me end up using normal arrays (err *static* arrays).

That was great and all, and everything was going smoothly until I realized that I made a slight mistake with the default setting for the pressed button. I set it as 0, since I was going to say that each respective button was 1, 2, and 3, but then that started messing up the lights that turned on. I didn't mind it at first and thought I'd get to it as it came, but it kept piling up until I had no idea which light I was turning on with a button, and the game itself got messed up as well. It was because of the way that I was calling the lights to turn on using the indicies, and it was very inconvenient having to use the buttons as 1, 2, and 3 because I needed to subtract 1 when referencing a light or pattern and add 1 in other cases. Because of that, I rewrote the entire thing with the default pressed button as 3, which made my life a lot easier. It was a really stupid mistake that kept piling up because I thought it'd be okay, but I realized that I was having to hardcode each variable as a result of it. Glad I changed it before I finished the entire thing.

Besides that, there isn't much else, unless you count how bright the LEDs are. My eyes hurt so bad from test-running this thing over and over...
