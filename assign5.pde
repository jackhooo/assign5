

//state
int gameState, enemyState;
final int GAME_START = 0;
final int GAME_PLAYING = 1;
final int GAME_LOSE = 2;

final int ENEMY_STATE = 0;
final int ENEMY_STATE2 = 1;
final int ENEMY_STATE3 = 2;

//image
PImage start1, start2;
PImage end1, end2;
PImage bg1, bg2;
PImage enemy, fighter, hp, treasure, shoot;
PImage[] flame=new PImage[5];


int bgX=0, i, j;
float hpL, hpMax, hpNow;
int fighterX, fighterY;
int treasureX, treasureY;

int enemyCount = 8;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
float speed=6;
int enemySpeed=3;

PFont scoreBoard;
int scoreNum=0;
int bullet=0;
boolean [] shootLimit = new boolean[5];
float[] shootX=new float[5];
float[] shootY=new float[5];
float flamePlace [][] = new float [5][2];
int counter;
int current;
int closestEnemyIndex;

//keyboard input
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void setup () {
  size(640, 480);
  frameRate(60);
  //load images
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png");
  shoot=loadImage("img/shoot.png");
  treasure=loadImage("img/treasure.png");
  for (int i=1; i<=5; i++) {
    flame[i-1]=loadImage("img/flame"+i+".png");
  }
  hpNow = 2;
  hpMax = 195;
  treasureX = floor(random(30, 610));
  treasureY = floor(random(30, 450));
  fighterX = 550;
  fighterY = height/2-20;
  gameState = GAME_START;
  enemyState = ENEMY_STATE;

  counter = 0;
  current = 0;
  for ( int i = 0; i < flamePlace.length; i ++) {
    flamePlace [i][0] = 1000;
    flamePlace [i][1] = 1000;
  }


  //bullet limit
  for (int i =0; i < shootLimit.length; i ++) {
    shootLimit[i] = false;
  }

  //show score
  scoreBoard = createFont("Helvetica", 24);
  textFont(scoreBoard, 16);
  textAlign(LEFT);

  addEnemy(0);
}

void draw()
{
  background(0);
  switch(gameState) {
  case GAME_START:
    if (mouseX > width/2-120 
      && mouseX <width/2+120 
      && mouseY >height/2+150 
      && mouseY<height/2+180) {
      image(start1, 0, 0);
      if (mousePressed) {

        treasureX=floor(random(30, 610));
        treasureY=floor(random(30, 450));

        fighterX=550;
        fighterY=height/2-20;
        hpL=19.5;
        gameState=GAME_PLAYING;
      }
    } else
      image(start2, 0, 0);
    break;
  case GAME_PLAYING:
    image(bg1, bgX, 0);
    image(bg2, bgX-width, 0);
    image(bg1, bgX-width*2, 0);
    bgX++;
    bgX%= width*2;

    image (treasure, treasureX, treasureY);    
    if (isHit(treasureX, treasureY, treasure.width, treasure.height, 
      550, height/2-20, fighter.width, fighter.height) == true) {  
      treasureX = floor( random(50, width - 40) ); 
      treasureY = floor( random(50, height - 60) );
    }

    image(fighter, fighterX, fighterY);
    if (upPressed && fighterY > 0) {
      fighterY -= speed ;
    }
    if (downPressed && fighterY < height - fighter.height) {
      fighterY += speed ;
    }
    if (leftPressed && fighterX > 0) {
      fighterX -= speed ;
    }
    if (rightPressed && fighterX < width - fighter.width) {
      fighterX += speed ;
    }

    counter++;
    image(flame[current], flamePlace[current][0], flamePlace[current][1]);     
    if (counter % (60/10) == 0) {
      current ++;
      if (current > 4) {
        current = 0;
      }
    } 
    if (counter > 31) {
      for (i = 0; i < 5; i ++) {
        flamePlace [i][0] = 1000;
        flamePlace [i][1] = 1000;
      }
    }
    for ( i = 0; i < 5; i ++) {
      if (shootLimit [i] == true) {
        image(shoot, shootX[i], shootY[i]);
        shootX[i] -= speed;
      }
      if (shootX[i] < shoot.width) {
        shootLimit[i] = false;
      }
    }
    for ( i = 0; i < 5; i++) {
      if (enemyX[0] > 0) {
        if (closestEnemyIndex != -1 && enemyX[closestEnemyIndex] < shootX[i]) {
          if (enemyY[closestEnemyIndex] > shootY[i]) {
            shootY[i] += 3;
          } else if (enemyY[closestEnemyIndex] < shootY[i]) {
            shootY[i] -= 3;
          }
        }
      }
    }
    switch (enemyState) {
    case ENEMY_STATE:
      drawEnemy();

      for ( i = 0; i < 5; i++) {      
        for ( j = 0; j < 5; j++) {
          if (isHit(shootX[j], shootY[j], shoot.width, shoot.height, 
            enemyX[i], enemyY[i], enemy.width, enemy.height) == true
            && shootLimit[j] == true) {
            for (int a = 0; a < 5; a++) {
              flamePlace [a][0] = enemyX[i];
              flamePlace [a][1] = enemyY[i];
            }
            enemyY[i] = -1000;
            counter = 0;     
            shootLimit[j] = false;
            scoreChange(20);
          }
        }

        if (isHit(fighterX, fighterY, fighter.width, fighter.height, 
          enemyX[i], enemyY[i], enemy.width, enemy.height) == true) {
          for ( j = 0; j < 5; j++) {
            flamePlace [j][0] = enemyX[i];
            flamePlace [j][1] = enemyY[i];
          }             
          enemyY[i] = -1000;
          counter = 0; 
          hpChange(-20);
        } else if (hpL <= 0) {
          dieReset();
        }
      }

      enemyChange(1);

      break;
    case ENEMY_STATE2:
      drawEnemy();
      for ( i = 0; i < 5; i++ ) {
        for ( j = 0; j < 5; j++) {
          if (isHit(shootX[j], shootY[j], shoot.width, shoot.height, 
            enemyX[i], enemyY[i], enemy.width, enemy.height) == true
            && shootLimit[j] == true) {
            for (int a = 0; a < 5; a++ ) {
              flamePlace [a][0] = enemyX[i];
              flamePlace [a][1] = enemyY[i];
            }     
            enemyY[i] = -1000;
            shootLimit[j] = false;
            counter = 0;
            scoreChange(20);
          }
        }

        if (isHit(fighterX, fighterY, fighter.width, fighter.height
          , enemyX[i], enemyY[i], enemy.width, enemy.height) == true) {
          for ( j = 0; j < 5; j++ ) {
            flamePlace [j][0] = enemyX[i];
            flamePlace [j][1] = enemyY[i];
          }
          enemyY[i] = -1000;
          counter = 0; 
          hpChange(- 20);
        } else if (hpL <= 0) {
          dieReset();
        }
      }

      enemyChange(2);
      break;
    case ENEMY_STATE3:
      drawEnemy();
      for (  i = 0; i < 8; i++ ) {    
        for (  j = 0; j < 5; j++ ) {
          if (isHit(shootX[j], shootY[j], shoot.width, shoot.height
            , enemyX[i], enemyY[i], enemy.width, enemy.height) == true
            && shootLimit[j] == true) {
            for (int a = 0; a < 5; a++) {
              flamePlace [a][0] = enemyX[i];
              flamePlace [a][1] = enemyY[i];
            }
            enemyY[i] = -1000;
            shootLimit[j] = false;
            counter = 0; 
            scoreChange(20);
          }
        }       

        if (isHit(fighterX, fighterY, fighter.width, fighter.height
          , enemyX[i], enemyY[i], enemy.width, enemy.height) == true) {
          for (  j = 0; j < 5; j++ ) {
            flamePlace [j][0] = enemyX[i];
            flamePlace [j][1] = enemyY[i];
          }
          hpChange(-20);
          enemyY[i] = -1000;
          counter = 0;
        } else if ( hpL <= 0 ) {
          dieReset();
        }
      }

      enemyChange(0);
      break;
    }
    fill(255, 0, 0);
    rect(20, 20, hpL, 30, 7);
    image(hp, 10, 20);

    if (isHit(fighterX, fighterY, fighter.width, fighter.height, treasureX, treasureY, treasure.width, treasure.height) == true) {
      treasureX = floor( random(50, 610) );         
      treasureY = floor( random(50, 420) );
      if (hpL < hpMax) {
        hpChange(10);
      }
    }  

    closestEnemy(fighterX, fighterY);

    fill(255);
    text("Score:" + scoreNum, 10, 470);       
    text("Closest Enemy Index:" + closestEnemyIndex, 100, 470);
    break;
  case GAME_LOSE:
    if (mouseX > width/2-120 
      && mouseX <width/2+120 
      && mouseY >height/2+60 
      && mouseY<height/2+110) {
      image(end1, 0, 0);
      if (mousePressed) {
        gameState=GAME_START;
        enemyState=ENEMY_STATE;
        for ( i = 0; i < 5; i++ ){
          flamePlace [i][0] = 1000;
          flamePlace [i][1] = 1000;
          shootLimit[i] = false;       
        }
      }
    } else {
      image(end2, 0, 0);
    }
    break;
  }
}

void drawEnemy() {
  for ( i = 0; i < enemyCount; ++i) {
    if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemy, enemyX[i], enemyY[i]);
      enemyX[i]+=5;
    }
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{	
  for (int i = 0; i < enemyCount; ++i) {
    enemyX[i] = -1;
    enemyY[i] = -1;
  }
  switch (type) {
  case 0:
    addStraightEnemy();
    break;
  case 1:
    addSlopeEnemy();
    break;
  case 2:
    addDiamondEnemy();
    break;
  }
}

void addStraightEnemy()
{
  float t = random(height - enemy.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h;
  }
}
void addSlopeEnemy()
{
  float t = random(height - enemy.height * 5);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h + i * 40;
  }
}
void addDiamondEnemy()
{
  float t = random( enemy.height * 3, height - enemy.height * 3);
  int h = int(t);
  int x_axis = 1;
  for (int i = 0; i < 8; ++i) {
    if (i == 0 || i == 7) {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h;
      x_axis++;
    } else if (i == 1 || i == 5) {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 1 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 1 * 40;
      i++;
      x_axis++;
    } else {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 2 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
}
boolean isHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh) {
  if (ax >= bx - aw && ax <= bx + bw && ay >= by - ah && ay <= by + bh) {
    return true;
  }
  return false;
}

void hpChange(int value) {
  hpL += value * hpNow;
}
void scoreChange(int value) {
  scoreNum += value;
}
void enemyChange(int state) {
  if (enemyX[5] == -1 && enemyX[4] > width + 200) {        
    enemyState = state;
    addEnemy(state);
  } else if (enemyX[7] > width + 400) {
    enemyState = state;
    addEnemy(state);
  }
}

void dieReset() {
  gameState = 2 ;
  hpL = 20 * hpNow;
  fighterX = 550;
  fighterY = height/2-120;
  treasureX = floor( random(50, 600) );
  treasureY = floor( random(50, 420) );
  scoreNum = 0;
}
int closestEnemy(int nowFighterX, int nowFighterY) {
  float enemyDistance = 1000;
  if (enemyX[7] > width || enemyX [5] == -1 && enemyX[4] > width) {
    closestEnemyIndex = -1;
  } else {    
    for ( int a = 0; a < 8; a++ ) {
      if ( enemyX[a] != -1 ) {        
        if ( dist(nowFighterX, nowFighterY, enemyX [a], enemyY [a]) < enemyDistance) {
          enemyDistance = dist(nowFighterX, nowFighterY, enemyX [a], enemyY [a]);
          closestEnemyIndex = a;
        }
      }
    }
  }  
  return closestEnemyIndex;
}
void keyPressed () {
  if (key == CODED) { 
    switch ( keyCode ) {
    case UP :
      upPressed = true ;
      break ;
    case DOWN :
      downPressed = true ;
      break ;
    case LEFT :
      leftPressed = true ;
      break ;
    case RIGHT :
      rightPressed = true ;
      break ;
    }
  }
}
void keyReleased () {
  if (key == CODED) { 
    switch ( keyCode ) {
    case UP : 
      upPressed = false ;
      break ;
    case DOWN :
      downPressed = false ;
      break ;
    case LEFT :
      leftPressed = false ;
      break ;
    case RIGHT :
      rightPressed = false ;
      break ;
    }
  }
  if (keyCode == ' ') {
    if (gameState ==  1) {
      if ( shootLimit[bullet] == false ) {
        shootLimit[bullet] = true;
        shootX[bullet] = fighterX - 10;
        shootY[bullet] = fighterY + fighter.height/2;
        bullet ++;
      }   
      if ( bullet > 4 ) {
        bullet = 0;
      }
    }
  }
}
void mousePressed () {
 if ( gameState == GAME_LOSE
    && mouseX > 200 && mouseX < 470 && mouseY > 300 && mouseY < 350) {
    if ( mouseButton == LEFT ) {
      addEnemy(0);
      for (int i = 0; i < 5; i++ ) {
        flamePlace [i][0] = 1000;
        flamePlace [i][1] = 1000;
        shootLimit[i] = false;
      }
    }
  }
}
