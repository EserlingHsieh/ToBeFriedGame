import ddf.minim.*;

PImage rpgFront,rpgBack,rpgFrontRight,rpgFrontLeft,rpgBackRight,rpgBackLeft;
PImage rpgLeftIdle,rpgLeftFront,rpgLeftBack,rpgRightIdle,rpgRightFront,rpgRightBack;
PImage rpgBg0,rpgBg1,rpgMain,rpgMainHovered,ticket,rpgExplain;
PImage explain[];
PImage explainhovered[];
PImage rpgPhoto[];
PImage rpgHeart,gameLose,gameLoseHovered;
PImage yesOil,noOil,yesEgg,noEgg,yesFlour,noFlour;

final int RPG_UNIT=96;
final int RPG_EDGE_X=16;
final int RPG_EDGE_Y=64;

boolean rpgChangeStage = false;
boolean rpgSpaceClick= false;
float rpgBgX=0;
int rpgLeftEdge,rpgRightEdge;

boolean rpgToRight=false;
boolean rpgToLeft=false;
boolean rpgStartTalk=false;

int [][] rpgMapL;
int [][] rpgMapR;

Rpgplayer rpgplayer;
Rpgtalk rpgtalk;

PFont myFont;
String playerName;//will change
int rpgHealth=3;

Console c = new Console(290,417,80,-5);

final int GAME_START = 0, GAME_TICKET = 1,GAME_RPG = 2, 
GAME_OVER = 3, GAME_WIN = 4,
GAME_MUSIC = 5,GAME_CROSSY = 6,GAME_PACMAN = 7;
int gameState = 0;

boolean rpgOil=false;
boolean rpgEgg=false;
boolean rpgFlour=false;

boolean rpgSongIsPlaying=false;
boolean rpgExplaining=false;
boolean rpgStoryTelling=true;
int rpgStoryClicking=0;

Minim minim;
AudioSample dogoClick,walking,bigClick;
AudioPlayer rpgSong, rpgStart, gameWinSong;

Music music;

void setup() {
  size(1280, 800, P2D);
  frameRate(60);
  rpgBg0 = loadImage("img/rpg/bg0.png");
  rpgBg1 = loadImage("img/rpg/bg1.png");
  rpgMain = loadImage("img/rpgMain.png");
  rpgMainHovered = loadImage("img/rpgMainHovered.png");
  gameLose = loadImage("img/rpg/gameLose.png");
  gameLoseHovered = loadImage("img/rpg/gameLoseHovered.png");
  ticket = loadImage("img/ticket.png");
  rpgFront = loadImage("img/rpg/front.png");
  rpgBack = loadImage("img/rpg/back.png");
  rpgBackRight = loadImage("img/rpg/backRight.png");
  rpgBackLeft = loadImage("img/rpg/backLeft.png");
  rpgFrontRight = loadImage("img/rpg/frontRight.png");
  rpgFrontLeft = loadImage("img/rpg/frontLeft.png");
  rpgRightIdle = loadImage("img/rpg/rightIdle.png");
  rpgRightFront = loadImage("img/rpg/rightFront.png");
  rpgRightBack = loadImage("img/rpg/rightBack.png");
  rpgLeftIdle = loadImage("img/rpg/leftIdle.png");
  rpgLeftFront = loadImage("img/rpg/leftFront.png");
  rpgLeftBack = loadImage("img/rpg/leftBack.png");
  rpgHeart = loadImage("img/rpg/rpgHeart.png");
  yesOil = loadImage("img/rpg/yesOil.png");
  noOil = loadImage("img/rpg/noOil.png");
  yesEgg = loadImage("img/rpg/yesEgg.png");
  noEgg = loadImage("img/rpg/noEgg.png");
  yesFlour = loadImage("img/rpg/yesFlour.png");
  noFlour = loadImage("img/rpg/noFlour.png");
  rpgExplain = loadImage("img/rpg/rpgExplain.png");
  explain =new PImage[6];
  explainhovered =new PImage[6];
  for(int i=0;i<6;i++){
    explain[i] = loadImage("img/rpg/explain"+i+".png");
    explainhovered[i] = loadImage("img/rpg/explainhovered"+i+".png");
  }
  //load npc image
  rpgPhoto = new PImage[13];//npc number+player
  for(int j = 0; j < 13; j++){ //13=allnpc+player+1
    rpgPhoto[j] = loadImage("img/rpg/"+"rpgPhoto"+j+".png");}
  
  myFont=createFont("font/Silver.ttf",45);
  
  minim = new Minim(this);
  dogoClick = minim.loadSample("sound/dogoClick.mp3");
  bigClick = minim.loadSample("sound/bigClick.mp3");
  walking = minim.loadSample("sound/walking.mp3");
  rpgSong = minim.loadFile("sound/rpgBackground.mp3");
  rpgStart = minim.loadFile("sound/rpgStart.mp3");
  gameWinSong = minim.loadFile("sound/gameWinSong.mp3");
  

  // Initialize Game
  initGame();
 
 }

void initGame(){
  rpgplayer= new Rpgplayer();
  rpgtalk= new Rpgtalk();
  rpgBgX=0;
  rpgOil=false;
  rpgEgg=false;
  rpgFlour=false;
  
 //rpgMapL
  rpgMapL = new int [7][13];
  for(int i=0;i<rpgMapL.length;i++){
    for(int k=0; k<rpgMapL[i].length;k++){
      rpgMapL[i][k]=0;}
  }
  for(int i=0; i<3;i++){
    rpgMapL[i][3]=1;
    rpgMapL[i][5]=1;
    rpgMapL[i][6]=1;
    rpgMapL[i][8]=1;
  }
  for(int i=4; i<7;i++){
    rpgMapL[i][3]=1;
    rpgMapL[i][5]=1;
  }
  for(int i=2; i<5;i++){
    rpgMapL[i][11]=1;
    rpgMapL[i][12]=1;
  }
    rpgMapL[1][12]=1;
    rpgMapL[5][12]=1;
  
  //npc where
  rpgMapL[3][11]=2;
  rpgMapL[0][6]=6;
  rpgMapL[2][1]=7;
  rpgMapL[6][3]=10;
  rpgMapL[2][8]=3;
  rpgMapL[1][6]=11;
    
  //rpgMapR
  rpgMapR = new int [7][13];
  for(int i=0;i<rpgMapR.length;i++){
    for(int k=0; k<rpgMapR[i].length;k++){
      rpgMapR[i][k]=0;}
  }
  for(int i=1; i<6;i++){
    rpgMapR[i][1]=1;
    rpgMapR[i][2]=1;
    rpgMapR[i][3]=1;
  }
  for(int k=7; k<10;k++){
    rpgMapR[4][k]=1;
    rpgMapR[6][k]=1;
  }
    rpgMapR[2][10]=1;
    //fixing edge for win time
    for(int i=0;i<7;i++){
    rpgMapR[i][11]=1;
    rpgMapR[i][12]=1;
    }
  //npc where  
  rpgMapR[4][7]=5;
  rpgMapR[6][8]=12;
  rpgMapR[4][9]=4;
  rpgMapR[2][8]=8;
  rpgMapR[2][9]=9;
  
 
   //Load sub game
  music = new Music();
  music.setup(minim);
  
  rpgSong.rewind();
  rpgStart.rewind();
  rpgStart.loop();
  gameWinSong.rewind();
  
  rpgSongIsPlaying=false;
  rpgExplaining=false;
  rpgStoryTelling=true;
  rpgStoryClicking=0;
  
  c.reset();
}


void draw(){  
  
  switch (gameState) {

    case GAME_START: 
      rpgSpaceClick=false;
      if(mouseX>=518 && mouseX<=773 && mouseY>=553 &&mouseY<=608){
        image(rpgMainHovered,0,0); 
        if(mousePressed){
          dogoClick.trigger();
          gameState = GAME_TICKET;
          mousePressed = false;}
      }else{
        image(rpgMain,0,0);}
    break;
    
    case GAME_TICKET:
      image(ticket,0,0);
      textFont(myFont);
      fill(64, 94, 99);
      c.activate();
      c.display();
      
      if(rpgSpaceClick){
        playerName=c.readString();
        rpgtalk.assignPlayerName();
        bigClick.trigger();
        //println(playerName);
        gameState = GAME_RPG;
        rpgSpaceClick=false;
      }
      break;
      
    
    case GAME_RPG:
  if(rpgToRight || rpgToLeft){
    rpgLeftEdge=0;
    rpgRightEdge=0;
  }
  else if(rpgBgX==0){
  rpgLeftEdge=1;
  rpgRightEdge=0;}
  else if(rpgBgX==-1280){
  rpgLeftEdge=0;
  rpgRightEdge=-2;}
  
  if(rpgOil==true && rpgEgg==true &&rpgFlour==true){ 
    image(rpgBg1,rpgBgX,0);}
  else{  
    image(rpgBg0,rpgBgX,0);}
  
   rpgplayer.update();
   if(rpgStartTalk||rpgtalk.rpgTalkMode){
   rpgtalk.update();}
  
    //change stage 
//println("x is " + rpgplayer.x + " and Y is " + rpgplayer.y);
if( abs(rpgplayer.col-3)==3 &&
   rpgSpaceClick==true){
     if(rpgplayer.row==12){
     rpgChangeStage=true;
     rpgToRight=true;
     rpgSpaceClick=false;}
     else if( rpgplayer.row==0){
     rpgChangeStage=true;
     rpgToLeft=true;
     rpgSpaceClick=false;
     }
   }
     
  if(rpgChangeStage){
    if(rpgToRight){
    rpgBgX-=8;
      if(rpgBgX==-1280){
      rpgChangeStage=false;
      rpgToRight=false;}
     }
    else if(rpgToLeft){
    rpgBgX+=8;
      if(rpgBgX==0){
      rpgChangeStage=false;
      rpgToLeft=false;}
    }
    
  }
  
  //health
  for(int i=0; i<rpgHealth; i++){
  image(rpgHeart,15+i*110,10);}
  if(rpgHealth==0){
    gameState=GAME_OVER;
  }
  
  //collect item
  if(rpgOil==false){
    image(noOil,965,10);}
  else{
    image(yesOil,965,10);}
  if(rpgEgg==false){
    image(noEgg,1060,10);}
  else{
    image(yesEgg,1060,10);}
  if(rpgFlour==false){
    image(noFlour,1155,10);}
  else{
    image(yesFlour,1155,10);}
    
    //gonna win game
    if(rpgOil==true&&rpgEgg==true&&rpgFlour==true){
      rpgMapR[2][10]=13;
      rpgMapR[2][8]=0;
      rpgMapR[2][9]=0;
    }
  
  if(rpgExplaining){
    image(rpgExplain,0,0);
  }
  
  if(rpgStoryTelling){
    if(mouseX >= 985 && mouseX <= 1049 
    && mouseY >= 349 && mouseY <= 424){
      image(explainhovered[rpgStoryClicking],0,0);
    }else{
      image(explain[rpgStoryClicking],0,0);
    }
  }

  //reset trigger
  rpgSpaceClick=false;
  rpgStartTalk=false;
  
  break;  
  
  case GAME_OVER:
  if(mouseX>=539 && mouseX<=733 && mouseY>=506 && mouseY<=557){
    image(gameLoseHovered,0,0);
  }else{
    image(gameLose,0,0);}
  break;
  
  case GAME_WIN:
  if(rpgStoryClicking<5){
    if(mouseX>=985 && mouseX<=1049 && mouseY>=349 && mouseY<=424){
    image(explainhovered[rpgStoryClicking],0,0);
    }else{
    image(explain[rpgStoryClicking],0,0);}
  }else{
    if(mouseX>=590 && mouseX<=722 && mouseY>=492 && mouseY<=525){
    image(explainhovered[rpgStoryClicking],0,0);
    }else{
    image(explain[rpgStoryClicking],0,0);
    }
  }  
    
  break;
  
  case GAME_MUSIC:
    music.draw();
    if(music.hadStartToPlay && music.currentSong.player.isPlaying()==false){
      if(music.currentSong.score>=music.targetScore){
        rpgFlour=true;
        //rpgMapR[] find and set to 1
        for(int i=0;i<7;i++){
          for(int j=0;j<12;j++){
            //remember to minus 2
            if(rpgMapR[i][j]-2==rpgtalk.whoGameNpc[0]){
              rpgMapR[i][j]=1;
            }
            if(rpgMapL[i][j]-2==rpgtalk.whoGameNpc[0]){
              rpgMapL[i][j]=1;
            }
          }
        }  
      }else{
        rpgHealth--;
        //& reset game
        music = new Music();
        music.setup(minim);
      }
      rpgSong.loop();
      gameState=GAME_RPG;
    }
  break;
  
  case GAME_CROSSY:
  break;
  
  case GAME_PACMAN:
  break;
  }
}
  
  

void keyPressed(){  
  switch(gameState){
    case GAME_RPG:
      if(key==' '){
        if(rpgExplaining){
          rpgExplaining=false;
        }
        rpgSpaceClick=true;
        if(rpgOil==true&&rpgEgg==true&&rpgFlour==true){
          if(rpgplayer.frontMe(rpgplayer.col,rpgplayer.row)==13
            &&rpgtalk.rpgTalkMode==false){
            rpgStartTalk=true;
          }
        }else{  
          if(rpgplayer.frontMe(rpgplayer.col,rpgplayer.row)>1
            &&rpgtalk.rpgTalkMode==false){
            rpgStartTalk=true;
          }
        }
      }
      if(key==CODED){
        if(!rpgChangeStage && !rpgExplaining 
        && !rpgtalk.rpgTalkMode &&!rpgStoryTelling){
          rpgplayer.keyInput(keyCode);
        }
      }
      break;
    case GAME_MUSIC:
      music.keyPressed();
      break;
    case GAME_TICKET:
      if(key==' '){
        rpgSpaceClick=true;
      }
      c.keyPressed();
      break;
  }
} 

void mouseClicked(){
  
  switch (gameState){
    case GAME_RPG:
      if(rpgStoryTelling){
        if(mouseX >= 985 && mouseX <= 1049 
        && mouseY >= 349 && mouseY <= 424){
          bigClick.trigger();
          rpgStoryClicking+=1;
          if(rpgStoryClicking==3){
            rpgStoryTelling=false;
            rpgStart.pause();
            rpgExplaining=true;
            rpgSongIsPlaying=true;
            rpgSong.loop();
          }
        }
      }
    break;
    
    case GAME_WIN:
      if(rpgStoryClicking<5){
        if(mouseX >= 985 && mouseX <= 1049 
        && mouseY >= 349 && mouseY <= 424){
            bigClick.trigger();
            rpgStoryClicking+=1;
        }
      }else{
        if(mouseX >= 590 && mouseX <= 722 
        && mouseY >= 492 && mouseY <= 525){
            bigClick.trigger();
            rpgStoryClicking=0;
            gameState=GAME_START;
            gameWinSong.pause();
            initGame();
        }
      }
    break;
    
    case GAME_OVER:
      if(mouseX>=539 && mouseX<=733 && mouseY>=506 && mouseY<=557){
        gameState=GAME_START;
        initGame();
      }
    break;
    
  }
    
}

  
String keyAnalyzer(char c){
  if (c >= 'a' && c <= 'z' 
    || c >= 'A' && c <= 'Z'){
    return "LETTER";
  }
  else{
    return "OTHER";
  }
}
