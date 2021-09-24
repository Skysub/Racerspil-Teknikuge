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
  void DrawBlok(int id, boolean hDb, Boolean gfx, float boostProb) {
    switch (id) {
    case 0: //Start blok
      if (!hDb)DrawB0(gfx);
      else DrawOldB0();
      break;
    case 1:
      if (!hDb)DrawB1(gfx,boostProb);
      else DrawOldB1();
      break;
    case 2:
      if (!hDb)DrawB2(gfx,boostProb);
      else DrawOldB2();
      break;
    case 3:
      if (!hDb)DrawB3(gfx,boostProb);
      else DrawOldB3();
      break;

    default:
      return;
    }
    //Reverter til default
    stroke(20);
    strokeWeight(1);
     //<>// //<>//
  }

  int GetBlokIalt() {
    return blokkeIalt;
  }

  //returnerer alle hitboxes der kunne skære bilen, med deres relative shift
  PVector[][][] GetHitboxes(PVector sted, int[][][] bane) {
    int felter = 5;
    if (bane[int(sted.x)][int(sted.y)][0] == -1) felter--;
    if (sted.x == 0)felter--;
    else if (bane[int(sted.x)-1][int(sted.y)][0] == -1) felter--;
    if (sted.x == 11)felter--;
    else if (bane[int(sted.x)+1][int(sted.y)][0] == -1) felter--;
    if (sted.y == 0)felter--;
    else if (bane[int(sted.x)][int(sted.y)-1][0] == -1) felter--;
    if (sted.y == 5) felter--;
    else if (bane[int(sted.x)][int(sted.y)+1][0] == -1) felter--;
    PVector[][][] x = new PVector[felter][][];
    int next = 0;

    if (bane[int(sted.x)][int(sted.y)][0] != -1) {
      x[next] = GetBlokHitboxes(bane[int(sted.x)][int(sted.y)][0], new PVector(0, 0), bane[int(sted.x)][int(sted.y)][1]);
      next++;
    }

    if (sted.x != 0) {
      if (bane[int(sted.x)-1][int(sted.y)][0] != -1) {
        x[next] = GetBlokHitboxes(bane[int(sted.x)-1][int(sted.y)][0], new PVector(-1, 0), bane[int(sted.x)-1][int(sted.y)][1]);
        next++;
      }
    }
    if (sted.x != 11) {
      if (bane[int(sted.x)+1][int(sted.y)][0] != -1) {
        x[next] = GetBlokHitboxes(bane[int(sted.x)+1][int(sted.y)][0], new PVector(1, 0), bane[int(sted.x)+1][int(sted.y)][1]);

        next++;
      }
    }
    if (sted.y != 0) {
      if (bane[int(sted.x)][int(sted.y)-1][0] != -1) {
        x[next] = GetBlokHitboxes(bane[int(sted.x)][int(sted.y)-1][0], new PVector(0, -1), bane[int(sted.x)][int(sted.y)-1][1]);
        next++;
      }
    }
    if (sted.y != 5) {
      if (bane[int(sted.x)][int(sted.y)+1][0] != -1) {
        x[next] = GetBlokHitboxes(bane[int(sted.x)][int(sted.y)+1][0], new PVector(0, 1), bane[int(sted.x)][int(sted.y)+1][1]);
        next++;
      }
    }
    return x;
  }

  //returnerer alle hitboxes fra blokken med relativt shift i forhold til blokken bilen er i
  PVector[][] GetBlokHitboxes(int id, PVector shift, int blokRot) {
    PVector[][] temp = new PVector[0][0];
    switch (id) {
    case 0: //Start blok
      temp = BoxesB0(blokRot);
      break;
    case 1:
      temp = BoxesB1(blokRot);
      break;
    case 2:
      temp = BoxesB2(blokRot);
      break;
    case 3:
      temp = BoxesB3(blokRot);
      break;

    default:
      break;
    }
    for (int i = 0; i<temp.length; i++) {
      temp[i][0].sub(new PVector(80, 80));
      temp[i][0].rotate(blokRot*PI/2f);
      temp[i][0].add(new PVector(80, 80));

      temp[i][1].rotate(blokRot*PI/2f);
      temp[i][0].add(new PVector(shift.x*160,shift.y*160));
    }
    return temp;
  }

  //Hitbox information for hvert blok skrives her
  //returnerer alle hitboxes fra blokken med relativt shift i forhold til blokken bilen er i

  //hitboxes startblok
  PVector[][] BoxesB0(int blokRot) {
    PVector[][] boxes = new PVector[2][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(160, 20);

    boxes[1][0] = new PVector(0, 140);
    boxes[1][1] = new PVector(160, 20);

    return boxes;
  }

  //højresvingsblok hitboxes
  PVector[][] BoxesB1(int blokRot) {
    PVector[][] boxes = new PVector[3][2];

    boxes[0][0] = new PVector(0, 140);
    boxes[0][1] = new PVector(20, 20);

    boxes[1][0] = new PVector(0, 0);
    boxes[1][1] = new PVector(160, 20);

    boxes[2][0] = new PVector(140, 20);
    boxes[2][1] = new PVector(20, 140);

    return boxes;
  }

  //Venstresvingsblok hitboxes
  PVector[][] BoxesB2(int blokRot) {
    PVector[][] boxes = new PVector[3][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(20, 20);

    boxes[1][0] = new PVector(0, 140);
    boxes[1][1] = new PVector(160, 20);

    boxes[2][0] = new PVector(140, 0);
    boxes[2][1] = new PVector(20, 140);

    return boxes;
  }

  //Ligeudblok hitboxes
  PVector[][] BoxesB3(int blokRot) {
    PVector[][] boxes = new PVector[2][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(160, 20);

    boxes[1][0] = new PVector(0, 140);
    boxes[1][1] = new PVector(160, 20);

    return boxes;
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
  void DrawB0(boolean gfx) {
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
    
    if(gfx) {
    imageMode(CORNER);
    image(startTexture,0,0,160,160);
    }
  }

  //Højresving blok Draw
  void DrawB1(boolean gfx, float boostProb) {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 20, 120, 140);
    rect(0, 20, 20, 120);
    
    if(gfx) {
    imageMode(CORNER);
    image(rightCornerTexture,0,0,160,160);
    }
  }

  //Venstresving blok Draw
  void DrawB2(boolean gfx, float boostProb) {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 0, 120, 140);
    rect(0, 20, 20, 120);
    
    if(gfx) {
    imageMode(CORNER);
    image(leftCornerTexture,0,0,160,160);
    }
  }

  //Ligeud blok Draw
  void DrawB3(boolean gfx, float boostProb) {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(0, 20, 160, 120);
    
    if(gfx) {
    imageMode(CORNER);
    image(straightTexture,0,0,160,160);
    }
  }


  //Hernede tegnes de gamle blokke, der kan man nemmere se hitboxes

  //Start blok Draw
  void DrawOldB0() {
    fill(0, 0, 255);
    strokeWeight(0);
    stroke(20);
    square(0, 0, 160);
    fill(20);
    rect(0, 0, 160, 20);
    rect(0, 140, 160, 20);
    fill(255, 0, 0);
    rect(40, 20, 20, 120);
  }

  //Højresving blok Draw
  void DrawOldB1() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 20, 120, 140);
    rect(0, 20, 20, 120);
  }

  //Venstresving blok Draw
  void DrawOldB2() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 0, 120, 140);
    rect(0, 20, 20, 120);
  }

  //Ligeud blok Draw
  void DrawOldB3() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(0, 20, 160, 120);
  }
}
