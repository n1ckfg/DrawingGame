int squareSize = 10;
int squareDelta = 5;
color currentColor = color(255, 0, 0);
color bgColor = color(0);
PGraphics pg;
PVector p1, p2, p3;

void setup() {
  fullScreen(P2D);
  noCursor();
  rectMode(CENTER);

  pg = createGraphics(width, height, P2D);
  pg.beginDraw();
  pg.background(bgColor);
  pg.noStroke();
  pg.rectMode(CENTER);
  pg.fill(currentColor);
  pg.endDraw();
}

void draw() { 
  if (keyPressed) {
    switch(key) {
      case '=':
        squareSize += squareDelta;
        break;
      case '-':
        squareSize -= squareDelta;
        break;
    }
    squareSize = constrain(squareSize, 1, 2000);
  }
  
  background(bgColor);
  
  pg.beginDraw();
  pg.fill(currentColor);
  if (mousePressed) {
    p1 = new PVector(mouseX, mouseY);
    p2 = new PVector(pmouseX, pmouseY);
    float lerpSteps = p1.dist(p2);
    for (int i=0; i<lerpSteps; i++) {
      p3 = p1.lerp(p2, i/lerpSteps);
      pg.rect(p3.x, p3.y, squareSize, squareSize);
    }
  }
  pg.endDraw();
  
  image(pg, 0, 0);
  
  stroke(255);
  fill(currentColor);
  rect(mouseX, mouseY, squareSize, squareSize);
}
