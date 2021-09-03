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
  GifDictionary gifDictionary;
  
  Typer() {
    gifDictionary = new GifDictionary("dictionary.txt");
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
    input = input.toLowerCase();
    
    switch (input) {
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
      case "square":
        isRect = true;
        break;
      case "circle":
        isRect = false;
        break;
      case "delete":
        armDelete = true;
        break;
      case "bake":
        armBake = true;
        break;
      case "invert":
        armInvert = true;
        break;
      case "blur":
        armBlur = true;
        break;
      case "load":
        armLoad = true;
        break;
      case "undo":
        armUndo = true;
        break;
      // ~ ~ ~ ~ ~ ~   2. COLORS   ~ ~ ~ ~ ~ ~
      // https://www.colorhexa.com/color-names
      case "red":
        setColor(color(#ff0000));
        break;
      case "green":
        setColor(color(#00ff00));
        break;
      case "blue":
        setColor(color(#0000ff));
        break;
      case "yellow":
        setColor(color(#ffff00));
        break;
      case "pink":
        setColor(color(#ffc0cb));
        break;
      case "teal":
        setColor(color(#008080));
        break;
      case "orange":
        setColor(color(#ffa500));
        break;
      case "tan":
        setColor(color(#d2b48c));
        break;
      case "brown":
        setColor(color(#654321));
        break;
      case "purple":
        setColor(color(#800080));
        break;
      case "black":
        setColor(color(#000000));
        break;
      case "grey":
        setColor(color(#808080));
        break;
      case "gray":
        setColor(color(#808080));
        break;
      case "white":
        setColor(color(#ffffff));
        break;
      case "chartreuse":
        setColor(color(#7fff00));
        break;
      case "magenta":
        setColor(color(#ff00ff));
        break;
      case "cyan":
        setColor(color(#00ffff));
        break;
      case "turquoise":
        setColor(color(#30d5c8));
        break;
      case "vermilion":
        setColor(color(#e34234));
        break;
      case "vermillion":
        setColor(color(#e34234));
        break;
      case "viridian":
        setColor(color(#40826d));
        break;
      case "gold":
        setColor(#ffd700);
        break;
      case "silver":
        setColor(#c0c0c0);
        break;
      case "bronze":
        setColor(#cd7f32);
        break;
      case "peach":
        setColor(#ffe5b4);
        break;
      case "jade":
        setColor(#00a86b);
        break;
      case "coffee":
        setColor(#6f4e37);
        break;
      case "indigo":
        setColor(#4b0082);
        break;
      case "violet":
        setColor(#ee82ee);
        break;
      // ~ ~ ~ ~ ~ ~   3. SPECIAL EFFECTS   ~ ~ ~ ~ ~ ~
      case "glitch":
        doOpticalFlow = true;
        break;
      case "clean":
        doOpticalFlow = false;
        break;
      // ~ ~ ~ ~ ~ ~   4. GIFS   ~ ~ ~ ~ ~ ~
      default:
        if (gifDictionary.doSearch(input)) {
          armGif(input);
        } else {
          currentCol = defaultCol;
          armReset = false;
        }
        break;
    }
    
    if (armReset) lastString = "" + inputString;
  }
  
  void setColor(color c) {
    lastColor = currentColor;
    currentColor = c;
  }
  
}
