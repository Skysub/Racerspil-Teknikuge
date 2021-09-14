class GameLogic { //<>// //<>//

  Bane bane;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, enter=false; //kun til taster
  boolean ice = false, tileTest = false; //til andre bools
  boolean[] toggleTemp; 

  //ting til bilen
  PVector carPos = new PVector(width/2, height/2), carVel = new PVector(0, 0), carAcc = new PVector(0, 0), carBoost = new PVector(0, 0);
  float theta = 0;
  Car car;

  GameLogic() {
    car = new Car(carPos, carVel, carAcc, ice, carBoost, theta);
    bane = new Bane();
  }


  void Update() {
    toggleTemp = toggle(t, tF, tileTest);
    tileTest = toggleTemp[0];
    tF = toggleTemp[1];


    bane.Draw(tileTest);
    car.Update(hojre, venstre, op, ned);

    DrawUI();
  }

  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
  }

  //sørger for at controls virker
  void HandleInput(int k, boolean b) {

    if (k == 39) hojre = b;
    if (k == 37) venstre = b;
    if (k == 38) op = b;
    if (k == 40) ned = b;
    if (k == 82) r = b;
    if (k == 84) t = b;
    if (k == 32) space = b;
    if (k == 9) tab = b;
    if (k == 10) enter = b;
  }


  //En metode der hjælper med at toggle visse booleans.
  //x er tastens aktuelle værdi, xF er tastens tidligere værdi, og v er den variabel man øsnker skal være togglable via tasten x
  boolean[] toggle(boolean x, boolean xF, boolean v) {

    if (x && !xF) {
      xF = x;
      v = !v;
    }
    if (xF && !x) xF = x;
    boolean[] a = {v, xF};
    return a;
  }
}
