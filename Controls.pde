void keyPressed() {
  if (keyCode == BACKSPACE || keyCode == DELETE) {
    typer.removeChar();
  } else if (keyCode == ENTER || keyCode == RETURN || key == '[' || key == ']' || key == '-' || key == '=') {
    //
  } else if (keyCode == UP) {
    typer.repeatCmd();
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

void mouseReleased() {
  gifMode = false;
  noTint();
  gif = null;
}
