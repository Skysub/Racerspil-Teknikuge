GameLogic gameLogic;

void setup() {
  size(1920, 1080);
  frameRate(144);
  gameLogic = new GameLogic();
}

void draw() {
  gameLogic.Update();
}
