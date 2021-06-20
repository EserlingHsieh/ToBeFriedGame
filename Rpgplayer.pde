class Rpgplayer {

  float x, y;
  float col,row;
  int moveDirection = 0;
  boolean upState = false;
  boolean leftState = false;
  boolean rightState = false;
  boolean downState = false;
  boolean rightChange = false;
  boolean leftChange = false;
  boolean upChange = false;
  boolean downChange = false;
  int steps=0;
  PImage tmp=rpgFront;

  Rpgplayer(){
    col=3;
    row=6;
  }

void update(){
  steps+=1;
  
  //direction
    if(leftState){
      if(leftChange){
      tmp=rpgLeftFront;}
      else{tmp=rpgLeftBack;}}
    if(rightState){
      if(rightChange){
      tmp=rpgRightFront;}
      else{tmp=rpgRightBack;}}
    if(upState){
      if(upChange){
      tmp=rpgBackRight;}
      else{tmp=rpgBackLeft;}}
    if(downState){
      if(downChange){
      tmp=rpgFrontRight;}
      else{tmp=rpgFrontLeft;}}
  
  
  
  //moving
    float newCol=col, newRow=row;
    if(upState){
       newCol=col-1;
     }
    if(downState){
       newCol=col+1;
     }
    if(leftState){
       newRow=row-1;
     }
    if(rightState){
       newRow=row+1;
     }
    if(newCol < rpgMapL.length && newCol >= 0
      && newRow < rpgMapL[0].length && newRow >= 0){
      if(rpgBgX==0){
        if(rpgMapL[floor(newCol)][floor(newRow)]== 0){
           col=newCol;
           row=newRow;
         }
      }
      if(rpgBgX==-1280){
        if(rpgMapR[floor(newCol)][floor(newRow)]== 0){
           col=newCol;
           row=newRow;
         }
      }
    }  
  
    if(steps>=-1){
      if(tmp==rpgRightFront||tmp==rpgRightBack){
      tmp=rpgRightIdle;
      }else if(tmp==rpgLeftFront||tmp==rpgLeftBack){
      tmp=rpgLeftIdle;
      }else if(tmp==rpgBackRight||tmp==rpgBackLeft){
      tmp=rpgBack;
      }else if(tmp==rpgFrontRight||tmp==rpgFrontLeft){
      tmp=rpgFront;
}}

 


   //edge decect
   if(!rpgOil || !rpgEgg || !rpgFlour){
     if(row>12+rpgRightEdge){
       row=12+rpgRightEdge;
     }
   }else{
     if(row>12){
       row=12;
     }
   }  
   if(row<0+rpgLeftEdge){
     row=0+rpgLeftEdge;}
   if(col<0){
     col=0;}
   if(col>6){
     col=6;}
     
   //walk to win
    if(rpgOil && rpgEgg && rpgFlour ){
      if(col==3 && row==12 && rpgSpaceClick){
        gameState=GAME_WIN;
      }
    }
    
   //change stage 
  if(rpgChangeStage){
    if(rpgToRight){
      tmp=rpgRightIdle;
    row-=12.0/159.0;
      if(rpgBgX==-1272){
      row=0;}
    }
    else if(rpgToLeft){
      tmp=rpgLeftIdle;
    row+=12.0/159.0;
      if(rpgBgX==8){
      row=12;}
    }
  }
    
  x=RPG_EDGE_X+row*RPG_UNIT;
  y=RPG_EDGE_Y+col*RPG_UNIT;

  
   image(tmp,x,y);
   //println(frontMe(col,row));
   
   upState = false;
   leftState = false;
   rightState = false;
   downState = false;
 }
 
 //front of me=0,1,2...
  int frontMe(float col, float row){
    return frontMe(floor(col), floor(row));
  }
  
  int frontMe(int col, int row){
    int k =0;
    if(tmp==rpgLeftFront||tmp==rpgLeftBack||tmp==rpgLeftIdle){
      if(row!=0){
        if(rpgBgX==0){
           k =  rpgMapL[col][row-1];}
        else if(rpgBgX==-1280){
           k =  rpgMapR[col][row-1];}
      }
    }  
    else if(tmp==rpgRightFront||tmp==rpgLeftFront||tmp==rpgRightIdle){
      if(row!=12){
       if(rpgBgX==0){
           k =  rpgMapL[col][row+1];}
        else if(rpgBgX==-1280){
           k =  rpgMapR[col][row+1];}
        }
    }  
    else if(tmp==rpgFrontRight||tmp==rpgFrontLeft||tmp==rpgFront){
      if(col!=6){
       if(rpgBgX==0){
           k =  rpgMapL[col+1][row];}
        else if(rpgBgX==-1280){
           k =  rpgMapR[col+1][row];}
      }
    }  
    else if(tmp==rpgBackRight||tmp==rpgBackLeft||tmp==rpgBack){
      if(col!=0){
        if(rpgBgX==0){
           k =  rpgMapL[col-1][row];}
        else if(rpgBgX==-1280){
           k =  rpgMapR[col-1][row];}
      }
    }  
    return k;
  }  
  
  void keyInput(int k){
    switch (k){
      case LEFT:
      walking.trigger();
      leftState=true;
      steps=-25;
      leftChange=!leftChange;
      break;
      
      case RIGHT:
      walking.trigger();
      rightState=true;
      steps=-25;
      rightChange=!rightChange;
      break;
      
      case UP:
      walking.trigger();
      upState=true;
      steps=-25;
      upChange=!upChange;
      break;
      
      case DOWN:
      walking.trigger();
      downState=true;
      steps=-25;
      downChange=!downChange;
      break;
    }
  }
  

}
