class Blok {

  int blokkeIalt = 4;
  int[][] blokInfo = new int[blokkeIalt][5];

  //constructer
  Blok() {
    InitialiserInfo();
  }

  //returnerer det tal under en bloks id der er ønsket.
  int GetBI(int id, int a) {
    return blokInfo[id][a];
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  //Vælger hvilken blok draw metode der skal bruges ud fra blok id'et
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
    //Size, outpoint vektor (ligeud 1,0  højre 0,-1  bagud -1,0  venstre 0,1), outpoint rotation

    //Start blok
    int[] startblok = {1, 1, 0, 0};
    blokInfo[0] = startblok;

    //højressvings blok
    int[] hojresving = {1, 0, 1, 1};
    blokInfo[1] = hojresving;

    //Vesntresvings blok
    int[] venstresving = {1, 0, -1, 3};
    blokInfo[2] = venstresving;

    //Ligeud blok
    int[] ligeud = {1, 1, 0, 0};
    blokInfo[3] = ligeud;
  }

  //Hver blok skal drawes anderledes og har derfor hvert sin metode der bliver kaldt via switchen tiddligere

  //Start blok Draw
  void DrawB0() {
    fill(250, 200, 250);
    strokeWeight(0);
    stroke(20);
    square(0, 0, 160);
    fill(20);
    rect(0, 0, 160, 30);
    rect(0, 130, 160, 30);
    strokeWeight(5);
    line(85, 30, 85, 130);
    line(75, 30, 75, 100);
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
