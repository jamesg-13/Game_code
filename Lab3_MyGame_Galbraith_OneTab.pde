//main program

int score = 0;

int gap;

boolean button = false;  //set button boolean variable to false to start (global, whole code can access)
boolean exit = false;  //boolean variable for exit screen starts as false
boolean run = false;  //boolean variable for start of game starts as false

Ball ball1;  //declaring 5 Ball objects
Ball ball2;
Ball ball3;
Ball ball4;
Ball ball5;

Title title;  //declare title object from Title class

void setup() {
  size(700, 700);
  
  gap = width - 4*width/100;  //distance of paddle from right wall
  
  ball1 = new Ball( color(random(255), random(255), random(255)), width/15, random(height), width/25, random(2,4), random(1,2), random(-1,1) );
  ball2 = new Ball( color(random(255), random(255), random(255)), width/15, random(height), width/25, random(2,4), random(1,2), random(-1,1) );
  ball3 = new Ball( color(random(255), random(255), random(255)), width/15, random(height), width/25, random(2,4), random(1,2), random(-1,1) );
  ball4 = new Ball( color(random(255), random(255), random(255)), width/15, random(height), width/25, random(2,4), random(1,2), random(-1,1) );
  ball5 = new Ball( color(random(255), random(255), random(255)), width/15, random(height), width/25, random(2,4), random(1,2), random(-1,1) );
  
  title = new Title();  //initialize title object from Title class
  
}


void draw() {
  background(100, 100, 200);
  
  title.displayTitle();
  
  if (run) {  //if start button is pressed, run all the game code
    background(100, 100, 200);  //redraw background over title screen
    
    
    for (float i = 0;  i < 20; i++) {  //repeatedly draw a bunch of random, translucent circles in background for "distraction" effect
      noStroke();
      fill(255, 40);  //second parameter is alpha
      circle(random(width), random(height), random(width/10, width/5));
    }
    
    ball1.all();  //run all 5 ball objects and all of their functions
    ball2.all();
    ball3.all();
    ball4.all();
    ball5.all();
  }
  
  if (exit) {
    exit();
  }
  
  textAlign(TOP, LEFT);
  textSize(4*height/100);  //need to make sure text size adjusts to window size as well
  fill(255);
  text("Score: " + score, 2*width/100, 4*height/100);
  
  
 //paddle
  int paddleW = 5*width/100;  //variables for paddle dimensions to make them proportional to any size screen
  int paddleH = 30*height/100;  // ^^ cannot be declared globally because that cannot use height and width since they would not take the declared size of window into account.  
  rectMode(CENTER);
  fill(255);
  float paddleY = constrain(mouseY, paddleH/2, height - paddleH/2);  //ensure entire paddle always stays on screen
  rect(gap, paddleY, paddleW, paddleH);  //paddle, moves with mouse in y-direction
}


//Ball class

class Ball {
  color ballColor;
  float xpos;
  float ypos;
  float diam;
  float xspeed;
  float yspeed;
  float direction;
  
  Ball (color ballColor, float xpos, float ypos, float diam, float xspeed, float yspeed, float direction) {
    this.ballColor = ballColor;
    this.xpos = xpos;
    this.ypos = ypos;
    this.diam = diam;
    this.xspeed = xspeed;
    this.yspeed = yspeed;
    this.direction = direction;
  }
  
  void display() {
    stroke(0);
    fill(ballColor);
    circle(xpos, ypos, diam);  
  }
  
  void move() {
    if (direction > 0) { 
      ypos += yspeed;  //if direction returns positive value, ball starts off going down
    } 
    if (direction < 0) {
      ypos -= yspeed;  //if direction returns negative value, ball starts off going up
    }
    xpos = xpos + xspeed;  //ball moves horizontally right to start
  }
  
  void checkEdges() {
    //bouncing off left or right wall
    if (ypos <= diam/2 || ypos >= height - diam/2) {
      yspeed *= -1;  //if the top EDGE of the ball (hence diam/2, or radius) hits top wall, OR if bottom EDGE (hence height - diam/2) hits bottom wall, change speed's sign, thus changing the direction of the ball.   
    }
    //bouncing off left wall
    if (xpos <= diam/2) {
      xspeed *= -1; //if left EDGE of ball hits left wall, change speed sign and reverse direction.  
    }
  }
  
  void score() {
    int paddleW = 5*width/100;  //variables for paddle dimensions to make them proportional to any size screen
    int paddleH = 30*height/100;
    if (xpos >= gap - paddleW/2 - diam/2 && ypos > mouseY - paddleH/2 && ypos < mouseY + paddleH/2) {  //first parameter ensures ball's right edge always hits paddle exactly no matter what size player makes paddle.  Also make first parameter == so score does not keep increasing when ball is right of window.  
      score = score + 1; //score increases by one (score = score + 1)
      xspeed *= -1.10;  //every time ball hits paddle, speed of ball increases  by 10% (same as xspeed = xspeed * -1.10), but need negative sign because when ball goes left after hitting paddle, moving in the negative x-direction.
      yspeed *= 1.10;  //vertical speed of ball also increases by 10% (same as yspeed = yspeed * 1.10)  
      xpos = gap - paddleW/2 - diam/2 - width/100;  //placing ball just in front of paddle ensures that ball does not "skid" of hit paddle more than once when ball hits corner or side of paddle, thus preventing uncontrollable increases in speed.  
    }
      
  }
  
  void miss() {
    if (xpos > width - diam/2) {
      score = score - 1;
      xpos = width/15;
      ypos = random(height);
      xspeed *= 0.75;  //slow down xspeed
      yspeed *= 0.75;  //slow down yspeed 
      fill(ballColor); 
    }
  }
  
  void all() {
    display();
    move();
    checkEdges();
    score();
    miss();
  }
}

//Title class

class Title {
  
  Title () {  //Title constructor has no parameters
  }
  
  void displayTitle() {
    strokeWeight(2);
    fill(255); 
    textAlign(CENTER, CENTER);
    textSize(3*width/100);  //need to make sure text size adjusts to window size as well
    text("Deflect the balls with your paddle! \n Use the mouse to move your paddle. \n When you hit one, your score goes up, and the balls move faster! \n If you miss, your score goes down and the balls slow down" , width/2, height/3);
    
    //exit button
    rectMode(CENTER);  
    fill(255, 0, 0);
    strokeWeight(2);
    rect(9*width/10, 9*height/10, 15*width/100, 6*height/100);
    strokeWeight(0);
    fill(0);
    textSize(3*width/100);
    text("EXIT", 9*width/10, 9*height/10);
    
    //start button
    strokeWeight(2);
    stroke(0);
    fill(20, 250, 100);
    rect(width/2, 2*height/3, 3*width/5, 15*height/100);
    fill(0);
    textSize(3*width/100);
    text("Press to start!", width/2, 2*height/3);
  }
}

//buttons

void mousePressed() {
  //button variable becomes TRUE when start button is pressed
  if (mouseX > width/2 - (3*width/5)/2 && mouseX < width/2 + (3*width/5)/2 && mouseY < 2*height/3 + (15*height/100)/2  && mouseY > 2*height/3 - (15*height/100)/2) {
    button = !button;  //when mouse is pressed within bounds of start button, set button, which was initially at false, to true, variable is false, set to true  
  }
  //exit button  (else if because if both buttons are if, they will run independently)
  else if (mouseX > 9*width/10 - (15*width/100)/2  && mouseX < 9*width/10 + (15*width/100)/2  && mouseY < 9*height/10 + (6*height/100)/2  && mouseY > 9*height/10 - (6*height/100)/2) {
    exit = !exit;  //when button variable is true, set to false (meaning button is true when mousePressed, since button variable is initially set to false).
  }
  
  if (button) {  //if start button pressed, code starts
    run = true;
    exit = false;
  }
  
  if (exit) {  //if exit button pressed, exit code
    exit();  //using exit() function in Processing
  }
}
