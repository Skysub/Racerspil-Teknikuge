class GameLogic {

  Bane bane;

  GameLogic() {
    bane = new Bane();
  }

  void Update() {
    bane.Draw();
    DrawUI();
  }


  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
  }
}
