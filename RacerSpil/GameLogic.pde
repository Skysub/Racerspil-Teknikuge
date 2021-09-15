class GameLogic { //<>// //<>// //<>//

  Bane bane;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, enter=false; //kun til taster
  boolean ice = false, tileTest = false; //til andre bools
  boolean[] toggleTemp; 
  
  //Til runde counter
  int CurrentRound = 1, TotalRounds = 3;

  //Til time counter
  int Record, RaceTime = 60000, RaceTimeStart;
  boolean RaceStart = false, Racing = false;

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
    if(tileTest) bane.Draw(tileTest);
  }

  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
    textSize(50);
    fill(0,0,0);
    
    //Runde counter findes pt ikke. Dermed vil dette blot skrive Round: 1/3
    text("Round: "+CurrentRound+"/"+TotalRounds, 15, 65);
    rect(312, 0, 10, 100, 0, 0, 10, 10);
    
    DrawTime(Record, RaceTime);
    rect(635, 0, 10, 100, 0, 0, 10, 10);
    rect(1010, 0, 10, 100, 0, 0, 10, 10);
    
    
    
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
  
  //a bit of stuff for the timer and logic for handling record time when starting a race
  void handleTimer(){
    if (RaceStart) {
      Racing = true;
      if (RaceTime < Record) Record = RaceTime;
      RaceTime = 0;
      RaceTimeStart = millis();
    }
    if (Racing) {
      RaceTime = millis() - RaceTimeStart;
    }
    if (Racing && CurrentRound > TotalRounds){
      Racing = false;
      if (RaceTime < Record) Record = RaceTime;
    }
  }
  
  //Timer drawing
  void DrawTime(int RecordTime, int Time) {
    int min, sec;
    int RecordMin, RecordSec;
    fill(0,0,0);
    textSize(50);
    
    min = floor(Time/60000f);
    Time = Time - floor(Time/60000f)*60000;
    sec = floor(Time/1000f);
    Time = Time - floor(Time/1000f)*1000;
    
    text("Time: "+min+":"+sec+"."+Time,340,65);
    
    RecordMin = floor(Time/60000f);
    RecordTime = RecordTime - floor(Time/60000f)*60000;
    RecordSec = floor(Time/1000f);
    RecordTime = RecordTime - floor(Time/1000f)*1000;
    text("Record: "+RecordMin+":"+RecordSec+"."+RecordTime,665,65);
    
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
