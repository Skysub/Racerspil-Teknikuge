import controlP5.*;
GameLogic gameLogic;
PImage backdrop;

void setup() {
  size(1920, 1080);
  frameRate(144);
  gameLogic = new GameLogic(this);
  smooth();
}

void draw() {
  background(220);
  gameLogic.Update();
}

void keyPressed() {
  gameLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  gameLogic.HandleInput(keyCode, false);
}
