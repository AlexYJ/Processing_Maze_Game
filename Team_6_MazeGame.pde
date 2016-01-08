int stage = 0;  //current stage (0~2)
int maxStage = 2;

PImage imgStage0;
PImage imgStage1;
PImage imgStage2;
PImage imgChar;  //image of character
PImage imgbk;

int charX = 0;  
int charY = 0;
int charWidth = 50;  //unit: px
int charHeight = 50;  //unit: px

int dx;  //when key pressed, to check with this input buffer 
int dy;

int pxUnit = 50;  //to show images, should multiple this value (ex: charX*pxUnit)
int boardSize = 10;  //size of board

//define constants
final int PATH = 0;
final int WALL = 1;
final int START_POINT = 2;
final int END_POINT = 3;
//board value==0 means 'path'
//board value==1 means 'wall'
//board value==2 means 'start-point'
//board value==3 means 'end-point'


  import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

//each array means [stage][y-val][x-val]
int[][][] boardStage = {
  {  
    {  //stage-0
      2, 1, 0, 1, 0, 0, 0, 1, 1, 1
    }
    , 
    {
      0, 1, 0, 0, 0, 1, 0, 0, 0, 1
    }
    , 
    {
      0, 1, 0, 1, 1, 1, 1, 0, 1, 1
    }
    , 
    {
      0, 1, 0, 0, 0, 0, 1, 0, 0, 1
    }
    , 
    {
      0, 1, 0, 1, 0, 1, 1, 1, 0, 0
    }
    , 
    {
      0, 1, 0, 1, 0, 0, 0, 1, 0, 1
    }
    ,
    {
      0, 1, 0, 1, 0, 1, 1, 1, 0, 0
    }
    ,
    {
      0, 0, 0, 1, 0, 0, 0, 1, 1, 0
    }
    ,
    {
      0, 1, 1, 1, 1, 1, 1, 0, 1, 0
    }
    ,
    {
      0, 0, 0, 0, 0, 0, 0, 0, 1, 3
    }
  }
  , 
  {  
    {  //stage-1
      2, 0, 0, 0, 0, 0, 1, 1, 1, 1
    }
    , 
    {
      0, 1, 1, 1, 1, 0, 1, 0, 0, 0
    }
    , 
    {
      0, 1, 0, 0, 0, 0, 1, 0, 1, 0
    }
    , 
    {
      0, 1, 0, 1, 0, 1, 1, 0, 1, 0
    }
    , 
    {
      0, 0, 0, 1, 0, 0, 0, 0, 1, 0
    }
    , 
    {
      1, 1, 0, 1, 1, 1, 1, 1, 0, 0
    }
    ,
    {
      0, 1, 0, 1, 0, 0, 0, 0, 1, 0
    }
     ,
    {
      0, 0, 0, 1, 0, 1, 0, 1, 1, 1
    }
     ,
    {
      0, 1, 1, 1, 0, 1, 0, 0, 0, 0
    }
     ,
    {
      0, 0, 0, 0, 0, 1, 0, 1, 1, 3
    }
  }
  , 

  {  
    {  //stage-2
      2,1,0,0,0,0,0,0,0,0
    }
    , 
    {
      0,1,1,0,1,0,1,1,1,0
    }
    , 
    {
     0,0,1,1,1,0,1,0,0,0
    }
    , 
    {
      1,0,0,1,0,0,1,0,1,1
    }
    , 
    {
      1,1,0,1,1,0,1,0,0,1
    }
    , 
    {
     0,1,0,0,0,0,1,0,1,1
    }
    , 
    {
     0,1,1,1,0,1,0,0,0,0
    }
    , 
    {
     0,0,0,0,0,1,0,1,1,0
    }
    , 
    {
     0,1,1,1,1,1,0,1,0,0
    }
    , 
    {
     0,0,0,0,0,0,0,1,1,3
    }
}
};

void setup() {  //initialize
  size(500,500);
  smooth();
  imgStage0 = loadImage("imgstage0.png");
  imgStage1 = loadImage("imgstage1.png");
  imgStage2 = loadImage("imgstage2.png");
  imgChar = loadImage("imgchar.png");
  minim = new Minim(this);
  player = minim.loadFile("Shall We Take A Turn.mp3", 2048);
  player.play();
}

void draw() {  //draw all

  // Draw Maze
  background(255);  //bg color
  
  if (stage == 0) {
    image(imgStage0, 0, 0);  //stage0 map image
  }
  if (stage == 1) {
    image(imgStage1, 0, 0);  //stage1 map image
  }
  if (stage == 2) {
    image(imgStage2, 0, 0);  //stage2 map image
  }

  image(imgChar, charX*pxUnit, charY*pxUnit, charWidth, charHeight);  //show character
}

void keyPressed() {  //process key event
  dx = 0;
  dy = 0;

  if (keyCode == UP) {
    dy--;
  }
  else if (keyCode == DOWN) {
    dy++;
  }
  if (keyCode == LEFT) {
    dx--;
  }
  else if (keyCode == RIGHT) {
    dx++;
  }

  if (isMovable()) {
    charX+=dx;
    charY+=dy;
  }

  if (isEndPoint()) {  
    //clear stage

    if (stage==2) { //Game clear!
      javax.swing.JOptionPane.showMessageDialog(null, "Cougratulations! You've clear all stage!");  //show msgbox
      exit();
    } else {
      javax.swing.JOptionPane.showMessageDialog
        (null, "Congratulation! Let's go to stage " + (stage+2));  //show msgbox
        
      //stage++;   
      stage++;
      //move character to startpoint
      charX=0;
      charY=0;
    }
  }
}

//judge character can be movable
boolean isMovable()  
{
  //check inside board?
  if (charX+dx < boardSize && charX+dx >= 0
    && charY+dy < boardSize && charY+dy >= 0
    ) {
    //check is there a no wall?
    if (boardStage[stage][charY+dy][charX+dx] != WALL) {
    } 
    else {  //wall!
      return false;
    }
  }
  else {  //out of board!
    return false;
  }

  return true;
}

//judge character reach end-point
boolean isEndPoint() {
  if (boardStage[stage][charY][charX] == END_POINT) {
    return true;
  } 
  else {
    return false;
  }
}

