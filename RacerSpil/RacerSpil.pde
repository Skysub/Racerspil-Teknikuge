GameLogic gameLogic;

void setup() {
  size(1280, 720);
  frameRate(144);
  gameLogic = new GameLogic();
}

void draw() {
  gameLogic.Update();
}
