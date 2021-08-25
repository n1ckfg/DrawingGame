int brushSize = 10;
int brushDelta = 5;
color currentColor = color(127);
color lastColor = currentColor;
color bgColor = color(0);
PGraphics pg, pgBackup;
PVector p1, p2, p3;
int alphaNum = 255;
int alphaDelta = 5;
String saveFormat = "jpg";
boolean armUndo = false;
boolean armDelete = false;
boolean isRect = true;
boolean firstRun = true;
boolean doOpticalFlow = false;
PFont font;
int fontSize = 48;
  
int globalScale = 2;
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
  
  if (keyPressed) {
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
    pg.image(pgBackup, 0, 0);
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
  if (firstRun) {
    try {
      PImage workingImg = loadImage("data/working.png");
      pg.image(workingImg, 0, 0, pg.width, pg.height);
    } catch (Exception e) { }
    firstRun = false;
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
    armCreateGif = false;
  }
  if (gifMode) {
    pg.pushMatrix();
    pg.tint(255, alphaNum);
    pg.translate(mouseXscaled, mouseYscaled);
    pg.scale(((float) gif.width / 10000.0) * brushSize, ((float) gif.height / 10000.0) * brushSize);
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
  int brushSizeScaled = brushSize / globalScale;
  if (!ui) {
    if (isRect) {
      pg.rect(x, y, brushSizeScaled, brushSizeScaled);
    } else {
      pg.circle(x, y, brushSizeScaled);
    }
  } else {
    if (isRect) {
      rect(x, y, brushSize, brushSize);
    } else {
      circle(x, y, brushSize);
    }
  }
}
