class Blok {

  int blokkeIalt = 4;
  int[][] blokInfo = new int[blokkeIalt][5];

  //constructer
  Blok() {
    InitialiserInfo();
  }

  //returnerer det tal under en bloks id der er ønsket.
  int GetBlokInfo(int id, int a) {
    return blokInfo[id][a];
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  void DrawBlok(int id) {
    switch (id) {
    case 0: //Start blok
      DrawB0();
      break;
    case 1:
      DrawB1();
      break;
    case 2:
      DrawB2();
      break;
    case 3:
      DrawB3();
      break;

    default:
      return;
    }
    //Reverter til default
    stroke(20);
    strokeWeight(1);
  }

  int GetBlokIalt() {
    return blokkeIalt;
  }

  //Initialiserer alle blokkenes info i et info array
  void InitialiserInfo() {
    //hardkoder blokkenes info
    //Size, Inpoint x, Inpoint y, Outpoint x, Outpoint y, outpoint retning i forhold til inpoint(0frem,1højre,2tilbage,3venstre)

    //Start blok
    int[] startblok = {1, 0, 80, 160, 80, 0};
    blokInfo[0] = startblok;

    //højressvings blok
    int[] hojresving = {1, 0, 80, 80, 160, 1};
    blokInfo[1] = hojresving;

    //Vesntresvings blok
    int[] venstresving = {1, 0, 80, 80, 0, 3};
    blokInfo[2] = venstresving;

    //Ligeud blok
    int[] ligeud = {1, 0, 80, 160, 80, 0};
    blokInfo[3] = ligeud;
  }



  //Start blok Draw
  void DrawB0() {
    fill(250, 200, 250);
    strokeWeight(0);
    stroke(20);
    square(0, 0, 160);
    fill(20);
    rect(0,0,160,30);
    rect(0,130,160,30);
    strokeWeight(5);
    line(85, 30, 85, 130);
    line(75, 30, 75, 130);
    stroke(255);
    line(80, 30, 80, 130);
  }

  //Højresving blok Draw
  void DrawB1() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(30, 30, 100, 130);
    rect(0, 30, 31, 100);
  }

  //Venstresving blok Draw
  void DrawB2() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(30, 0, 100, 130);
    rect(0, 30, 31, 100);
  }

  //Ligeud blok Draw
  void DrawB3() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(0, 30, 160, 100);

  }
}
