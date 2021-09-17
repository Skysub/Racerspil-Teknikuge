class Blok {

  int blokkeIalt = 4;
  int[][] blokInfo = new int[blokkeIalt][5];
  
  PImage startTexture,straightTexture,rightCornerTexture,leftCornerTexture;
  

  //constructer
  Blok() {
    
    startTexture = loadImage("Start.png");
    straightTexture = loadImage("Straight.png");
    rightCornerTexture = loadImage("Right.png");
    leftCornerTexture = loadImage("Left.png");
    
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
    rect(0, 0, 160, 20);
    rect(0, 140, 160, 20);
    strokeWeight(5);
    line(85, 20, 85, 140);
    line(75, 20, 75, 110);
    stroke(255);
    line(80, 20, 80, 140);
    
    imageMode(CORNER);
    //image(startTexture,0,0);
  }

  //Højresving blok Draw
  void DrawB1() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 20, 120, 140);
    rect(0, 20, 20, 120);
    
    imageMode(CORNER);
    //image(rightCornerTexture,0,0);
  }

  //Venstresving blok Draw
  void DrawB2() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 0, 120, 140);
    rect(0, 20, 20, 120);
    
    imageMode(CORNER);
    //image(leftCornerTexture,0,0);
  }

  //Ligeud blok Draw
  void DrawB3() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(0, 20, 160, 120);
    
    imageMode(CORNER);
    //image(straightTexture,0,0);
  }
}
