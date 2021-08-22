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
      case "red":
        lastColor = currentColor;
        currentColor = color(255, 0, 0);
        break;
      case "green":
        lastColor = currentColor;
        currentColor = color(0, 255, 0);
        break;
      case "blue":
        lastColor = currentColor;
        currentColor = color(0, 0, 255);
        break;
      case "yellow":
        lastColor = currentColor;
        currentColor = color(255, 255, 0);
        break;
      case "pink":
        lastColor = currentColor;
        currentColor = color(255, 0, 255);
        break;
      case "teal":
        lastColor = currentColor;
        currentColor = color(0, 255, 255);
        break;
      case "orange":
        lastColor = currentColor;
        currentColor = color(200, 100, 0);
        break;
      case "tan":
        lastColor = currentColor;
        currentColor = color(110, 100, 0);
        break;
      case "brown":
        lastColor = currentColor;
        currentColor = color(70, 50, 0);
        break;
      case "purple":
        lastColor = currentColor;
        currentColor = color(80, 0, 155);
        break;
      case "black":
        lastColor = currentColor;
        currentColor = color(0);
        break;
      case "grey":
        lastColor = currentColor;
        currentColor = color(127);
        break;
      case "gray":
        lastColor = currentColor;
        currentColor = color(127);
        break;
      case "white":
        lastColor = currentColor;
        currentColor = color(255);
        break;
      case "mix":
        float div = 1.8;
        float r = constrain((red(lastColor) + red(currentColor)) / div, 0, 255);
        float g = constrain((green(lastColor) + green(currentColor)) / div, 0, 255);
        float b = constrain((blue(lastColor) + blue(currentColor)) / div, 0, 255);
        lastColor = currentColor;
        currentColor = color(r, g, b);
        break;
      case "erase":
        currentColor =  bgColor;
        alphaNum = 255;
        break;
      case "random":
        lastColor = currentColor;
        int val = 63;
        currentColor = color(val + random(val), val + random(val), val + random(val));
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
      case "glitch":
        doOpticalFlow = true;
        break;
      case "unglitch":
        doOpticalFlow = false;
        break;
      case "delete":
        armDelete = true;
        break;
      default:
        currentCol = defaultCol;
        armReset = false;
        break;
    }
    
    if (armReset) lastString = "" + inputString;
  }
  
}
