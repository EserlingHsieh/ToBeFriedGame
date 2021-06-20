





class Console
{
    float x;
    float y;
    String chars;
    float rotation;
    boolean active;
    int numChars;
    int font;
    
    Console(float x, float y, int font, float rotation)
    {
        this.x = x;
        this.y = y;
        this.font = font;
        this.rotation = radians(rotation);
        active = false;
        chars = "";
        numChars = 0;
    }
    
    void display()
    {
        pushMatrix();
        rotate(rotation);
        //line(x,y,x,y+font);
        textSize(font);
        text(chars,x,y);
        popMatrix();
    }
    
    void addChar(char c){
      if(numChars<20){
        chars += c;
        numChars++;
      }
    }
    
    String readString()
    {
        return chars;
    }
    
    boolean isActive()
    {
        return active;
    }
    
    void activate()
    {
        active = true;
    }
    
    void deactivate()
    {
        active = false;
    }
    
    void reset()
    {
        chars = "";
    }
    
    void deleteChar()
    {
            if (numChars > 0)
            {        
                  chars = chars.substring(0,chars.length()-1);
                  numChars -= 1;
            }
    }
  
  void keyPressed(){
     if (keyAnalyzer(key).compareTo("LETTER") == 0 ){
       addChar(key);
      }
      if (keyCode == BACKSPACE)
      {
        deleteChar();
      }
  }
}
