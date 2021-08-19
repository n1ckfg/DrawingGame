int squareSize = 10;
int squareDelta = 5;
color currentColor = color(255, 0, 0);
color bgColor = color(0);
PGraphics pg;

void setup() {
  fullScreen(P2D);
  noCursor();
  rectMode(CENTER);

  pg = createGraphics(width, height, P2D);
  pg.beginDraw();
  pg.background(bgColor);
  pg.noStroke();
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
    pg.rectMode(CENTER);
    pg.rect(mouseX, mouseY, squareSize, squareSize);
  }
  pg.endDraw();
  
  image(pg, 0, 0);
  
  stroke(255);
  fill(currentColor);
  rect(mouseX, mouseY, squareSize, squareSize);
}
