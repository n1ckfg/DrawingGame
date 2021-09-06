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
  ColorPicker colorPicker;
  
  Typer() {
    gifDictionary = new GifDictionary("dictionary.txt");
    colorPicker = new ColorPicker("palette.txt");
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
      case "sharpen":
        armSharpen = true;
        break;
      case "load":
        armLoad = true;
        break;
      case "undo":
        armUndo = true;
        break;
      // ~ ~ ~ ~ ~ ~   2. SPECIAL EFFECTS   ~ ~ ~ ~ ~ ~
      case "glitch":
        doOpticalFlow = true;
        break;
      case "clean":
        doOpticalFlow = false;
        break;
      // ~ ~ ~ ~ ~ ~   3. COLORS AND GIFS   ~ ~ ~ ~ ~ ~
      // https://www.colorhexa.com/color-names
      default:
        if (colorPicker.doSearch(input)) {
          setColor(colorPicker.nextColor);
        } else if (gifSearchEnabled && gifDictionary.doSearch(input)) {
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

class ColorPicker {
  
  String[] words;
  color nextColor;
  
  ColorPicker(String url) {
    words = loadStrings(url);
  }
  
  boolean doSearch(String input) {
    input = input.toLowerCase();
    for (String word : words) {
      String[] wordArray = word.split(" ");
      if (input.equals(wordArray[0].toLowerCase())) {
        nextColor = unhex("ff" + wordArray[1]); // argb
        return true; 
      }
    }
    return false;
  }
  
}
