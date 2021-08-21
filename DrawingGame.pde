int brushSize = 10;
int brushDelta = 5;
color currentColor = color(127);
color lastColor = currentColor;
color bgColor = color(0);
PGraphics pg, pgBackup;
PVector p1, p2, p3;
int alphaNum = 127;
int alphaDelta = 5;
String saveFormat = "jpg";
boolean armUndo = false;
boolean isRect = true;
boolean firstRun = true;

void setup() {
  fullScreen(P2D);
  noCursor();
  smooth();
  pixelDensity(1);
  rectMode(CENTER);
  ellipseMode(CENTER);

  pg = createGraphics(width, height, P2D);
  pgBackup = createGraphics(width, height, P2D);
  bloomSetup();
  
  pg.beginDraw();
  pg.background(bgColor);
  pg.noStroke();
  pg.smooth();
  pg.rectMode(CENTER);
  pg.ellipseMode(CENTER);
  pg.fill(currentColor);
  pg.endDraw();
}

void draw() { 
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
    p1 = new PVector(mouseX, mouseY);
    p2 = new PVector(pmouseX, pmouseY);

    drawBrush(p1.x, p1.y, false);
    
    float lerpSteps = p1.dist(p2);
    for (int i=0; i<lerpSteps; i++) {
      p3 = p1.lerp(p2, i/lerpSteps);
      drawBrush(p3.x, p3.y, false);
    }
  }
  pg.endDraw();
  
  tex.beginDraw();
  tex.background(0);
  tex.image(pg, 0, 0);
  tex.endDraw();
  bloomDraw();
  
  stroke(255);

  if (mousePressed) {
    strokeWeight(4);
  } else {
    strokeWeight(2);
  }
  fill(currentColor, alphaNum);
  drawBrush(mouseX, mouseY, true);
}

void drawBrush(float x, float y, boolean ui) {
  if (!ui) {
    if (isRect) {
      pg.rect(x, y, brushSize, brushSize);
    } else {
      pg.circle(x, y, brushSize);
    }
  } else {
    if (isRect) {
      rect(x, y, brushSize, brushSize);
    } else {
      circle(x, y, brushSize);
    }
  }
}
