class GameLogic { //<>// //<>// //<>//

  SQLite db;
  Bane bane;
  int mSec, collisionTime, baneDrawTime, miscTime, waitTime = 2500, waitTimer = 0, logInFix = 1;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, tabF=false, enter=false, h = false, hF = false, g = false, gF = false, l = false, lF = false, m = false, mF = false, ctrl = false, s = false; //kun til taster
  boolean ice = false, givBoost = false, tileTest = false, menu = false, loginScreenOpen = true, hitboxDebug = false, coolGraphics, seedMenu = false; //til andre bools

  boolean[] toggleTemp; 
  PVector start;

  //Til saved seeds og scores
  float[] savedTime = {69.9, 100, 250, 10};
  int[] savedSeeds = {1, 3, 200, 69};

  //Til runde counter
  int currentRound = 0, TotalRounds = 3;

  //Til time counter
  int record, raceTime = 0, raceTimeStart;
  boolean raceStart = false, racing = false;

  //ting til bilen
  PVector carPos = new PVector(width/2, height/2), carBoost = new PVector(0, 0), currentCarPos;
  float startRotation = 0, maxVel = 3, maxBackVel = 1.5, stopVel = 1, bremseVel = 5, maxThetaVel = 0.02, maxThetaBackVel = 0.02, acceleration = 0.01, thetaAcc = 0.014;
  int carWidth = 55, carHeight = 25;
  Car car;

  //Til boosts
  float boostProbability = 0.05;
  int maxBoosts = 3;

  //Ting til seed og menu
  int seed = int(random(0, 9999));
  int seedOld = seed;
  Menu gameMenu;
  SeedMenu manageSeeds;

  //Ting til login skærm
  LoginScreen loginScreen;
  int ort = 1;
  String currentUsername = "";
  String[] loginData = new String[3];

  GameLogic(PApplet thePApplet) {
    car = new Car(carPos, ice, startRotation, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, thetaAcc, carWidth, carHeight);
    db = new SQLite( thePApplet, "seeds.sqlite" );
    gameMenu = new Menu(thePApplet, seed);
    loginScreen = new LoginScreen(thePApplet);
    manageSeeds = new SeedMenu();

    bane = new Bane(seed, maxBoosts, boostProbability);
    ordenBil();
  }

  void Update() {
    miscTime = millis();
    OrdnLogin(loginData);
    imageMode(CORNER);
    if (coolGraphics)image(backdrop, 0, 120);

    //laver en ny bane hvis seedet er ændret
    if (seed != seedOld || r) {
      System.gc();
      seedOld = seed;
      bane.NyBane(seed);
      ordenBil();
      racing = false;
      currentRound = bane.startCollision(currentRound, true);
      if (!r) record = 0;
      waitTimer = 0;
    }

    if (op && !racing && millis() > waitTimer + waitTime) {
      raceStart = true;
    }

    currentRound = bane.startCollision(currentRound, false);

    if (currentRound < 0) currentRound = 0;

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


    //gør at man kan toggle log in skærmen
    toggleTemp = toggle(l, lF, loginScreenOpen);
    loginScreenOpen = toggleTemp[0];
    lF = toggleTemp[1];

    //gør at man kan toggle seed menuen med s
    toggleTemp = toggle(m, mF, seedMenu);
    seedMenu = toggleTemp[0];
    mF = toggleTemp[1];


    //gør at man kan toggle grafik med g
    toggleTemp = toggle(g, gF, coolGraphics);
    coolGraphics = toggleTemp[0];
    gF = toggleTemp[1];


    baneDrawTime = millis();
    bane.Draw(tileTest, hitboxDebug, coolGraphics);
    //println("BaneDrawTime: "+(millis()-baneDrawTime)); //print time it takes to draw bane

    collisionTime = millis();
    if (car.Hit(bane.CalculateCollisions(car.GetPos(), carWidth, carHeight, car.GetRot(), hitboxDebug), tileTest, givBoost) == -1) {
      System.gc();
      seedOld = seed;
      bane.NyBane(seed);
      ordenBil();
      racing = false;
      currentRound = bane.startCollision(currentRound, true);
      if (!r) record = 0;
      waitTimer = 0;
    }
    //println("collision time: "+millis()-collisionTime); //printer tiden det tog a lave collision detection

    //println(1/((millis()-mSec)/1000f)); //printer framerate
    //println("Frametime: "+(millis()-mSec)); //printer frametime
    mSec = millis();

    car.Update(hojre, venstre, op, ned, bane.checkBoostCollisions(), hitboxDebug, racing, loginScreenOpen);

    handleTimer();
    DrawUI();

    if (menu) gameMenu.Update(space);

    if (seedMenu) manageSeeds.Update();
    if (menu && enter) seed = int(gameMenu.textField.input());

    if (ort == 1 && loginScreenOpen) {
      loginScreen.username.openRemoveText();
      loginScreen.password.openRemoveText();
      ort = 2;
    } else if (!loginScreenOpen) ort = 1;

    if (!loginScreen.canClose) loginScreenOpen = true;
    if (loginScreenOpen) loginData = loginScreen.Update(enter, op, ned, logInFix);
    else logInFix++;


    currentCarPos = car.GetPos(); //til når der skal tjekkes kollision med bilen 

    DrawUI();
    if (tileTest) bane.Draw(tileTest, hitboxDebug, coolGraphics);

    HandleSeedDB(false); //Her skal en funktion være istedet for false, der er true hvis man vil gemme sit seed.

    //println("MiscTime: "+(millis()-miscTime));

    HandleSeedDB(ctrl && s && seedMenu);
  }

  void DrawUI() {
    fill(180, 200, 220);
    rect(0, 0, width, 120);
    textSize(50);
    fill(0, 0, 0);

    //skal kombineres med collision tjek med start
    text("Round: "+currentRound+"/"+TotalRounds, 15, 65);
    rect(312, 0, 10, 100, 0, 0, 10, 10);

    DrawTime(record, raceTime);
    rect(745, 0, 10, 100, 0, 0, 10, 10);
    rect(1245, 0, 10, 100, 0, 0, 10, 10);

    textSize(25);
    text("Press TAB to open menu and view controls", 1335, 50);
    text("Press M to manage saved seeds", 1335, 80);
    textSize(17);
    text("Current seed: "+seed, 1335, 100);
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
    if (k == 66) givBoost = b;
    if (k == 72) h = b;
    if (k == 71) g = b;
    if (k == 81) l = b;
    if (k == 83) s = b;
    if (k == 77) m = b;
    if (k == 17) ctrl = b;
  }

  //a bit of stuff for the timer and logic for handling record time when starting a race
  void handleTimer() {
    if (raceStart) {
      racing = true;
      raceTime = 0;
      raceTimeStart = millis();
      raceStart = false;
    }
    //måler tiden fra starten af race
    if (racing && !loginScreenOpen) {
      raceTime = millis() - raceTimeStart;
    }
    //logic for når race er ovre
    if (racing && currentRound > TotalRounds) {
      racing = false;
      ordenBil();
      currentRound = 0;
      waitTimer = millis();
      if (raceTime < record) record = raceTime;
      else if (record == 0 && raceTime != 0) record = raceTime;
    }
  }

  //Timer drawing
  void DrawTime(int recordTime, int time) {
    int min, sec;
    int recordMin, recordSec;
    fill(0, 0, 0);
    textSize(50);

    //konverterer tiden til læsbar format for racetime
    min = floor(time/60000f);
    time = time - floor(time/60000f)*60000;
    sec = floor(time/1000f);
    time = time - floor(time/1000f)*1000;
    text("Time: "+min+":"+sec+"."+time, 340, 65);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(recordTime/60000f);
    recordTime = recordTime - floor(recordTime/60000f)*60000;
    recordSec = floor(recordTime/1000f);
    recordTime = recordTime - floor(recordTime/1000f)*1000;
    text("record: "+recordMin+":"+recordSec+"."+recordTime, 775, 65);
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

  void ordenBil() {
    int[] tt = bane.whereStart();
    car.placeCar(new PVector(tt[0]*160+40, tt[1]*160+200), tt[2]);
  }

  boolean checkDB() {
    return db.connect(); //Er der fejl med databasen skal programmet lukkes
  }

  void HandleSeedDB(boolean g) {
    String sql = "";
    db.query( "SELECT seed FROM HS WHERE seed="+seed+";" );
    if (g) {
      if (db.next()) {
        sql = "UPDATE HS SET time="+record+";";
      } else { 
        sql = "INSERT INTO HS VALUES("+seed+","+record+",'"+currentUsername+"');";
      }
    } else if (db.next()) {
      record = db.getInt(2);
    }
    if (sql != "") db.execute(sql);
  }

  int OrdnLogin(String[] a) {
    String sql = "";
    if (a[0] == null) return 4;
    db.query( "SELECT username FROM PW WHERE username='"+a[1]+"';" );
    if (a[0] != "Log in") {
      if (!db.next()) {
        sql = "INSERT INTO PW VALUES('"+a[1]+"','"+a[2]+"');";
        db.execute(sql);
        currentUsername = a[1];
        return 0;
      } else return 1; //Hvis brugernavnet allerede findes
    } else {
      if (db.next()) {
        db.query( "SELECT username FROM PW WHERE username='"+a[1]+"' AND password='"+a[2]+"';" );
        if (db.next()) { 
          currentUsername = a[1];
          return 3;
        }
      } else return 2;
    }
    return -1;
  }
}
