//Intro to IM Assignment 1: Portrait
//Joseph Hong
//==================================================================================================================================


//initial size
size(200,200);

color hairIrisColor = color(0,0,0);  //color for both hair and irises (yes they're black)
color skinColor = color(255,229,180);  //color for skin
color eyeBallColor = color(255,255,255);  //color for eyeballs

//No outlines (makes the image feel smoother)
noStroke();

//Hair (Back)
fill(hairIrisColor);
ellipse(100,80,90,80);

//Face
fill(skinColor);        //skin color
ellipse(100,90,80,80);  //top half
ellipse(100,100,75,90); //bottom half

//Ears
for(int i = 0; i<2; i++){
  ellipse(60+80*i,100,15,20);
}

//Hair (Front)
fill(hairIrisColor);
ellipse(105,55,70,35);


//Eyes
fill(eyeBallColor);             //white for eye(ball)s
for(int i = 0; i<2; i++){       //for loop used to create eyeballs, eyelids, and eyebrows
  ellipse(82.5+35*i,90,20,17);  //creates eyeballs
  stroke(1);
  noFill();
  strokeWeight(5);
  arc(82.5+35*i,90-3,30,20,PI+QUARTER_PI,PI+3*QUARTER_PI);
  noStroke();                  //prep for next iteration in for loop
  fill(eyeBallColor);
}
  strokeWeight(1);             //reset stroke weight
for(int i = 0; i<2; i++){      //for loop to create 2 irises/pupils
  fill(hairIrisColor);
  ellipse(84+32*i,90,10,10);
  fill(eyeBallColor);          //make pupil color
  ellipse(85+32*i,88,2,2);
}

//Nose
stroke(1);
strokeCap(ROUND);
line(100,100,100,115);
line(103,110,103,112);

//Mouth
noFill();
arc(100,120,30,20,QUARTER_PI, 3*QUARTER_PI);

//Neck
noStroke();
fill(skinColor);
rect(90,140,20,25);

//Body
fill(255,200,200);              //pale pink shirt
arc(100,200,110,80,PI,2*PI);
fill(0);                        //print design on shirt
text("L I F E",82.5,190);
rect(82.5,195,35,20);
