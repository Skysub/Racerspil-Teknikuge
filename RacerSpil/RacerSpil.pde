GameLogic gameLogic;

void setup() {
  size(1920, 1080);
  frameRate(144);
  gameLogic = new GameLogic();
  background(220);
}

void draw() {
  gameLogic.Update();
}

void keyPressed() {
  gameLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  gameLogic.HandleInput(keyCode, false);
}
