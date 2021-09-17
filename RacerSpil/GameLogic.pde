class GameLogic { //<>// //<>// //<>// //<>//

  Bane bane;
  int mSec;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, tabF=false, enter=false, h = false, hF = false; //kun til taster
  boolean ice = false, givBoost = false, tileTest = false, menu = false, hitboxDebug = false; //til andre bools

  boolean[] toggleTemp; 

  //Til runde counter
  int CurrentRound = 1, TotalRounds = 3;

  //Til time counter
  int Record, RaceTime = 60000, RaceTimeStart;
  boolean RaceStart = false, Racing = false;

  //ting til bilen
  PVector carPos = new PVector(width/2, height/2), carBoost = new PVector(0, 0), currentCarPos;
  float startRotation = 0, maxVel = 3, maxBackVel = 1.5, stopVel = 1, bremseVel = 5, maxThetaVel = 0.02, maxThetaBackVel = 0.02, acceleration = 0.01, thetaAcc = 0.014;
  int carWidth = 55, carHeight = 25;
  Car car;


  //Ting til seed og menu
  int seed = int(random(0, 9999));
  int seedOld = seed;
  Menu gameMenu;

  GameLogic(PApplet thePApplet) {
    car = new Car(carPos, ice, startRotation, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, thetaAcc, carWidth, carHeight);

    gameMenu = new Menu(thePApplet, seed);
    bane = new Bane(seed);
  }

  void Update() {
    //laver en ny bane hvis seedet er ændret
    if (seed != seedOld) {
      seedOld = seed;
      bane.NyBane(seed);
    }
    //gør at man kan toggle hitboxes med h
    toggleTemp = toggle(h, hF, hitboxDebug);
    hitboxDebug = toggleTemp[0];
    hF = toggleTemp[1];

    //gør at man kan toggle tilemaptest med t
    toggleTemp = toggle(t, tF, tileTest);
    tileTest = toggleTemp[0];
    tF = toggleTemp[1];

    //gør at man kan toggle menuen med tab
    toggleTemp = toggle(tab, tabF, menu);
    menu = toggleTemp[0];
    tabF = toggleTemp[1];

    bane.Draw(tileTest, hitboxDebug);

    bane.CalculateCollisions(car.GetPos(), carWidth, carHeight);
    
    //printer frametime
    //println(millis()-mSec);
    mSec = millis();

    car.Update(hojre, venstre, op, ned, givBoost, hitboxDebug);

    handleTimer();
    DrawUI();

    if (menu) gameMenu.Update(space);
    if (enter ) seed = int(gameMenu.textField.input());

    currentCarPos = car.GetPos(); //til når der skal tjekkes kollision med bilen 

    DrawUI();
    if (tileTest) bane.Draw(tileTest, hitboxDebug);
  }

  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
    textSize(50);
    fill(0, 0, 0);

    //skal kombineres med collision tjek med start
    text("Round: "+CurrentRound+"/"+TotalRounds, 15, 65);
    rect(312, 0, 10, 100, 0, 0, 10, 10);

    DrawTime(Record, RaceTime);
    rect(745, 0, 10, 100, 0, 0, 10, 10);
    rect(1245, 0, 10, 100, 0, 0, 10, 10);

    textSize(25);
    text("Press TAB to open menu and view controls", 1335, 50);
    textSize(17);
    text("Current seed: "+seed, 1335, 70);
  }

  //sørger for at controls virker
  void HandleInput(int k, boolean b) {

    if (k == 39) hojre = b;
    if (k == 37) venstre = b;
    if (k == 38) op = b;
    if (k == 40) ned = b;
    if (k == 82) r = b;
    if (k == 84) t = b;
    if (k == 32) space = b; //Kun et random seed per tryk
    if (k == 9) tab = b;
    if (k == 10) enter = b;
    if (k == 66) givBoost = b;
    if (k == 72) h = b;
  }

  //a bit of stuff for the timer and logic for handling record time when starting a race
  void handleTimer() {
    if (RaceStart) {
      Racing = true;
      RaceTime = 0;
      CurrentRound = 1;
      RaceTimeStart = millis();
      RaceStart = false;
    }
    //måler tiden fra starten af race
    if (Racing) {
      RaceTime = millis() - RaceTimeStart;
    }
    //logic for når race er ovre
    if (Racing && CurrentRound > TotalRounds) {
      Racing = false;
      CurrentRound = 0;
      if (RaceTime < Record) Record = RaceTime;
      else if (Record == 0 && RaceTime != 0) Record = RaceTime;
    }
  }

  //Timer drawing
  void DrawTime(int RecordTime, int Time) {
    int min, sec;
    int RecordMin, RecordSec;
    fill(0, 0, 0);
    textSize(50);

    //konverterer tiden til læsbar format for racetime
    min = floor(Time/60000f);
    Time = Time - floor(Time/60000f)*60000;
    sec = floor(Time/1000f);
    Time = Time - floor(Time/1000f)*1000;
    text("Time: "+min+":"+sec+"."+Time, 340, 65);

    //samme som overstående men blot for rekord tiden
    RecordMin = floor(RecordTime/60000f);
    RecordTime = RecordTime - floor(RecordTime/60000f)*60000;
    RecordSec = floor(RecordTime/1000f);
    RecordTime = RecordTime - floor(RecordTime/1000f)*1000;
    text("Record: "+RecordMin+":"+RecordSec+"."+RecordTime, 775, 65);
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
