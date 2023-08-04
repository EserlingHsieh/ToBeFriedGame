class Rpgtalk {

  String[] talk0;
  Npc[] npcArray;
  int countWord=0;
  int countCountWord=3;//speaking speed
  boolean rpgTalkMode=false;
  int whoTalk;
  int whatWord;
  int whichOne;
  int [] whoGameNpc = new int[3];
  String[] searchName;

  void update(){
    if(rpgStartTalk){
      rpgTalkMode=true;
      textFont(myFont);
      countWord=0;
      whoTalk=rpgplayer.frontMe(rpgplayer.col,rpgplayer.row)-2;
      whatWord=0;
      println(whoTalk);
    }
    else{
      if(rpgSpaceClick==true){
        if(countWord<npcArray[whoTalk].speech[whatWord].text.length()){
          countWord=npcArray[whoTalk].speech[whatWord].text.length();
        }else{
          whatWord+=1;
          countWord=0;
          if(whatWord>=npcArray[whoTalk].speech.length){
            if(whoTalk==11){
            //readyToWin
            rpgMapR[3][10]=0;
            rpgMapR[3][11]=0;
            rpgMapR[3][12]=0;
            }
            if(whoTalk==whoGameNpc[0]){
            gameState=GAME_MUSIC;
            rpgSongIsPlaying=false;
            rpgSong.pause();}
            if(whoTalk==whoGameNpc[1]){
              //currently no game
              rpgEgg=true;
            }
            if(whoTalk==whoGameNpc[2]){
              //currently no game
              rpgOil=true;
            }
           rpgTalkMode=false; 
          }
        }
      }
    }
    if(rpgTalkMode){
      noStroke();
      fill(0,0,0,150);
      rect(0,600,1280,800);
      //println(npcArray[whoTalk].speech[whatWord].talker);
      image(rpgPhoto[npcArray[whoTalk].speech[whatWord].talker],50,610);
      textSize(45);
      fill(255, 255, 255);
      String now=npcArray[whoTalk].speech[whatWord].text;
      countCountWord-=1;
      if(countCountWord==0){
        countWord+=1;
        countCountWord=4;
      }        
      countWord=min(npcArray[whoTalk].speech[whatWord].text.length(),countWord);
      text(now.substring(0, countWord), 270, 700);
      text(searchName[npcArray[whoTalk].speech[whatWord].talker],270,650);
    }
}
  int[] gameNpc(int total, int choose){
    IntList chooseNpc;
    chooseNpc= new IntList();
    for(int i=0; i < total; i++){
      chooseNpc.append(i);
    }
    chooseNpc.shuffle();
    int[] finalChoose; 
    finalChoose = new int[choose];
    for(int i=0;i<choose;i++){
      finalChoose[i]=chooseNpc.get(i);}
    return finalChoose;
  }
  
  void assignPlayerName(){
    searchName[talk0.length/2]=playerName;
  }
  
  Rpgtalk(){
    talk0 = loadStrings("talking0.txt");
    searchName= new String[talk0.length/2+1];
    
    //choose game Npc
    int[] g = gameNpc(10,3);
    for (int i=0;i<3;i++){
      whoGameNpc[i]=g[i];}
      
    npcArray = new Npc[talk0.length];
    for (int i = 0; i < talk0.length; i+=2) {
      //if this Npc have game
      //println(whoGameNpc[0]+","+whoGameNpc[1]+","+whoGameNpc[2]);
      if(int(split(talk0[i], ";")[0])==whoGameNpc[0] ||
        int(split(talk0[i], ";")[0])==whoGameNpc[1] ||
        int(split(talk0[i], ";")[0])==whoGameNpc[2] ){
        whichOne=1;
      }else{
        whichOne=0;
      }  
      String[] items = split(talk0[i+whichOne], ";");
      int index = int(items[0]);
      String name = items[1];
      searchName[index]=name;
      //println(searchName[index]);
        //int[] talker = new int[items.length - 2];
        //String[] speech = new String[items.length - 2];
        Line[] speech = new Line[items.length - 2];
        for(int j = 0; j < speech.length; j++){
          String[] speechItem = split(items[j+2], ":");
          //talker[j] = int(speechItem[0]);
          //speech[j] = speechItem[1];
          speech[j] = new Line(int(speechItem[0]), speechItem[1]);
        }
      Npc n = new Npc(index, name, speech);
      npcArray[i/2] = n;
    }
  }
}

class Npc{
  int index;
  String name;
  Line[] speech;
  
  Npc(int index, String name,  Line[] speech){
    this.index = index;
    this.name = name;
    this.speech = speech;
  }
}

class Line{
  int talker;
  String text;
  
  Line(int talker, String text){
    this.talker = talker;
    this.text = text;
  }
  
  /*Line(String talkerIndexString, String text){
    this.talker = int(talkerIndexString);
    this.text= text;
  }*/
}
