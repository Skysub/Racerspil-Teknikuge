class GameLogic { //<>// //<>// //<>//

  Bane bane;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, enter=false; //kun til taster
  boolean ice = false, tileTest = false; //til andre bools
  boolean[] toggleTemp; 

  //ting til bilen
  PVector carPos = new PVector(width/2, height/2), carBoost = new PVector(0, 0);
  float startRotation = 0, maxVel = 3, maxBackVel = 1.5, stopVel = 2, bremseVel = 5, maxThetaVel = 0.03, maxThetaBackVel = 0.02, acceleration = 0.01;
  int carWidth = 60, carHeight = 30;
  Car car;

  GameLogic() {
    car = new Car(carPos, ice, startRotation, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, carWidth, carHeight);
    bane = new Bane();
  }


  void Update() {
    toggleTemp = toggle(t, tF, tileTest);
    tileTest = toggleTemp[0];
    tF = toggleTemp[1];


    bane.Draw(tileTest);
    car.Update(hojre, venstre, op, ned);

    DrawUI();
    if(tileTest) bane.Draw(tileTest);
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
