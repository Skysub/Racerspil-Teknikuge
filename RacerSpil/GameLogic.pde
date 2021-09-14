class GameLogic {

  Bane bane;

  boolean hojre = false, venstre = false, op = false, ned = false, ice = false;
  PVector carPos = new PVector(width/2, height/2), carVel = new PVector(0, 0), carAcc = new PVector(0, 0), carBoost = new PVector(0, 0);
  float theta = 0;
  int cDrej = 0, accelerate = 0;
  Car car;

  GameLogic() {
    car = new Car(carPos, carVel, carAcc, ice, carBoost, theta);
    bane = new Bane();
  }







  void Update() {
    bane.Draw();


    if ((hojre && venstre)||(!hojre && !venstre)) {
      cDrej = 0;
    } else if (hojre) {
      cDrej = 2;
    } else {
      cDrej = 1;
    }

    if (op) {
      accelerate = 1;
    } else if (ned) {
      accelerate = 2;
    } else if (!op) {
      accelerate = 0;
    } 

    car.Update(cDrej, accelerate);

    DrawUI();
  }

  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
  }

  //sørger for at controls virker
  void HandleInput(int k, boolean b) {

    if (k == 39)hojre = b;
    if (k == 37)venstre = b;
    if (k == 38)op = b;
    if (k == 40) ned = b;
  }
}
