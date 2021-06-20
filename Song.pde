class Song{
  Minim minim;
  int score = 0;
  AudioPlayer player;
  int durationFrames;
  int nodeRate = 60;
  float frameSpace = 5f; //how much space between each frame
  float waveThreshold = 1.1f;
  boolean waitForStart = true;
  Node bufferInput;
  
  // accuracy config for scoring
  boolean bufferR, bufferU, bufferL;
  int perfectThreshold = 5;
  int normalThreshold = 10;
  int badThreshold = 15;
  int lateFrameOffset = -5;
  
  int frameCounter = 0;
  float songLength;
  int currentFrameIndex;
  
  Song(String name){
    println(music.mainMinim);
    player = music.mainMinim.loadFile("song/"+name+".mp3");
    songLength = player.length();
    float durationSeconds = songLength/1000f;
    durationFrames = ceil(nodeRate * songLength / 1000f);
    //println("durationSeconds: "+durationSeconds);
    //println("durationFrames: "+durationFrames);
  }
  
  void play(){
    player.play();
    frameCounter = 0;
    waitForStart = false;
  }
  
  void draw(){
    stroke( 255 );
    //text(getCurrentWavePeak(), 30, 180);
    
    stroke( 255, 0, 0 );
    //if need song length running shrimp
    //float position = map( player.position(), 0, songLength, 0, width );
    //line( position, 0, position, height );
    
    currentFrameIndex = int(getCurrentFrame()) + music.playerOffsetFix;
    
    consumeKey();
    
    if(waitForStart){
      return;
    }
    frameCounter++;
    if(player.isPlaying()){
      onPlaying();
    }
    else{
      onEnd();
      waitForStart = true;
    }
  }
  
  void consumeKey(){
    //TODO: multiple input
    bufferR = music.right;
    bufferU = music.up;
    bufferL = music.left;
    bufferInput = music.right ? Node.R : music.up ? Node.U : music.left ? Node.L : Node.NONE;
    music.right = false;
    music.up = false;
    music.left = false;
  }
  
  float getCurrentFrame(){
    return map(player.position(), 0, songLength, 0, durationFrames);
  }
  
  float getCurrentWavePeak(){
    float wavePeak = 0;
    for(int i = 0; i < player.bufferSize() - 1; i++){
      wavePeak = max(wavePeak, abs(player.mix.get(i)));
    }
    return wavePeak;
  }
  
  void onPlaying(){}
  
  void onEnd(){
    println("frameCounted: "+frameCounter);
  }
  
}
