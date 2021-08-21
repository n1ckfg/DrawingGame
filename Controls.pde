void keyPressed() {
  switch (key) {
    case '1':
      lastColor = currentColor;
      currentColor = color(255, 0, 0);
      break;
    case '2':
      lastColor = currentColor;
      currentColor = color(0, 255, 0);
      break;
    case '3':
      lastColor = currentColor;
      currentColor = color(0, 0, 255);
      break;
    case '4':
      lastColor = currentColor;
      currentColor = color(255, 255, 0);
      break;
    case '5':
      lastColor = currentColor;
      currentColor = color(255, 0, 255);
      break;
    case '6':
      lastColor = currentColor;
      currentColor = color(0, 255, 255);
      break;
    case '7':
      lastColor = currentColor;
      currentColor = color(0);
      break;
    case '8':
      lastColor = currentColor;
      currentColor = color(127);
      break;
    case '9':
      lastColor = currentColor;
      currentColor = color(255);
      break;
    case '0':
      float div = 1.8;
      float r = constrain((red(lastColor) + red(currentColor)) / div, 0, 255);
      float g = constrain((green(lastColor) + green(currentColor)) / div, 0, 255);
      float b = constrain((blue(lastColor) + blue(currentColor)) / div, 0, 255);
      lastColor = currentColor;
      currentColor = color(r, g, b);
      break;
    case 'e':
      currentColor =  bgColor;
      alphaNum = 255;
      break;
    case 'r':
      lastColor = currentColor;
      int val = 63;
      currentColor = color(val + random(val), val + random(val), val + random(val));
      break;
    case 's':
      tex.save("output_" + millis() + "." + saveFormat);
      pg.save("data/working.png");
      break;
    case 'z':
      armUndo = true;
      break;
    case 'b':
      isRect = !isRect;
      break;
  }
}

void mousePressed() {
  pgBackup.beginDraw();
  pgBackup.background(bgColor);
  pgBackup.image(pg, 0, 0);
  pgBackup.endDraw();
}
