PFont word;
int[] boom=new int[100];
int[] exarray=new int[100];
int[] eyarray=new int[100];
int[] shootx=new int[100];
int[] shooty=new int[100];
int[] disappear=new int[100];
int numFrames=5;
PImage [] images = new PImage[numFrames];
PImage boom1;
PImage boom2;
PImage boom3;
PImage boom4;
PImage boom5;
PImage s;
PImage p0;
PImage p1;
PImage e;
PImage f;
PImage hp;
PImage t;
PImage s1;
PImage s2;
PImage e1;
PImage e2;
int boomx;
int boomy;
int snum;
int scount;
int px;
int pg;
int r;
int q;
int w;
int fx;
int fy;
int type;
int tx;
int ty;
int score;
int blood = 40;
int game = 1;
boolean hit = false;
boolean up = false;
boolean down = false;
boolean right = false;
boolean left = false;

void setup () {
  size(640, 480);
  word = createFont("Arial", 24);
  background(255);
  for (int i=0; i<numFrames; i++) 
  {
    images[i] = loadImage("img/flame" + (i+1) + ".png");
  }
  p0 = loadImage("img/bg1.png");
  p1 = loadImage("img/bg2.png");
  e = loadImage("img/enemy.png");
  f = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  t = loadImage("img/treasure.png");
  s1 = loadImage("img/start1.png");
  s2 = loadImage("img/start2.png");
  e1 = loadImage("img/end1.png");
  e2 = loadImage("img/end2.png");
  s = loadImage("img/shoot.png");
  score = 0;
  px = 0;
  pg = -640;
  snum = 0;
  scount = 0;
  r = floor(random(200));
  tx = floor(random(600));
  ty = floor(random(400));
  for (int x = 0; x < 100; x++ ) 
  {
    disappear[x] = 0;
    shootx[x] = -1000;
  }
  fx=580;
  fy=240;
  type=0;
  addEnemy(type);
}

void draw()
{
  background(255);

  switch(game) {
    case (1):    
    image(s1, 0, 0);
    if (mouseX<=200+255&&mouseX>=200&&mouseY<=370+42&&mouseY>=370) {
      image(s1, 0, 0);
      if (mousePressed) {
        game=2;
      }
    } else {
      image(s2, 0, 0);
    }    
    break;

    case (2):

    q = floor(random(600));
    w = floor(random(400));

    if (down) {
      fy+=10;
    }
    if (up) {
      fy-=10;
    }
    if (right) {
      fx+=10;
    }
    if (left) {
      fx-=10;
    }
    if (fx>590) {
      fx=600;
    }
    if (fx<0) {
      fx=-10;
    }
    if (fy>430) {
      fy=440;
    }
    if (fy<0) {
      fy=-10;
    }

    px = px+1;
    if (px==640)px=-640; 
    pg = pg+1;
    if (pg==640)pg=-640;
    image(p0, px, 0);
    image(p1, pg, 0);


    for (int i = 0; i < 8; ++i) {
      if (exarray[i] != -1 || eyarray[i] != -1) 
      {
        exarray[i]+=4;
      }
    }

    for (int i = 0; i < 5; ++i) {
      if (shootx[i]!=-1000 ) 
      {
        image(s, shootx[i], shooty[i]);
        shootx[i]-=5;
      }
      if (shootx[i]<=-30)
      {
        shootx[i]=-1000;
      }
    }
    
    for (int x = 0; x < 8; x++ )
    {     
      if (exarray[x] != -1 || eyarray[x] != -1) 
      {
        if ( isHit(fx, fy, f.width, f.height, exarray[x], eyarray[x], e.width, e.height) == true && disappear[x]==0 )
        {
          disappear[x]=1;
          blood-=40;

          if (boom[x]>5) {
            boom[x]=0;
          }

          if (blood<=0) {
            blood=40;
            game=3;
          }
        } else if (disappear[x] == 1) {
        } else
        {
          image(e, exarray[x], eyarray[x]);
        }
      }
      for (int i = 0; i < 5; i++ )
      {
        if (isHit(shootx[i], shooty[i], s.width, s.height, exarray[x], eyarray[x], e.width, e.height) == true && disappear[x]==0 && shootx[i]!=-1000 )
        {
          scoreChange(20);
          disappear[x] = 1;
          shootx[i]=-1000;
          if (boom[x]>5) {
            boom[x]=0;
          }
        }
      }
      
      if (disappear[x] == 1)
      { 
        if (frameCount % (6) == 0) 
        {
          boom[x]++;
        }

        if (boom[x]<5)
        {
          image(images[boom[x]], exarray[x], eyarray[x]);
        }
      }
    }
    
    if (exarray[5] == -1 && exarray[4]>=640)
    {
      type++;
      addEnemy(type%3);
      for (int y = 0; y < 100; y++ ) {
        disappear[y] = 0;
      }
    } else if (exarray[7]>=640)
    {
      type++;
      addEnemy(type%3);
      for (int y = 0; y < 18; y++ ) {
        disappear[y] = 0;
      }
    }

    if (isHit(fx, fy, f.width, f.height, tx, ty, t.width, t.height) == true)
    {
      image(t, q, w);
      tx=q;
      ty=w;
      if (blood<200) {
        blood+=20;
      }
    } else {
      image(t, tx, ty);
    }

    image(f, fx, fy);

    fill(255, 48, 48);
    rect(10, 10, blood, 20);
    image(hp, 5, 5);

    textFont(word, 30);
    textAlign(CENTER);
    fill(255);
    text("Score:", 50, 450);
    text(score, 130, 450);

    break;

    case (3):
    score = 0;
    image(e1, 0, 0);
    if (mouseX<=200+232&&mouseX>=200&&mouseY<=304+42&&mouseY>=304) {
      image(e1, 0, 0);
      if (mousePressed) {
        game=2;
      }
    } else {
      image(e2, 0, 0);
    }
    break;
  }
}

void addEnemy(int type)
{  
  for (int i = 0; i < 8; ++i) {
    exarray[i] = -1;
    eyarray[i] = -1;
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
  float t = random(height - e.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {
    exarray[i] = (i+1)*-80;
    eyarray[i] = h;
  }
}

void addSlopeEnemy()
{
  float t = random(height - e.height * 5);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {
    exarray[i] = (i+1)*-80;
    eyarray[i] = h + i * 40;
  }
}

void addDiamondEnemy()
{
  float t = random( e.height * 3, height - e.height * 3);
  int h = int(t);
  int x_axis = 1;
  for (int i = 0; i < 8; ++i) {
    if (i == 0 || i == 7) {
      exarray[i] = x_axis*-80;
      eyarray[i] = h;
      x_axis++;
    } else if (i == 1 || i == 5) {
      exarray[i] = x_axis*-80;
      eyarray[i] = h + 1 * 40;
      exarray[i+1] = x_axis*-80;
      eyarray[i+1] = h - 1 * 40;
      i++;
      x_axis++;
    } else {
      exarray[i] = x_axis*-80;
      eyarray[i] = h + 2 * 40;
      exarray[i+1] = x_axis*-80;
      eyarray[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
}

void keyPressed() {
  if (key==CODED) {
    switch(keyCode) {
    case DOWN:
      down = true;
      break;  
    case UP:
      up = true;
      break;
    case RIGHT:
      right = true;
      break;
    case LEFT:
      left = true;
      break;
    }
  }
  if (key==' ')
  {
    scount=0;
    for(int a=0;a<5;a++)
    {if(shootx[a]!=-1000){scount++;}}
    if(scount<5)
    {
    shootx[snum%5] = fx;
    shooty[snum%5] = fy+10;
    snum++;}
  }
}

boolean isHit(float ax, float ay, int aw, int ah, float bx, float by, int bw, int bh) {
  if (ay+ah>by && ay<by+bh)
    if (ax+aw>bx && ax<bx+bw)
      return true;
  return false;
}

void scoreChange(int value)
{
  score+=value;
}

void keyReleased() {
  if (key==CODED) {
    switch(keyCode) {
    case DOWN:
      down = false;
      break;  
    case UP:
      up = false;
      break;
    case RIGHT:
      right = false;
      break;
    case LEFT:
      left = false;
      break;
    }
  }
}
