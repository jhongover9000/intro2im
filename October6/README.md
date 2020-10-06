### Assignment 4: Generative Text

![](IM_Assignent4_Screenshot.png)

This is a random text generator that uses grammar rules (sentence structure) in order to create one-line poetic sentences.
This is done using functions that call one another according to the grammar rules (i.e. a noun should come after
an adjective). The words themselves are read off of a CSV file, meaning that you can always add or subtract the words you
want in the sentences. There are also some particle effects that look like snow to set the mood ;) Oh, the program is kinda power-hungry and it doesn't actually end (I made it so there's a new line every 250 frames, but that's it), so make sure you
end the program in the case that you run it.
###### Note: the CSV file needs to have 6 lines, with each line as follows: pronoun, noun, adjective, preposition, article, verb.

Here's a line from the code, which shows what I did in order to set the orders for each call of a function:

    //Adds a random noun
    void addNoun(ArrayList<String> array) {
      wordIndex = rand.nextInt(noun.length);
      //print(wordIndex);
      //print(noun[wordIndex]);
      //print("\n");
      array.add(noun[wordIndex]);
      //If the noun is at the end of the sentence (found through comparing the size of the array), then add a "." to the end.
      if ( (array.size() >= lineLength - adjCount - 1 ) && (array.size() <= lineLength - 1) ||  (array.size() > lineLength - 1) ) {
        array.add(".");
      } else {
        addVerb(array);
      }
    }

This function (addNoun) in particular is the "ending call" for the set of functions using the conditions of whether the noun
is at the end of the sentence or not. This method was actually something that was really interesting because I didn't think
of using this until nearly halfway through the entire coding process. I was originally going to have each format function
have a list of the words I wanted to use like this,

        void sentenceF1(){
            addPronoun();
            addAdj();
            addNoun;
            addPrep();
            addArt();
            addNoun();
            
but this method of having each function call the next, and make the entire system go in a loop over and over until the 
addNoun function returned a non-function command allowed me to shorten each function to 4 lines like this.

        void sentenceF1() {
          lineLength = 8;
          adjCount = 2;
          addPronoun(lineArray);
        }
            
All I needed to do was specify the number of words in the sentence (lineLength) and the number of adjectives (which are optional) at the beginning of each call, which cut down the whole complicated process of adding probability bits over and
over again. I actually think it's rather ingenius that I came up with this method (no bragging, just really think that
it's cool).

Something difficult that I ran across was when I would occasionally run into situations where the program would get stuck
in a loop and constantly call functions without ending, which is why I had to modify the addNoun() function so that in 
the case that the number of words was over, it would automatically end the line and put a period. Also, getting the whole
optional bit (articles and adjectives) to work via the grammar rules was kind of complicated as well, but I got through it
with grit and determination ;)
