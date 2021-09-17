import controlP5.*;
GameLogic gameLogic;
PImage backdrop;

void setup() {
  size(1920, 1080);
  frameRate(144);
  gameLogic = new GameLogic(this);
  backdrop = loadImage("Dirt.png");
  smooth();
}

void draw() {
  background(220);
  imageMode(CORNER);
  image(backdrop,0,120);
  gameLogic.Update();
}

void keyPressed() {
  gameLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  gameLogic.HandleInput(keyCode, false);
}
