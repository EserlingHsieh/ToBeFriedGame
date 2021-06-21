class Music{
  PImage musicbg,musicroad,musicroadBottom;
  PImage musicball00,musicball1,musicball2;
  PImage musicglowball0,musicglowball0_L,musicglowball0_R,musicglowball1,musicglowball2;
  PImage musicbutton0;
  Song currentSong;
  int playerOffsetFix = 120; //scroll accuray config bro62
  int danceCount = 0;
  int waitToDance = 0;
  boolean left, up, right;
  PImage [] danceImages;
  PImage [] flourImages;
  int flourImageTotal = 8;
  PImage movingFlour,musicExplain;
  float movingFlourY1=0;
  float movingFlourY2=0;
  float targetScore=24000;
  float perfectScore=27000;
  int countFlourDrop=0;
  boolean hadStartToPlay=false;
  int countExplain = 0;
  Minim mainMinim;
  
  void setup(Minim mainMinim) {
    size(1280, 800, P2D);
    frameRate(60);
    musicbg = loadImage("img/music/musicbg.png");
    musicroad = loadImage("img/music/musicroad.png");
    musicroadBottom = loadImage("img/music/musicroad_bottom.png");
    musicball00 = loadImage("img/music/musicball00.png");  
    musicball1 = loadImage("img/music/musicball1.png");
    musicball2 = loadImage("img/music/musicball2.png");
    musicglowball0 = loadImage("img/music/musicglowball0.png");
    musicglowball0_L = loadImage("img/music/musicglowball0_L.png");
    musicglowball0_R = loadImage("img/music/musicglowball0_R.png");
    musicbutton0 = loadImage("img/music/musicbutton0.png"); 
    movingFlour = loadImage("img/music/movingFlour.png"); 
    musicExplain = loadImage("img/music/musicExplain.png");
    this.mainMinim = mainMinim;
    
    danceImages = new PImage[8];
    for(int i=0;i<8;i++){
    danceImages[i] = loadImage("img/music/dance"+i+".png"); }
  
    flourImages = new PImage[flourImageTotal];
    for(int i=0;i<flourImageTotal;i++){
      flourImages[i] = loadImage("img/music/flourDrop"+i+".png"); }
  
    currentSong = new SongPlay("kaikai_kitan");
  }
  
  void draw(){
    image(musicbg,0,0);
    image(musicroad,640,0);
    
    //dancing & flour counter
    if(!currentSong.waitForStart){
      waitToDance = (waitToDance + 1) % 5;
    }
    
    //flour
    if(!currentSong.waitForStart){
      image(flourImages[countFlourDrop],0,0);
      if(waitToDance==0){
        if(countFlourDrop==7){
          countFlourDrop=2;
        }
        else{
          countFlourDrop+=1;
        }
      }
    }
    
    //background lower flour
    //200target 0perfect
    if(currentSong.score<=targetScore){
      image(movingFlour,0,700-movingFlourY1);
      movingFlourY1=500*(float(currentSong.score)/targetScore);
    }else{
      image(movingFlour,0,200-movingFlourY2);
      println(movingFlourY2);
      movingFlourY2=min(200,200*((currentSong.score-targetScore)/(perfectScore-targetScore)));
    }
    
   
      
    strokeWeight(3);
    line(480,640,1280,640);
    //image(musicbutton0,860,620);
    currentSong.draw();
    
    //dancing
    if(currentSong.waitForStart){
      image(danceImages[3],0,0);}
    else{
      image(danceImages[danceCount],0,0);
      if(waitToDance==0){
        if(danceCount==7){
          danceCount=0;
        }
        else{  
          danceCount+=1;
        }
      }
    }
    /*if(currentSong.score>=targetScore){
      scale(0.45);
      image(danceImages[danceCount],0,480);
      image(danceImages[danceCount],250,480);
    }*/
    
    if(!hadStartToPlay){
      image(musicExplain,0,0);
    }
  }
       
  
  void keyPressed(){
    
    if(key==' '){
      currentSong.play();
      hadStartToPlay=true;
    }
       
    if(key==CODED){
      switch(keyCode){
        case LEFT:
          //drum.trigger();
          left = true;
          break;
        case UP:
          //drum.trigger();
          up = true;
          break;
        case RIGHT:
          //drum.trigger();
          right = true;
          break;
      }
    }
  }
}
  
