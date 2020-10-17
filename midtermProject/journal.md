#### A New Adventure.

So. The idea that I have in mind is creating a side-scroller game where you basically keep fighting ~~until you die~~.
I'm not really sure what the goal of the game will be, but I just have this desire to actually make a working version of
the game that I failed to create a year ago. I have no idea if it'll work, because I'm running across a *lot* of issues
at the moment. The idea is to allow players to select from two different characters, grind EXP and levels for a while, then
face off against a boss or two. I also think it'd be really cool to have cutscenes and stuff (not really
sure how I'll pull it off, which is why it's still more of a concept than anything.

One big problem that I foresee is not having enough time to get everything done to the point where I'm satisfied with it.
I have grand plans, but chances are my lack of experience and time will keep me from carrying them all out...

#### Days

[October 13](journal.md#oct-13)
[October 14](journal.md#oct-14)
[October 15](journal.md#oct-15)
[October 16](journal.md#oct-16)
[October 17](journal.md#oct-17)


#### Oct. 13

So... The problems are already here. Started very basic by formatting the file I'm using. Wrote down in pseudocode how I'm thinking of structuring the code,
and started seting up the functions for image loading. Aaaand I came across a problem. So, I don't really know how to access
the current working directory on Java. Like, I've scoured the internet and the solution is apparently using the command

    String cmd = System.getProperty("user.dir");

but the problem is that *it doesn't work*. I don't know if it's a Processing thing, but it's really getting on my nerves.
I think I'll just start coding everything else for now.



#### Oct. 14

Yeah, no, I'm not doing great right now. Kind of frustrated. I'm the type that doesn't like leaving a problem be, so I've
been trying to solve this problem for the past I-don't-know-how-long. So the problem right now is that the command 
    String cmd = System.getProperty("user.dir");
is giving me my home directory ("/User/username") rather than the actual directory that the file is being run from. There
was also something about using "class.java.path", but that returns the JAR files that are run with the program, which is
*not* what I want. What I'm trying to do (I realize I didn't actually explain this) is use the current working directory to
access folders with character images. The reason behind this is because of the peculiarity of the sprites that I'm using.
They aren't actually a single sheet of multiple images, but rather multiple sheets of single images. So that's why I wanted
to keep everything organized in files, but I dunno if it's gonna work.

Besides that, I've created classes for the entities that will be in the game (err, the player, enemies, and flying objects)
by making the player a subclass of the entities class, and the enemy a subclass of the player. I'm thinking of using functions
to make the enemies do things by setting values of movement booleans to certain values (not there yet, though).

#### Oct. 15

At this point I'm thinking that it's just a problem with Processing. Literally everything that I've looked up is telling me
that using System.getProperty("user.dir") *should return the right directory* but it's not working, instead giving me the
home directory which should be given when using System.getProperty("user.home"). It's frustrating. *Really* frustrating. I've
spent nearly eight hours combined trying to make this work by researching and testing different methods in hopes for it to work.
It's not working, so right now I might just place all of the images in the same folder as the Processing file and just load
the images from there. Screw organization!

###### I also have worked on trying to come up with a system of boolean values in order to determine the player's actions and
statuses. More on this later, once I cool down.



#### Oct. 16

Right now, I have a choice to make. The images that I have already have their respective identifiers (characterName + moveNumber + "_" + moveNumberFrame).
I can change this, or adapt the program to call the images in this format. I started with the former, but I might just choose
the latter depending on how long this takes (I've been renaming files for an hour now). However, the former might be a better
option because I realized that different characters have different image identifying numbers, meaning that I can't make the
program adapt using the same movesets for each character. I... am currently wondering why I chose such complicated images
(emphasis on the plurality) for this game...

Oh, and the boolean system. So basically, it looks like this:

    //These three are the present "position" booleans
    boolean isStanding;       //check if standing
    boolean isCrouching;      //check if crouching
    boolean isJumping;        //check if jumping

    //These three are the past "position" booleans
    boolean wasStanding;
    boolean wasCrouching;
    boolean wasJumping;

    //Each position boolean has three present "status" booleans
    boolean isAttacking;    //attacking or not
    boolean isGuarding;      //guarding (reduce damage taken)
    boolean isStill;

    //Each position boolean has three past "status" booleans
    boolean wasAttacking;
    boolean wasGuarding;
    boolean wasStill;

The character's movements are divided into three broad categories: standing, crouching, and jumping. When one of these *present*
position booleans are true, the others are set to false. The past ones are meant to just keep track of what the previous action
was. Anyway, this limits the character to the specified movesets for that position. It *looks* really nice, but I have no
idea if it'll actually *work*, since I haven't planned out all of the conditions and especially the update() function for the
player.

#### Oct. 17

Ok so tbh I've kinda given up on trying to get the current working directory to work... I'm just gonna shove 500+ images in the
same folder as the program. Fun times! I think I'll upload the program first, but the images will come later since I have to
rename them and check if this thing will work (I still don't have a working portion for the player movements). *Yay*. But that's
what I'm planning on doing. Once I get myself two nice ribeye steaks.

