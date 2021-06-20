class ScoredNode{
  Node type;
  Score scoreType;
  int frameIndex;
  float effectorScale = 1;
  float effectorAlpha = 255;
  
  ScoredNode(Score s, Node n, int frameId){
    type = n;
    scoreType = s;
    frameIndex = frameId;
  }
}

enum Score{
  PERFECT,
  GOOD,
  BAD,
  MISS
}

enum Node{
  L,
  U,
  R,
  NONE;
  
  boolean has(Node target){
    if(this == target){
      return true;
    }
    else{
      return false;
    }
  }
  
  Node remove(Node target){
    if(target == L){
      switch(this){
        case L:
          return NONE;
        default:
          return this;
      }
    }
    else if(target == R){
      switch(this){
        case R:
          return NONE;
        default:
          return this;
      }
    }
    else if(target == U){
      switch(this){
        case U:
          return NONE;
        default:
          return this;
      }
    }
    else{
      return this;
    }
  }
}

class MusicNote{
  Node[] nodes;
  //PGraphics pg;
  int frameTotal;
  int noteHeight;
  int batchNoteHeight = 8000;
  int batchCount;
  PGraphics[] pgBatch;
  float flexBuffer = 200;
  float frameSpace;
  ArrayList<ScoredNode> scoredNodeDisplayBuffer = new ArrayList<ScoredNode>();
  
  MusicNote(String name, float newFrameSpace){
    String[] lines = loadStrings("data/note/"+name+".txt");
    frameTotal = int(lines[1]);
    nodes = new Node[frameTotal];
    for(int i = 0; i < frameTotal; i++){
      nodes[i] = Node.NONE;
    }
    frameSpace = newFrameSpace;
    noteHeight = ceil(frameSpace * frameTotal);
    batchCount = ceil(noteHeight / float(batchNoteHeight));
    PGraphics arrowL = arrow(Node.L);
    PGraphics arrowR = arrow(Node.R);
    PGraphics arrowU = arrow(Node.U);
    int currentBatchIndex = 0;
    int currentBatchHeight = min(batchNoteHeight, noteHeight - currentBatchIndex * batchNoteHeight);
    pgBatch = new PGraphics[batchCount];
    pgBatch[currentBatchIndex] = createGraphics(800, currentBatchHeight);
    pgBatch[currentBatchIndex].beginDraw();
    pgBatch[currentBatchIndex].imageMode(CENTER);
    pgBatch[currentBatchIndex].stroke(0);
    pgBatch[currentBatchIndex].fill(0);
    for (int i = 2; i < lines.length; i++) {
      String[] lineItems = split(lines[i], ",");
      for(int j = 0; j < lineItems.length - 1; j++)
      {
        int nodeFrameIndex = (i-1) * (lineItems.length - 1) + j;
        float yPosRaw = nodeFrameIndex * frameSpace - currentBatchIndex * batchNoteHeight;
        if(yPosRaw > batchNoteHeight){
          pgBatch[currentBatchIndex].stroke(0,255,0);
          pgBatch[currentBatchIndex].endDraw();
          currentBatchIndex += 1;
          if(currentBatchIndex >= batchCount){
            println("Error! exceed batch");
            return;
          }
          currentBatchHeight = min(batchNoteHeight, noteHeight - currentBatchIndex * batchNoteHeight);
          pgBatch[currentBatchIndex] = createGraphics(800, currentBatchHeight);
          pgBatch[currentBatchIndex].beginDraw();
          pgBatch[currentBatchIndex].imageMode(CENTER);
          pgBatch[currentBatchIndex].stroke(0);
          pgBatch[currentBatchIndex].fill(0);
          yPosRaw = nodeFrameIndex * frameSpace - currentBatchIndex * batchNoteHeight;
        }
        float yPos = currentBatchHeight - yPosRaw;
        if(lineItems[j].charAt(0) == 'L'){
          //pgBatch[currentBatchIndex].circle(240, yPos, 20);
          pgBatch[currentBatchIndex].image(arrowL, 240, yPos);
          //pgBatch[currentBatchIndex].image(musicglowball0_L, 240, yPos);
          nodes[nodeFrameIndex] = Node.L;
        }
        else if(lineItems[j].charAt(0) == 'U'){
          //pgBatch[currentBatchIndex].circle(400, yPos, 20);
          pgBatch[currentBatchIndex].image(arrowU, 400, yPos);
          //pgBatch[currentBatchIndex].image(musicglowball0, 400, yPos);
          nodes[nodeFrameIndex] = Node.U;
        }
        else if(lineItems[j].charAt(0) == 'R'){
          //pgBatch[currentBatchIndex].circle(560, yPos, 20);
          pgBatch[currentBatchIndex].image(arrowR, 560, yPos);
          //pgBatch[currentBatchIndex].image(musicglowball0_R, 560, yPos);
          nodes[nodeFrameIndex] = Node.R;
        }
        else if(lineItems[j].charAt(0) == 'B'){ //TODO: hide B
          pgBatch[currentBatchIndex].circle(400, yPos, 20);
          //pg.image(musicball00,400, getYPos(nodeFrameIndex));
          nodes[nodeFrameIndex] = Node.U;
        }
      }
    }
    pgBatch[currentBatchIndex].endDraw();
    //for(int i = 0; i < batchCount; i++){
    //  pgBatch[i].save("recent_note_"+i+".png");
    //}
  }
  
  float getYPos(int nodeIndex){
    return noteHeight - nodeIndex * frameSpace;
  }
  
  void draw(int currentFrameIndex){
    //image(pg,0,0);
    int topBatchIndex = floor((currentFrameIndex * frameSpace + 640 + flexBuffer) / batchNoteHeight);
    int bottomBatchIndex = max(0, floor((currentFrameIndex * frameSpace - 160 - flexBuffer) / batchNoteHeight));
    for(int i = bottomBatchIndex; i <= topBatchIndex; i++){
      image(pgBatch[i],0,max(noteHeight - (i + 1) * batchNoteHeight, 0));
    }
    int bottomFrameIndex = floor(currentFrameIndex - 160/frameSpace);
    imageMode(CENTER);
    for(int i = scoredNodeDisplayBuffer.size() - 1; i >= 0; i --){
      //L,R,U separate display based on n.type
      ScoredNode n = scoredNodeDisplayBuffer.get(i);
      if(n.frameIndex < bottomFrameIndex - 120){
        scoredNodeDisplayBuffer.remove(i);
      }
      else{
        float r, g, b;
        switch(n.scoreType){
          case PERFECT:
            fill(0, 255, 0);
            r = 0;
            g = 255;
            b = 0;
            break;
          case GOOD:
            fill(255);
            r = 255;
            g = 255;
            b = 255;
            break;
          case BAD:
            fill(0, 0, 255);
            r = 0;
            g = 0;
            b = 255;
            break;
          default:
            fill(0);
            r = 0;
            g = 0;
            b = 0;
            break;
        }
        
        int x ;
        PImage img;
        switch(n.type){
          case L:
            x=240;
            img=music.musicglowball0_L;
            break;
          case R:
            x=560;
            img=music.musicglowball0_R;
            break;
          case U:
            x=400;
            img=music.musicglowball0;
            break;
          default:
            x=400;
            img=music.musicglowball0;
            break;
        }

        //circle(x, getYPos(n.frameIndex),20);
        //image(musicglowball0,400, getYPos(n.frameIndex));
        //image(img, x, getYPos(n.frameIndex));
        pushMatrix();
        translate(x, getYPos(n.frameIndex));
        //tint(r, g, b);
        //image(img, 0, 0);
        stroke(r, g, b);
        drawArrow(n.type);
        scale(n.effectorScale);
        //tint(r, g, b, n.effectorAlpha);
        //image(img, 0, 0);
        stroke(r, g, b, n.effectorAlpha);
        drawArrow(n.type);
        n.effectorScale += 0.2;
        n.effectorAlpha = max(0, n.effectorAlpha - 20);
        popMatrix();
        noTint();
        strokeWeight(1);
      }
    }
    imageMode(CORNER);
  }
  
  void addScoredNode(ScoredNode n){
    scoredNodeDisplayBuffer.add(n);
  }
  
  void drawArrow(Node dir){
    strokeWeight(8);
    pushMatrix();
    //rotate based on dir
    switch(dir){
      case L:
        rotate(radians(-90));
        break;
      case R:
        rotate(radians(90));
        break;
      case U:
      default:
        break;
    }
    line(0,20,0,-20);
    line(0,-20,-20,0);
    line(0,-20,20,0);
    popMatrix();
    strokeWeight(1);
  }
  
  PGraphics arrow(Node dir){
    PGraphics pg = createGraphics(50, 50);
    pg.beginDraw();
    //pg.shapeMode(CENTER);
    pg.strokeWeight(8);
    pg.pushMatrix();
    pg.translate(pg.width / 2, pg.height / 2);
    //rotate based on dir
    switch(dir){
      case L:
        pg.rotate(-PI / 2);
        break;
      case R:
        pg.rotate(PI / 2);
        break;
      case U:
      default:
        break;
    }
    pg.line(0,20,0,-20);
    pg.line(0,-20,-20,0);
    pg.line(0,-20,20,0);
    pg.popMatrix();
    pg.strokeWeight(1);
    pg.endDraw();
    return pg;
  }
}
