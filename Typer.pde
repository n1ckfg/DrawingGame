class Typer {
 
  color defaultCol = color(255);
  color goodCol = color(0,255,0);
  color badCol = color(255,0,0);
  color currentCol = defaultCol;
  color outlineCol = color(0);
  int outlineSize = 3;
  
  String inputString = "";
  String lastString = "";
  int markTime = 0;
  int timeout = 1500;
  boolean armReset = false;
  
  Typer() {
    //
  }
  
  void lastTime() {
    markTime = millis();
  }
  
  void update() {
    int m = millis();
    if (!armReset && m > markTime + timeout / 2 && m < markTime + timeout) {
      currentCol = badCol; 
      armReset = true;
    } else if (m > markTime + timeout) {
      currentCol = defaultCol;
      armReset = false;
      inputString = "";    
    }
  }
  
  void draw() {
    fill(typer.outlineCol);
    text(typer.inputString, width/2 + 2, height/2);
    text(typer.inputString, width/2 - 2, height/2);
    text(typer.inputString, width/2, height/2 + 2);
    text(typer.inputString, width/2, height/2 - 2);
  
    fill(typer.currentCol);
    text(typer.inputString, width/2, height/2);
  }
  
  void run() {
    update();
    draw();
  }
  
  void addChar(char c) {
    if (armReset) {
      inputString = "";
      armReset = false;
    }
    inputString += c;
    parseCmd(inputString);
    lastTime();
  }
  
  void removeChar() {
    if (inputString.length() > 0) {
      inputString = inputString.substring(0, inputString.length()-1); 
    }
  }
  
  void repeatCmd() {
    inputString = "" + lastString;
    parseCmd(inputString);
  }
  
  void parseCmd() {
    parseCmd(inputString);
  }
  
  void parseCmd(String input) {    
    currentCol = goodCol;
    armReset = true;
    
    switch (input.toLowerCase()) {
      // ~ ~ ~ ~ ~ ~   1. FUNCTIONS   ~ ~ ~ ~ ~ ~
      case "mix":
        float div = 1.8;
        float r = constrain((red(lastColor) + red(currentColor)) / div, 0, 255);
        float g = constrain((green(lastColor) + green(currentColor)) / div, 0, 255);
        float b = constrain((blue(lastColor) + blue(currentColor)) / div, 0, 255);
        setColor(color(r, g, b));
        break;
      case "erase":
        resetBrush();
        currentColor =  bgColor;
        alphaNum = 255;
        break;
      case "random":
        int val = 63;
        setColor(color(val + random(val), val + random(val), val + random(val)));
        break;
      case "save":
        tex.save("output_" + millis() + "." + saveFormat);
        pg.save("data/working.png");
        break;
      case "undo":
        armUndo = true;
        break;
      case "square":
        isRect = true;
        break;
      case "circle":
        isRect = false;
        break;
      case "delete":
        armDelete = true;
        break;
      // ~ ~ ~ ~ ~ ~   2. BASIC COLORS   ~ ~ ~ ~ ~ ~
      case "red":
        setColor(color(255, 0, 0));
        break;
      case "green":
        setColor(color(0, 255, 0));
        break;
      case "blue":
        setColor(color(0, 0, 255));
        break;
      case "yellow":
        setColor(color(255, 255, 0));
        break;
      case "pink":
        setColor(color(255, 0, 255));
        break;
      case "teal":
        setColor(color(0, 255, 255));
        break;
      case "orange":
        setColor(color(200, 100, 0));
        break;
      case "tan":
        setColor(color(110, 100, 0));
        break;
      case "brown":
        setColor(color(70, 50, 0));
        break;
      case "purple":
        setColor(color(80, 0, 155));
        break;
      case "black":
        setColor(color(0));
        break;
      case "grey":
        setColor(color(127));
        break;
      case "gray":
        setColor(color(127));
        break;
      case "white":
        setColor(color(255));
        break;
      // ~ ~ ~ ~ ~ ~   3. EXPANDED COLORS   ~ ~ ~ ~ ~ ~
      // https://www.colorhexa.com/color-names
      case "chartreuse":
        setColor(color(#B9FA26));
        break;
      case "magenta":
        setColor(color(#C1199D));
        break;
      case "turquoise":
        setColor(color(#0BD2E3));
        break;
      case "vermillion":
        setColor(color(#FC5112));
        break;
      case "viridian":
        setColor(color(#40826d));
        break;
      // ~ ~ ~ ~ ~ ~   4. SPECIAL EFFECTS   ~ ~ ~ ~ ~ ~
      case "glitch":
        doOpticalFlow = true;
        break;
      case "clean":
        doOpticalFlow = false;
        break;
      // ~ ~ ~ ~ ~ ~   5. GIFS   ~ ~ ~ ~ ~ ~
      case "bat":
        armGif("bat");
        break;
      case "cat":
        armGif("cat");
        break;     
      case "fish":
        armGif("fish");
        break;    
      case "mario":
        armGif("mario");
        break;
      case "zelda":
        armGif("zelda");
        break;
      case "treasure":
        armGif("treasure");
        break;
      // ~ ~ ~ ~ ~ ~   6. NO RESULT   ~ ~ ~ ~ ~ ~
      default:
        currentCol = defaultCol;
        armReset = false;
        break;
    }
    
    if (armReset) lastString = "" + inputString;
  }
  
  void setColor(color c) {
    lastColor = currentColor;
    currentColor = c;
  }
  
}
