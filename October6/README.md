### Assignment 4: Generative Text

![](IM_Assignent4_Screenshot)

This is a random text generator that uses grammar rules (sentence structure) in order to create one-line poetic sentences.
This is done using functions that recursively call one another according to the grammar rules (i.e. a noun should come after
an adjective). The words themselves are read off of a CSV file, meaning that you can always add or subtract the words you
want in the sentences. There are also some particle effects that look like snow to set the mood ;)
###### Note: the CSV file needs to have 6 lines, with each line as follows: pronoun, noun, adjective, preposition, article, verb.

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
