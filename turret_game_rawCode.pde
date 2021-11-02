 /*
  TurretExampleV1_6
  Hamza Amir
  V1_0
    *Program places a turret in the middle of the screen
    *Aims based on the mouse and fires a bullet
  V1_1 
    *enemies spawn in and move
  V1_2
    *enemies removed by bullets, bullets handled in arraylists
  V1_3
    *enimes get an animation
  V1_4
    *game states added
    *diffrent levels added
  V1_5
    *Movement for turret gets blocked off
    *life for turret
  V1_6
   *Game state for shop added
   *2 shop item added(upgraded bullet speed)
   *new shooting mode added(in the shop)
   *Easter egg added(extra life option in the shop after machine gun upgrade is bought)
  Features:
    *Commenting and header(done)
    *Uses PVectors to move bullets (done)
    *Uses PVectors to move enemies(done)
    *Uses PVectors to direct the firing angle of the player(done)
    *Has multiple enemies (>3) appear on the screen (done)
    *Has image animation for the enemies (done)
    *Has multiple games states (pregame, game, end game)(done)
    *Has player health or lives(done)
    *Has score or time variable to track progress(done)
    *Has game progression (gets harder)(done)
    *Background music and game sounds(done)
    *Power ups (health, shield , firing upgrades)(temporoary life power ups in shop)(done)
    *A shop game state to buy upgrades(done)
    *Player movement(done)
    *Easter egg (hidden features and surprises)(done)
    *Different firing modes (shot gun, flame thrower, freeze ray)(done)
*/
//import
import ddf.minim.*;//calls minim libraries
import ddf.minim.ugens.*;//calls minim librarys
Minim minim;//calls minim

//Global Variables
PVector mouse;
int score = 0;

//Turret
PVector tDirect;
PVector tPos;
float speed = 5;
PVector velocity;
PVector position;
float tSize = 60;
int lives = 5;

//Bullet
PVector bPos;
PVector [] bPoss;
PVector bVel;
PVector [] bVels;
float bSize = 10;
float bSpeed = 5;

//Enemies
int numEnemies = 3;
PVector[] enemyPoss;
PVector[] enemyVels;
float enemySize = 80;
float enemySpeed = 2;
int spawnRate = 60;
int enemyAimRate = 30;// amount of frames to aim at the player
PImage [] energyBallFrames;
int currentFrame = 0;

//buttons
boolean[] noName={false, false, false, false, false, false, false, false, false};
boolean game = false;
boolean over = false;
boolean storoe = false;


//other
boolean easterEgg = false;
boolean storeSafe = true;
AudioPlayer player;//creates audio player array
AudioPlayer hitSound;
boolean getIn = true;
int credits;
boolean checkHit(PVector pos1, float size1, PVector pos2, float size2) {
  return PVector.dist(pos1, pos2) < (size1+size2)/2.;
}


void setup() {
  size(1000,800);//size of screen
  strokeWeight(4);//size of lines
  imageMode(CENTER);//center image
  minim = new Minim(this);//creats minim
  player = minim.loadFile(1 + ".mp3");//loads long
  hitSound = minim.loadFile("hit marker Sound Effect.mp3");//loads the hit sound
  velocity = new PVector();//creats pvector for velocity
  position = new PVector(width/2, height/2);//creates postiton pvector
  init();//calls init munction
}

void init() {
  energyBallFrames = new PImage[96];//animationn for the enemys
   //load graphics
   for (int i = 0; i < energyBallFrames.length; i++){
     if(i < 10){
       energyBallFrames[i] = loadImage("frame_0"+i+"_delay-0.04s.gif");
     }
     else {
        energyBallFrames[i] = loadImage("frame_"+i+"_delay-0.04s.gif");
     }
   }
  tPos = new PVector(width/2, height/2);//turret psotion pvector
  bVel = new PVector();//bullet velocity pvector
  bPoss = new PVector [100];//bullet position pvector
  bVels = new PVector [100];//second bullet velocity pvector
  enemyPoss = new PVector [numEnemies];//enemy possition pvector
  enemyVels = new PVector [numEnemies];//enemy velocity pvector
}

//if the key is pressed
void keyPressed(){
   checkKeys();//calls this
}
//is called when the keys are pressed
void checkKeys(){
  //if WASD is pressed
  if (key == 'w'){  //if(keyCode == UP){
    velocity.y = - speed;  //go up
    
  }
  else if (key == 's'){//else if(keyCode == DOWN){
     velocity.y = speed; //go down
     
  }
 
  if (key == 'a'){//if(keyCode == LEFT){
    velocity.x = - speed;  //go left
  }
  else if (key == 'd'){//else if(keyCode == RIGHT){
     velocity.x = speed; //go right
  }
}

//this is to stop the turret in one place once the key is released
void keyReleased(){
  if(key == 'w' || key == 's'){
    velocity.y=0;
  }
  if(key == 'a' || key == 'd'){
    velocity.x=0;
  }
}

//this stops the turret from going off screen
void restrictions(){
  if(position.x > width - tSize/2){
    position.x = width - tSize/2;
  }
  if(position.x < 0 + tSize/2){
    position.x = 0 + tSize/2;
  }
  if(position.y > height - tSize/2){
    position.y = height - tSize/2;
  }
  if(position.y < 0 + tSize/2){
    position.y = 0 + tSize/2;
  }
}
//this is to shoot the bullet when the mouse key is released
void mouseReleased() {
  if(game == true){
     //if the bullet is null then it is available to be fired again
     if(bPos == null){
      bPos = new PVector(position.x, position.y);//setting the bullets intial position to the turret position
      bVel.set(tDirect);//get the direction the bullet should travel
      bVel.normalize();//set the velocity to one so we can scale it
      bVel.mult(bSpeed);
      //make this better
      bPos.add(tDirect);// makes the bullet starting position at the end of the barrel
     }

    for (int i = 0; i < bPoss.length; i++) {
      //if the bullet is null
      if (bPoss[i] == null) {
        bPoss[i] = new PVector(position.x, position.y);//creates pvector to directs bullet to mouse
        bVels[i]= new PVector(tDirect.x, tDirect.y);//creates pvector to get the veocity for the bullet
        bVels[i].normalize();
        bVels[i].mult(bSpeed);//sets the bullet speed
        //make this better
        return; //<==this
      }
    }
  }
}
//this is for the machine gun upgrade
void mouse(){
  //if the upgrade is bought from the shop
  if(storoe == true){
    if(mousePressed){
       //if the bullet is null then it is available to be fired again
       if(bPos == null){
        bPos = new PVector(position.x, position.y);//setting the bullets intial position to the turret position
        bVel.set(tDirect);//get the direction the bullet should travel
        bVel.normalize();//set the velocity to one so we can scale it
        bVel.mult(bSpeed);
        //make this better
        bPos.add(tDirect);// makes the bullet starting position at the end of the barrel
       }

      for (int i = 0; i < bPoss.length; i++) {
        //if the bullet is null
        if (bPoss[i] == null) {
          bPoss[i] = new PVector(position.x, position.y);//creats pvector to direct bullet to mouse
          bVels[i]= new PVector(tDirect.x, tDirect.y);//creates pvector to get the velocity of the bullet
          bVels[i].normalize();
          bVels[i].mult(bSpeed);//sets the bullet speed
          //make this better
          return; //<==this
        }
      }
    }
  }
}
//the next 7 lines of code are to aim
PVector aim(PVector enemyPos, PVector tPos, PVector vel, int aimRate) {
  if (frameCount % aimRate==0) {
    PVector  temp = PVector.sub(tPos, enemyPos);
    temp.normalize();
    return temp.mult(enemySpeed);
  }
  return vel;
}
//this spawns the enemy at a random location
void spawnEnemy() {
  //if the right number of frames has gone by, look for an enemy to spawn
  if (frameCount % spawnRate == 0) {
    //go through the array of position vectors looking for one that is available (bullet is null)
    for ( int i = 0; i < enemyPoss.length; i++) {
      //if null then construct the position vector at a random location
      if (enemyPoss[i] == null) {
        PVector temp  = PVector.random2D();//get a random vector on the unit circle
        temp.mult(width);//scale it up to a larger size
        temp.add(tPos);//translate it to be centered on the turret
        enemyPoss[i] = temp;//set it

        //makes the enemy aim
        //the null is because we don't have a vel yet and the 1 ensures the modulus condition is passed
        enemyVels[i] = aim(enemyPoss[i], tPos, null, 1);
        return;//dont look for more
      }
    }
  }
}
//this is the pregame state
void pregame(){
  //varaibles for random numbers between o and 255
  float r = random(0, 255);
  float g = random(0, 255);
  float b = random(0, 255);
  background(#030303);//sets the background
  fill(r,g,b);//sets the text color
  textSize(100);//sets the text size
  text("TURRET", 300, 300);//creates the text
  fill(#B4B2B2);//sets color
  rect(300, 400, 100, 100);//creats a rectangle
  textSize(20);//sets the text size
  text("Credits: " + credits, 30, 50);//creates text to display credits
  textSize(40);//sets the text size
  fill(#030303);//sets color
  text("Play", 310, 460);//creats play button text
  fill(#B4B2B2);//sets color
  rect(580, 400, 100, 100);//creats a rectangle
  textSize(18);//sets text size
  fill(#030303);//sets text color
  text("Instuctions", 582, 460);//creates text fir the instuction button
  fill(#B4B2B2);//sets the color
  rect(440, 550, 100, 100);//creats a rectangle
  fill(#030303);//sets color
  textSize(40);//sets the text size
  text("Store", 442, 610);//sets text for the store button
  textSize(18);//sets text size for the rest of the code
}
//instruction function
void instruct(){
  background(#B4B2B2);//sets background
  fill(#030303);//sets color
  //the next text line of code are for the instructions
  text("->Use WASD to move.", 100, 100);
  text("->Click to shoot.", 100, 200);
  text("->Move your mouse where you want to aim.", 100, 300);
  text("->Reach 50 points to beat the level, once 50 points are obtained you get sent to start screen", 100, 400);
  text("->Green is easy, yellow is medium, red is hard.", 100, 500);
  rect(900, 700, 100, 100);//creats back button
  textSize(40);//sets text size
  fill(#FFFFFF);//sets color
  text("Back", 910, 760);//back button text
  //if the button is pressed the go back
  if (mousePressed && mouseX < 1000 && mouseX > 900 && mouseY < 800 && mouseY > 700 ){
    noName[1]=false;
  }
}
//this is for the store game state
void store(){
  background(#B4B2B2);//sets background
  text("Credits: " + credits, 30, 50);//test to display credits
  //next 7 lines of code are for the first upgrade in the shop
  rect(200, 300, 100, 100);
  text("Bullet Speed Upgrade 1", 150, 420);
  text("Cost: 50", 200, 435);
  //if credits are 50 or greater and the button is pressed buy upgrade
  if (credits >= 50 && mousePressed && mouseX < 300 && mouseX > 200 && mouseY < 400 && mouseY > 300 ){
    bSpeed = 10;//sets the bullet speed
    credits = credits - 50;//takes 50 from credits
  }
  //next 7 lines are for the second upgrade
  rect(450, 300, 100, 100);
  text("Bullet Speed Upgrade 2", 400, 420);
  text("Cost: 200", 450, 435);
  //if credits are 200 or greater and the button is pressed buy upgrade
  if (credits >= 200 && mousePressed && mouseX < 550 && mouseX > 450 && mouseY < 400 && mouseY > 300 ){
    bSpeed = 20;//sets bullet speed
    credits = credits - 200;//takes 200 from credits
  }
  //next 9 lines of code are for the machine gun upgrade and to activate the easter egg
  rect(720, 300, 100, 100);
  text("Machine Gun", 715, 420);
  text("Cost: 1000", 715, 435);
  //if credits are 1000 or greater and the button is pressed buy upgrade
  if (credits >= 1000 && mousePressed && mouseX < 820 && mouseX > 720 && mouseY < 400 && mouseY > 300 ){
    storoe = true;//activates machine gun mode
    game = false;//deactivates normal mode
    easterEgg = true;//activates easter egg
    credits = credits - 1000;//takes 1000 from credits
  }
  //if the easter egg is true
  if(easterEgg == true){
    //next 7 lines of code are for the first health upgrade
    rect(590, 450, 100, 100);
    text("Health Upgrade 2", 570, 570);
    text("Cost: 1000", 590, 585);
    //if credits are 1000 or greater and the button is pressed buy upgrade
    if (credits >= 1000 && mousePressed && mouseX < 690 && mouseX > 590 && mouseY < 550 && mouseY > 450 ){
      lives = 10;//sets lives to 10
      credits = credits - 1000;//takes 1000 from credits
    }
    //next seven lines of code are the first health upgrade
    rect(325, 450, 100, 100);
    text("Health Upgrade 1", 305, 570);
    text("Cost: 1000", 325, 585);
    //if credits are 1000 or greater and the button is pressed buy upgrade
    if (credits >= 1000 && mousePressed && mouseX < 425 && mouseX > 325 && mouseY < 550 && mouseY > 450 ){
      lives = 20;//sets lives to 20
      credits = credits -1000;//takes 1000 from credits
    }
  }
  //next 7 lines of code are for the back button
  rect(900, 700, 100, 100);
  textSize(40);
  fill(#FFFFFF);
  text("Back", 910, 760);
  //if the button is pressed
  if (mousePressed && mouseX < 1000 && mouseX > 900 && mouseY < 800 && mouseY > 700 ){
    noName[8]=false;//set the shopstate to false
  }
}
//this is for the level selection
void lvl(){
  storeSafe = false;
  boolean back = true;//used to pervent errors when pressing the back button
  background(#B4B2B2);//sets background
  fill(#00FF0A);//sets color
  rect(450, 100, 100, 100);//creats a button
  fill(#FAFF00);//sets color
  rect(450, 320, 100, 100);//creats a button
  fill(#FF0000);//sets color
  rect(450, 520, 100, 100);//creats a button
  //if button is pressed
  if (mousePressed && mouseX < 550 && mouseX > 450 && mouseY < 200 && mouseY > 100 && getIn == true ){
    noName[2]=true;//set easy level to true
  }
  //calls the easy level and sets all the thing required for it to run to true or false
  if(noName[2] ==true){
    game = true;
    back = false;
    gameEz();
  }
  //if the button is pressed
  if (mousePressed && mouseX < 550 && mouseX > 450 && mouseY < 420 && mouseY > 320 && getIn == true ){
    noName[3]=true;//sets the med level to true
  }
  //calls the med level and sets all the thing required for it to run to true or false
  if(noName[3] ==true){
    game = true;
    back = false;
    gameMed();
  }
  //if the button is pressed
  if (mousePressed && mouseX < 550 && mouseX > 450 && mouseY < 620 && mouseY > 520 && getIn == true ){
    noName[4]=true;//sets the hard level to true
  }
  //calls the hard level and sets all the thing required for it to run to true or false
  if(noName[4] ==true){
    game = true;
    back = false;
    gameHrd();
  }
  if(back == true){
    fill(#030303);
    rect(900, 700, 100, 100);
    textSize(40);
    fill(#FFFFFF);
    text("Back", 910, 760);
    if (mousePressed && mouseX < 1000 && mouseX > 900 && mouseY < 800 && mouseY > 700 ){
      noName[0]=false;
      storeSafe = true;
    }
  }
}
//this if for the game over
void gameOver(){
  //next three variables randomize the color
  float r = random(0, 255);
  float g = random(0, 255);
  float b = random(0, 255);
  //if game over is set to true, used to pervent errors
  if(over == true){
    game = false;//sets the game to false
    noName[2]=false;//sets the level to false
    noName[3]=false;//sets the level to false
    noName[4]=false;//sets the level to false
    noName[0]=false;//sets level selection to false
    getIn = true;//sets level selection to false
    lives = 5;//resets lives
    background(#030303);//sets the background
    fill(r,g,b);//sets game over text color
    textSize(100);//sets the text size
    text("GAME", 300, 300);//sets the text for game of game over
    text("OVER", 300, 400);//sets the text for over of game over
    fill(#717168);//sets the button color
    rect(900, 700, 100, 100);//creates the button
    textSize(40);//sets the text size for the button
    fill(#FFFFFF);//sets the button text color
    text("Back", 910, 760);//creats the text for the button
    //if the button is pressed 
    if (mousePressed && mouseX < 1000 && mouseX > 900 && mouseY < 800 && mouseY > 700 ){
      noName[7]=false;//sets the game over state to false
      over = false;//sets the error perventaive measure to false
      credits = 0;//resets credits
      storeSafe = true;
    }
  }
}
//this is for the easy level
void gameEz() {
  getIn = false;
  noName[1] = false;//sets the instructions state to false
  enemySpeed = 2;//sets the speed of the enemys
  background(#717168);//sets the background
  position.add(velocity);//sets the postion to velocity
  //get the new mouse position
  mouse = new PVector(mouseX, mouseY);
  //get the aiming direction from the mouse and the turret position
  tDirect = PVector.sub(mouse, position);
  tDirect.normalize();//sets length to 1
  tDirect.mult(tSize*1.2);//scales the length to the size we want
  if (bPos != null) {// if the bullet exist
    bPos.add(bVel); //moves the bullet
    if (PVector.dist(position, bPos) > width) {// if it is no longer on the screen
      bPos = null;//recycle the bullet
    }
  }
  for (int i = 0; i < bPoss.length; i++) {
    if (bPoss[i] != null) {//if the bullet exists
      bPoss[i].add(bVels[i]);//moves the bullet
      fill(255, 255, 0);//sets bullet color
      ellipse(bPoss[i].x, bPoss[i].y, 10, 10);//crests the bullet
      if (PVector.dist(position, bPoss[i]) > width) {//if it is no longer on screen
        bPoss[i] = null;//recycles bullet
      }
    }
  }
  spawnEnemy();//calls spawn enemy
  restrictions();//calls the restrictions
  mouse();//calls machine gun mode
  strokeWeight(4);//sets turret stroke
  fill(0, 255, 0);//sets turret color
  ellipse(position.x, position.y, tSize, tSize);//creats the bottom of the turret
  stroke(#030303);//sets stroke color
  pushMatrix();//get ready for a bunch of matrix transformations
  translate(position.x, position.y);//moves the origin to the turret position
  rotate(tDirect.heading());//rotates the coordinate system by tDirection degrees
  rect(-15, - 15, 30, 30, 4);
  rect(-10, - bSize/2, tDirect.mag(), bSize, 4);
  popMatrix();//undo all the transformations   
  //if the bullet is not null then draw it
  //if the bullet exists
  if (bPos != null) {
    strokeWeight(1);//set stroke weight
    fill(255, 255, 0);//sets color
    ellipse(bPos.x, bPos.y, bSize, bSize);//creates bullet
  }
  for (int i = 0; i < enemyPoss.length; i++) {
    //if the enemy exists 
    if (enemyPoss[i] != null) {
      //update enemy velocity
      enemyVels[i] = aim(enemyPoss[i], position, enemyVels[i], enemyAimRate);
      enemyPoss[i].add(enemyVels[i]);
      //if the enemy hits the turret
      if (checkHit(position, tSize, enemyPoss[i], enemySize)){
          enemyPoss[i] = null;//set enemy to null
          lives --;//subtract 1 from lives
          continue;//continue
        }
      //check each enemy
      if (bPos != null) { //if the bullet exists       
        if (checkHit(enemyPoss[i], enemySize, bPos, bSize)) {
          //set the enemy position vector to null
          enemyPoss[i] = null;
          //set the bullet pvector to null
          bPos = null;
          //if the bullet is bull plays the hitsound
          if(bPos == null){
            hitSound.play();
            hitSound.rewind();
          }
          //increase score
          score++;//increse score by 1
          continue;//continue
        }
      }
      //draw the enemy
      strokeWeight(4);
      fill(0, 0, 200);
      ellipse(enemyPoss[i].x, enemyPoss[i].y, enemySize, enemySize);
      if(currentFrame >= energyBallFrames.length){//if the current frame would be outside of the array, reset it 
     currentFrame = 0; //reset it
  }
  //animats the enemy
  image(energyBallFrames[currentFrame], enemyPoss[i].x, enemyPoss[i].y, 100, 100);
  if(frameCount%2 == 0){
    currentFrame++;
  }
  }// if !null
  }//end for epos//end for epos
  fill(255, 0, 0);//sets text color
  text("Score: " + score, 30, 30);//creats text to display score
  text("Lives: "+lives, 130, 30);//creats text to display lives
  if(score == 50){//if the score is 50
      game = false;//sets sets the game to false
      noName[2]=false;//sets level to false
      noName[3]=false;//sets level to false
      noName[4]=false;//sets level to false
      noName[0]=false;//resets level selection
      getIn = true;//resets level selection
      credits += score;//adds score to credits
      score=0;//resets score
      lives = 5;//resets lives
      storeSafe = true;
  }
  //if lives reach 0
  if(lives == 0){
    noName[7] = true;//sets game over to false
    over = true;//sets perventative game over measures to true
  }
}//end of level

void gameMed() {
  getIn = false;
  noName[1] = false;//sets the instructions state to false
  enemySpeed = 6;//sets the speed of the enemys
  background(#717168);//sets the background
  position.add(velocity);//sets the postion to velocity
  //get the new mouse position
  mouse = new PVector(mouseX, mouseY);
  //get the aiming direction from the mouse and the turret position
  tDirect = PVector.sub(mouse, position);
  tDirect.normalize();//sets length to 1
  tDirect.mult(tSize*1.2);//scales the length to the size we want
  if (bPos != null) {// if the bullet exist
    bPos.add(bVel); //moves the bullet
    if (PVector.dist(position, bPos) > width) {// if it is no longer on the screen
      bPos = null;//recycle the bullet
    }
  }
  for (int i = 0; i < bPoss.length; i++) {
    if (bPoss[i] != null) {//if the bullet exists
      bPoss[i].add(bVels[i]);//moves the bullet
      fill(255, 255, 0);//sets bullet color
      ellipse(bPoss[i].x, bPoss[i].y, 10, 10);//crests the bullet
      if (PVector.dist(position, bPoss[i]) > width) {//if it is no longer on screen
        bPoss[i] = null;//recycles bullet
      }
    }
  }
  spawnEnemy();//calls spawn enemy
  restrictions();//calls the restrictions
  mouse();//calls machine gun mode
  strokeWeight(4);//sets turret stroke
  fill(0, 255, 0);//sets turret color
  ellipse(position.x, position.y, tSize, tSize);//creats the bottom of the turret
  stroke(#030303);//sets stroke color
  pushMatrix();//get ready for a bunch of matrix transformations
  translate(position.x, position.y);//moves the origin to the turret position
  rotate(tDirect.heading());//rotates the coordinate system by tDirection degrees
  rect(-15, - 15, 30, 30, 4);
  rect(-10, - bSize/2, tDirect.mag(), bSize, 4);
  popMatrix();//undo all the transformations   
  //if the bullet is not null then draw it
  //if the bullet exists
  if (bPos != null) {
    strokeWeight(1);//set stroke weight
    fill(255, 255, 0);//sets color
    ellipse(bPos.x, bPos.y, bSize, bSize);//creates bullet
  }
  for (int i = 0; i < enemyPoss.length; i++) {
    //if the enemy exists 
    if (enemyPoss[i] != null) {
      //update enemy velocity
      enemyVels[i] = aim(enemyPoss[i], position, enemyVels[i], enemyAimRate);
      enemyPoss[i].add(enemyVels[i]);
      //if the enemy hits the turret
      if (checkHit(position, tSize, enemyPoss[i], enemySize)){
          enemyPoss[i] = null;//set enemy to null
          lives --;//subtract 1 from lives
          continue;//continue
        }
      //check each enemy
      if (bPos != null) { //if the bullet exists       
        if (checkHit(enemyPoss[i], enemySize, bPos, bSize)) {
          //set the enemy position vector to null
          enemyPoss[i] = null;
          //set the bullet pvector to null
          bPos = null;
          //if the bullet is bull plays the hitsound
          if(bPos == null){
            hitSound.play();
            hitSound.rewind();
          }
          //increase score
          score++;//increse score by 1
          continue;//continue
        }
      }
      //draw the enemy
      strokeWeight(4);
      fill(0, 0, 200);
      ellipse(enemyPoss[i].x, enemyPoss[i].y, enemySize, enemySize);
      if(currentFrame >= energyBallFrames.length){//if the current frame would be outside of the array, reset it 
     currentFrame = 0; //reset it
  }
  //animats the enemy
  image(energyBallFrames[currentFrame], enemyPoss[i].x, enemyPoss[i].y, 100, 100);
  if(frameCount%2 == 0){
    currentFrame++;
  }
  }// if !null
  }//end for epos//end for epos
  fill(255, 0, 0);//sets text color
  text("Score: " + score, 30, 30);//creats text to display score
  text("Lives: "+lives, 130, 30);//creats text to display lives
  if(score == 50){//if the score is 50
      game = false;//sets sets the game to false
      noName[2]=false;//sets level to false
      noName[3]=false;//sets level to false
      noName[4]=false;//sets level to false
      noName[0]=false;//resets level selection
      getIn = true;//resets level selection
      credits += score;//adds score to credits
      score=0;//resets score
      lives = 5;//resets lives
      storeSafe = true;
  }
  //if lives reach 0
  if(lives == 0){
    noName[7] = true;//sets game over to false
    over = true;//sets perventative game over measures to true
  }
}//end of level

void gameHrd() {
  getIn = false;
  noName[1] = false;//sets the instructions state to false
  enemySpeed = 12;//sets the speed of the enemys
  background(#717168);//sets the background
  position.add(velocity);//sets the postion to velocity
  //get the new mouse position
  mouse = new PVector(mouseX, mouseY);
  //get the aiming direction from the mouse and the turret position
  tDirect = PVector.sub(mouse, position);
  tDirect.normalize();//sets length to 1
  tDirect.mult(tSize*1.2);//scales the length to the size we want
  if (bPos != null) {// if the bullet exist
    bPos.add(bVel); //moves the bullet
    if (PVector.dist(position, bPos) > width) {// if it is no longer on the screen
      bPos = null;//recycle the bullet
    }
  }
  for (int i = 0; i < bPoss.length; i++) {
    if (bPoss[i] != null) {//if the bullet exists
      bPoss[i].add(bVels[i]);//moves the bullet
      fill(255, 255, 0);//sets bullet color
      ellipse(bPoss[i].x, bPoss[i].y, 10, 10);//crests the bullet
      if (PVector.dist(position, bPoss[i]) > width) {//if it is no longer on screen
        bPoss[i] = null;//recycles bullet
      }
    }
  }
  spawnEnemy();//calls spawn enemy
  restrictions();//calls the restrictions
  mouse();//calls machine gun mode
  strokeWeight(4);//sets turret stroke
  fill(0, 255, 0);//sets turret color
  ellipse(position.x, position.y, tSize, tSize);//creats the bottom of the turret
  stroke(#030303);//sets stroke color
  pushMatrix();//get ready for a bunch of matrix transformations
  translate(position.x, position.y);//moves the origin to the turret position
  rotate(tDirect.heading());//rotates the coordinate system by tDirection degrees
  rect(-15, - 15, 30, 30, 4);
  rect(-10, - bSize/2, tDirect.mag(), bSize, 4);
  popMatrix();//undo all the transformations   
  //if the bullet is not null then draw it
  //if the bullet exists
  if (bPos != null) {
    strokeWeight(1);//set stroke weight
    fill(255, 255, 0);//sets color
    ellipse(bPos.x, bPos.y, bSize, bSize);//creates bullet
  }
  for (int i = 0; i < enemyPoss.length; i++) {
    //if the enemy exists 
    if (enemyPoss[i] != null) {
      //update enemy velocity
      enemyVels[i] = aim(enemyPoss[i], position, enemyVels[i], enemyAimRate);
      enemyPoss[i].add(enemyVels[i]);
      //if the enemy hits the turret
      if (checkHit(position, tSize, enemyPoss[i], enemySize)){
          enemyPoss[i] = null;//set enemy to null
          lives --;//subtract 1 from lives
          continue;//continue
        }
      //check each enemy
      if (bPos != null) { //if the bullet exists       
        if (checkHit(enemyPoss[i], enemySize, bPos, bSize)) {
          //set the enemy position vector to null
          enemyPoss[i] = null;
          //set the bullet pvector to null
          bPos = null;
          //if the bullet is bull plays the hitsound
          if(bPos == null){
            hitSound.play();
            hitSound.rewind();
          }
          //increase score
          score++;//increse score by 1
          continue;//continue
        }
      }
      //draw the enemy
      strokeWeight(4);
      fill(0, 0, 200);
      ellipse(enemyPoss[i].x, enemyPoss[i].y, enemySize, enemySize);
      if(currentFrame >= energyBallFrames.length){//if the current frame would be outside of the array, reset it 
     currentFrame = 0; //reset it
  }
  //animats the enemy
  image(energyBallFrames[currentFrame], enemyPoss[i].x, enemyPoss[i].y, 100, 100);
  if(frameCount%2 == 0){
    currentFrame++;
  }
  }// if !null
  }//end for epos//end for epos
  fill(255, 0, 0);//sets text color
  text("Score: " + score, 30, 30);//creats text to display score
  text("Lives: "+lives, 130, 30);//creats text to display lives
  if(score == 50){//if the score is 50
      game = false;//sets sets the game to false
      noName[2]=false;//sets level to false
      noName[3]=false;//sets level to false
      noName[4]=false;//sets level to false
      noName[0]=false;//resets level selection
      getIn = true;//resets level selection
      credits += score;//adds score to credits
      score=0;//resets score
      lives = 5;//resets lives
      storeSafe = true;
  }
  //if lives reach 0
  if(lives == 0){
    noName[7] = true;//sets game over to false
    over = true;//sets perventative game over measures to true
  }
}//end of level
void draw() {
  pregame();//calls pregame
  player.play();//plays background music
  //resets music when it reaches the end
  if(player.position() == 110000){
    player.rewind();
  }
  //if the play button is pressed
  if (mousePressed && mouseX < 400 && mouseX > 300 && mouseY < 500 && mouseY > 400 ){
    noName[0]=true;//sets level choseing to true
  }
  //if the instruction button is pressed
  if (mousePressed && mouseX < 680 && mouseX > 580 && mouseY < 500 && mouseY > 400 ){
    noName[1]=true;//sets the instructions to true
  }
  //if the store button is pressed and the other condtitons are met
  if (mousePressed && mouseX < 540 && mouseX > 440 && mouseY < 650 && mouseY > 550 && getIn == true && storeSafe == true){
    noName[8] = true;//sets stroe to true
  }
  if(noName[0] == true){
    lvl();//calls level chose
  }
  if(noName[1] == true){
    instruct();//calls instructions
  }
  if(noName[7] == true){
    gameOver();//calls game over 
  }
  if(noName[8] == true){
    store();//calls store
  }
}//end for draw loop
