void keyPressed() {
  typer.lastTime();
  
  if (keyCode == BACKSPACE || keyCode == DELETE) {
    typer.removeChar();
  } else if (keyCode == ENTER || keyCode == RETURN) {
    //
  } else if (key == '[' || key == ']' || key == '-' || key == '+') {
    //
  } else {
    typer.addChar(key);
  }  
}

void mousePressed() {
  pgBackup.beginDraw();
  pgBackup.background(bgColor);
  pgBackup.image(pg, 0, 0);
  pgBackup.endDraw();
}
