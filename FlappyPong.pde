int gameScreen = 0;
float gravity = .1;
float airfriction = 0.00002;
float friction = 0.1;
int score = 0;
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;
float ballX, ballY;
float ballSpeedVert = 0;
float ballSpeedHorizon = 0;
float ballSize = 20;
color ballColor = color(0);
color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;
int wallSpeed = 2;
int wallInterval = 1500;
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80; 
color wallColors = color(0);
ArrayList<int[]> walls = new ArrayList<int[]>();
void setup() {
  size(500, 500);
  ballX=width/4;
  ballY=height/5;
  smooth();
}
void draw() {
  if (gameScreen == 0) { 
    initScreen();
  } else if (gameScreen == 1) { 
    gameScreen();
  } else if (gameScreen == 2) { 
    gameOverScreen();
  }
}
void initScreen() {
  background(255);
  textAlign(CENTER);
  fill(0);
  textSize(70);
  text("Flappy Pong", width/2, height/2);
  textSize(15); 
  text("Click to start", width/2, height-30);
}
void gameScreen() {
  background(255);
  drawRacket();
  watchRacketBounce();
  drawBall();
  applyGravity();
  applyHorizontalSpeed();
  keepInScreen();
  drawHealthBar();
  printScore();
  wallAdder();
  wallHandler();
}
void gameOverScreen() {
  background(255);
  textAlign(CENTER);
  fill(0);
  textSize(12);
  text("Your Score", width/2, height/2 - 120);
  textSize(130);
  text(score, width/2, height/2);
  textSize(15);
  text("Happy Their Day Nish!", width/2, height/2 - 170);
  text("Click Anywhere to Restart", width/2, height-30);
}
public void mousePressed() {
  if (gameScreen==0) { 
    startGame();
  }
  if (gameScreen==2) {
    restart();
  }
}
void startGame() {
  gameScreen=1;
}
void gameOver() {
  gameScreen=2;
}
void restart() {
  score = 0;
  health = maxHealth;
  ballX=width/4;
  ballY=height/5;
  lastAddTime = 0;
  walls.clear();
  gameScreen = 1;
}
void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}
void drawRacket() {
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight, 5);
}

void wallAdder() {
  if (millis()-lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    int[] randWall = {width, randY, wallWidth, randHeight, 0}; 
    walls.add(randWall);
    lastAddTime = millis();
  }
}
void wallHandler() {
  for (int i = 0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    wallDrawer(i);
    watchWallCollision(i);
  }
}
void wallDrawer(int index) {
  int[] wall = walls.get(index);
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  rectMode(CORNER);
  noStroke();
  strokeCap(ROUND);
  fill(wallColors);
  rect(gapWallX, 0, gapWallWidth, gapWallY, 0, 0, 15, 15);
  rect(gapWallX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight), 15, 15, 0, 0);
}
void wallMover(int index) {
  int[] wall = walls.get(index);
  wall[0] -= wallSpeed;
}
void wallRemover(int index) {
  int[] wall = walls.get(index);
  if (wall[0]+wall[2] <= 0) {
    walls.remove(index);
  }
}
void watchWallCollision(int index) {
  int[] wall = walls.get(index);  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallTopX = gapWallX;
  int wallTopY = 0;
  int wallTopWidth = gapWallWidth;
  int wallTopHeight = gapWallY;
  int wallBottomX = gapWallX;
  int wallBottomY = gapWallY+gapWallHeight;
  int wallBottomWidth = gapWallWidth;
  int wallBottomHeight = height-(gapWallY+gapWallHeight);
  if ((ballX+(ballSize/2)>wallTopX) && (ballX-(ballSize/2)<wallTopX+wallTopWidth) && (ballY+(ballSize/2)>wallTopY) && (ballY-(ballSize/2)<wallTopY+wallTopHeight)) {
    decreaseHealth();
  }
  if ((ballX+(ballSize/2)>wallBottomX) && (ballX-(ballSize/2)<wallBottomX+wallBottomWidth) && (ballY+(ballSize/2)>wallBottomY) && (ballY-(ballSize/2)<wallBottomY+wallBottomHeight)) {
    decreaseHealth();
  }
  if (ballX > gapWallX+(gapWallWidth/2) && wallScored==0) {
    wallScored=1;
    wall[4]=1;
    score();
  }
}
void drawHealthBar() {
  noStroke();
  fill(189, 195, 199);
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    gameOver();
  }
}
void score() {
  score++;
}
void printScore() {
  textAlign(CENTER);
  fill(0);
  textSize(30); 
  text(score, height/2, 50);
}
void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))) {
    if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)) {
      makeBounceBottom(mouseY);
      ballSpeedHorizon = (ballX - mouseX)/10;
      if (overhead<0) {
        ballY+=(overhead/2);
        ballSpeedVert+=(overhead/2);
      }
    }
  }
}
void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}
void applyHorizontalSpeed() {
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airfriction);
}
void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void makeBounceLeft(float surface) {
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void makeBounceRight(float surface) {
  ballX = surface-(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void keepInScreen() {
  if (ballY+(ballSize/2) > height) { 
    makeBounceBottom(height);
  }
  if (ballY-(ballSize/2) < 0) {
    makeBounceTop(0);
  }
  if (ballX-(ballSize/2) < 0) {
    makeBounceLeft(0);
  }
  if (ballX+(ballSize/2) > width) {
    makeBounceRight(width);
  }
}
