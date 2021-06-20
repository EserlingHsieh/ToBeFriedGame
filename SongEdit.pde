class SongEdit extends Song{
  boolean[] outputNodeSequence;
  PrintWriter output;
  
  SongEdit(String name){
    super(name);
    outputNodeSequence = new boolean[durationFrames];
    output = createWriter("data/note/"+name+"_output.txt");
  }
  
  void onPlaying(){
    if(getCurrentWavePeak() > waveThreshold || bufferInput != Node.NONE){
      fill(255, 0, 0);
      outputNodeSequence[currentFrameIndex] = true;
    }
    else
    {
      fill(255);
    }
    circle(30, 250, 20);
  }
  
  void onEnd(){
    super.onEnd();
    output.println("B = autobeat, O = nothing, A = all, input signal in this order: LUR");
    output.print(durationFrames);
    for(int i = 0; i < outputNodeSequence.length; i++)
    {
      if(i % 60 == 0){
        output.println("");
      }
      output.print(outputNodeSequence[i]? "B__," : "O__,");
    }
    output.flush();
    output.close();
    exit();
  }
}
