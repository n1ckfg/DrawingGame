int brushSize = 10;
int brushDelta = 4;
int brushSizeScaled = brushSize;
int minBrushResetSize = 50;
color currentColor = color(127);
color lastColor = currentColor;
color bgColor = color(0);
PGraphics pg, pgBackup;
PVector p1, p2, p3;
int alphaNum = 255;
int alphaDelta = 6;
String saveFormat = "jpg";
boolean armUndo = false;
boolean armDelete = false;
boolean armBake = false;
boolean armInvert = false;
boolean armBlur = false;
boolean armLoad = false;
boolean isRect = true;
boolean firstRun = true;
boolean doOpticalFlow = false;
PFont font;
int fontSize = 48;
  
int globalScale = 3;
int mouseXscaled, mouseYscaled, pmouseXscaled, pmouseYscaled;
int sW, sH;
Typer typer;

void setup() {
  fullScreen(P2D);
  sW = displayWidth / globalScale;
  sH = displayHeight / globalScale;
  
  noCursor();
  noSmooth();
  pixelDensity(1);
  rectMode(CENTER);
  ellipseMode(CENTER);
  
  typer = new Typer();
  font = createFont("Arial", fontSize*2);
  textFont(font, fontSize);
  textAlign(CENTER);
  
  pg = createGraphics(sW, sH, P2D);
  pgBackup = createGraphics(sW, sH, P2D);
  bloomSetup();
  opticalFlowSetup();

  pg.beginDraw();
  pg.background(bgColor);
  pg.noStroke();
  pg.noSmooth();
  pg.rectMode(CENTER);
  pg.ellipseMode(CENTER);
  pg.imageMode(CENTER);
  pg.fill(currentColor);
  pg.endDraw();
  
  pgBackup.noSmooth();
}

void draw() {  
  mouseXscaled = mouseX / globalScale;
  mouseYscaled = mouseY / globalScale;
  pmouseXscaled = pmouseX / globalScale;
  pmouseYscaled = pmouseY / globalScale;
  brushSizeScaled = brushSize / globalScale;
  
  if (keyPressed) {
    typer.lastTime();
  
    switch(key) {
      case ']':
        brushSize += brushDelta;
        break;
      case '[':
        brushSize -= brushDelta;
        break;
      case '=':
        alphaNum += alphaDelta;
        break;
      case '-':
        alphaNum -= alphaDelta;
        break;
    }
    brushSize = constrain(brushSize, 2, 2000);
    alphaNum = constrain(alphaNum, 2, 255);
  }
  
  background(bgColor);
  
  if (armUndo) {
    pg.beginDraw();
    pg.background(bgColor);
    pg.image(pgBackup, pg.width/2, pg.height/2);
    pg.endDraw();
    armUndo = false;
  }
  
  if (armDelete) {
    pg.beginDraw();
    pg.background(bgColor);
    pg.endDraw();
    armDelete = false;    
  }
  
  pg.beginDraw();
  if (firstRun || armLoad) {
    loadWorkingImage();
    firstRun = false;
    armLoad = false;
  }
  pg.fill(currentColor, alphaNum);
  if (mousePressed) {
    p1 = new PVector(mouseXscaled, mouseYscaled);
    p2 = new PVector(pmouseXscaled, pmouseYscaled);

    drawBrush(p1.x, p1.y, false);
    
    float lerpSteps = p1.dist(p2);
    for (int i=0; i<lerpSteps; i++) {
      p3 = p1.lerp(p2, i/lerpSteps);
      drawBrush(p3.x, p3.y, false);
    }
  }
  
  if (armCreateGif && millis() > gifMarkTime + gifTimeInterval) {
    createGif();
    resetBrush();
    armCreateGif = false;
  }
  if (gifMode) {
    pg.pushMatrix();
    pg.tint(255, alphaNum);
    pg.translate(mouseXscaled, mouseYscaled);
    float sx, sy;
    if (gif.width > gif.height) {
      sx = brushSizeScaled;
      sy = brushSizeScaled * ((float) gif.height / (float) gif.width);      
    } else if (gif.width < gif.height) {
      sx = brushSizeScaled * ((float) gif.width / (float) gif.height); 
      sy = brushSizeScaled;    
    } else {
      sx = brushSizeScaled;
      sy = brushSizeScaled;
    }
    pg.scale(sx / gif.width, sy / gif.height);
    pg.image(gif, 0, 0);
    pg.popMatrix();
  }
  pg.endDraw();
  
  tex.beginDraw();
  tex.background(bgColor);
  tex.image(pg, 0, 0);
  tex.endDraw();
  if (doOpticalFlow) opticalFlowDraw();
  bloomDraw();
  
  if (armBake) {
    pg.beginDraw();
    pg.image(get(), 0, 0, pg.width, pg.height);
    pg.endDraw();
    armBake = false;
  }

  if (armInvert) {
    pg.beginDraw();
    pg.filter(INVERT);
    pg.endDraw();
    armInvert = false;
  }
  
  if (armBlur) {
    pg.beginDraw();
    pg.filter(BLUR);
    pg.endDraw();
    armBlur = false;
  }
  
  stroke(255);

  if (mousePressed) {
    strokeWeight(4);
  } else {
    strokeWeight(2);
  }
  fill(currentColor, alphaNum);
  drawBrush(mouseX, mouseY, true);

  typer.run();
}

void drawBrush(float x, float y, boolean ui) {
  if (!ui && !gifMode) {
    if (isRect) {
      pg.rect(x, y, brushSizeScaled, brushSizeScaled);
    } else {
      pg.circle(x, y, brushSizeScaled);
    }
  } else if (ui && !gifMode) {
    if (isRect) {
      rect(x, y, brushSize, brushSize);
    } else {
      circle(x, y, brushSize);
    }
  }
}

void resetBrush() {
  if (brushSize < minBrushResetSize) brushSize = minBrushResetSize;
}

void loadWorkingImage() {
    try {
      PImage workingImg = loadImage("data/working.png");
      pg.image(workingImg, pg.width/2, pg.height/2, pg.width, pg.height);
    } catch (Exception e) { }
}
