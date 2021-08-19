
void keyPressed() {
  switch (key) {
    case 'u':
      currentColor = color(0, 0, 255);
      break;
    case 'b':
      currentColor = color(85, 65, 40);
      break;
    case 'r':
      currentColor = color(127 + random(127), 127 + random(127), 127 + random(127));
      break;
    case 'm':
      currentColor = color(255, 0, 0);
      break;
    case 'e':
      currentColor =  bgColor;
      break;
    case 's':
      saveFrame();
      break;
  }
}
