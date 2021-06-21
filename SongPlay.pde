class SongPlay extends Song{
  MusicNote notes;
  final int perfectScore = 100, normalScore = 50, badScore = 10;
  int pulseColor;
  
  SongPlay(String name){
    super(name);
    notes = new MusicNote(name, frameSpace); 
  }
  
  void scoreCheck(){
    //println("Count: "+frameCounter+",Current: "+getCurrentFrame());
    int nextR = badThreshold + 1;
    int nextU = badThreshold + 1;
    int nextL = badThreshold + 1;
    for(int i = lateFrameOffset; i < badThreshold; i++){
      if(currentFrameIndex + i >= durationFrames){
        return;
      }
      if(notes.nodes[currentFrameIndex + i].has(Node.R)){
        nextR = min(i, nextR);
      }
      if(notes.nodes[currentFrameIndex + i].has(Node.U)){
        nextU = min(i, nextU);
      }
      if(notes.nodes[currentFrameIndex + i].has(Node.L)){
        nextL = min(i, nextL);
      }
    }
    checkBuffer(bufferR, nextR, Node.R);
    checkBuffer(bufferL, nextL, Node.L);
    checkBuffer(bufferU, nextU, Node.U);
  }
  
  void checkBuffer(boolean bufferKey, int nextKeyIndex, Node nodeType){
    if(bufferKey && nextKeyIndex <= badThreshold){
      notes.nodes[currentFrameIndex + nextKeyIndex] = notes.nodes[currentFrameIndex + nextKeyIndex].remove(nodeType);
      if(nextKeyIndex <= perfectThreshold){
        //perfect
        score += perfectScore;
        notes.addScoredNode(new ScoredNode(Score.PERFECT, nodeType, currentFrameIndex + nextKeyIndex));
      }
      else if(nextKeyIndex <= normalThreshold){
        //normal
        score += normalScore;
        notes.addScoredNode(new ScoredNode(Score.GOOD, nodeType, currentFrameIndex + nextKeyIndex));
      }
      else{
        score += badScore;
        notes.addScoredNode(new ScoredNode(Score.BAD, nodeType, currentFrameIndex + nextKeyIndex));
      }
    }
  }
  
  void play(){
    super.play();
    score = 0;
  }
  
  void onPlaying(){
    scoreCheck();
    
    fill(0);
    //textSize(20);
    //text("Score: "+score, 30, 400);
    
    //Wave
    if(getCurrentWavePeak() > waveThreshold || bufferR || bufferL || bufferU){
      pulseColor = 0;
    }
    else
    {
      pulseColor = min(255, pulseColor + 30);
    }
    stroke(255,pulseColor,pulseColor);
    //fill(255,pulseColor,pulseColor);
    //circle(30, 250, 20);
    
    strokeWeight(5);
    line(480, 640, 1280, 640);
    strokeWeight(2);
    
    stroke( 255 );
    float shift = currentFrameIndex * frameSpace;
    pushMatrix();
    translate(480, 640 - notes.noteHeight + shift);
    //line( 0, 0, 800, 0 );
    notes.draw(currentFrameIndex);
    popMatrix();
  }
}
