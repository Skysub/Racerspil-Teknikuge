class Bane {
  int[][][] bane, dBTS;
  Blok blok;
  int ss;
  int bIalt;

  Bane(int seed) {
    blok = new Blok();
    bIalt = blok.GetBlokIalt();
    dBTS = LavDebugTileSet(bIalt);
    bane = GenererBane(seed);
  }

  void Draw(boolean tT) {
    pushMatrix();
    translate(0, 120);

    if (!tT)DrawBane(bane, tT);
    else DrawBane(dBTS, tT);

    popMatrix();
  }

  void NyBane(int seed) {
    bane = GenererBane(seed);
  }

  //Generer banen tilfældigt ved hjælp af et seed
  int[][][] GenererBane (int seed) {
    randomSeed(seed);

    //initialiserer og gør alle blok id'er til -1, så de ikke render hvis de ikke bliver overskrevet.
    int[][][] b = new int [12][6][2];
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        b[j][i][0] = -1;        
        b[j][i][1] = 0;
      }
    }
    PVector start = PlacerStart(b);
    PVector sted = new PVector(start.x, start.y);
    int blokF = 0, blokke = 0;
    int blokC, rot, tRot, rotF = b[int(sted.x)][int(sted.y)][1];
    tRot = rotF;

    while (true) {
      tRot = rotF+blok.GetBI(blokF, 3);
      //println(sted);
      if ((tRot+1) % 4 == 0) sted.sub(new PVector(0, 1));//3
      if ((tRot-1) % 4 == 0) sted.add(new PVector(0, 1)); //1
      if (tRot % 4 == 0)   sted.add(new PVector(1, 0)); //0
      if ((tRot+2) % 4 == 0) sted.sub(new PVector(1, 0));//2
      blokke++;
      if (sted == start) break;
      if (blokke > 50) break;

      /*println(sted);
       println("yes!");
       println(blokF);
       println();*/
      int fuck = 0;
      while (true) {
        blokC = int(random(1, bIalt));
        rot = rotF+blok.GetBI(blokF, 3);
        tRot = rot+blok.GetBI(blokC, 3);

        if ((tRot+1) % 4 == 0) {
          if (sted.y != 0 && !(sted.y == 3 && sted.x > 1) && !(sted.x > 9 && sted.y < 3) && (b[int(sted.x)][int(sted.y)-1][0] == -1)) break;
        }
        if ((tRot-1) % 4 == 0) {
          if (sted.y != 5 && !(sted.y == 2 && sted.x < 10) && !(sted.x < 2 && sted.y > 1)&& (b[int(sted.x)][int(sted.y)+1][0] == -1)) break;
        }
        if (tRot % 4 == 0) {
          if (sted.x != 11 && !(sted.y > 2)&& (b[int(sted.x)+1][int(sted.y)][0] == -1)) break;
        }
        if ((tRot+2) % 4 == 0) {
          if (sted.x != 0 && !(sted.y < 3)&& (b[int(sted.x)-1][int(sted.y)][0] == -1)) break;
        }
        fuck++;
        if (fuck > 100)break;
      }
      if (fuck > 100)break;
      blokF = blokC;
      rot = rot % 4;
      rotF = rot;
      b[int(sted.x)][int(sted.y)][0] = blokF;
      b[int(sted.x)][int(sted.y)][1] = rotF;
    }
    /*
    //printer id for hvert felt
     for (int i=0; i<6; i++) {
     for (int j=0; j<12; j++) {
     if (b[j][i][0] != -1)print(" "+b[j][i][0]+" ");
     else print(b[j][i][0]+" ");
     }
     println();
     }
     
     //printer rotation for hvret felt
     for (int i=0; i<6; i++) {
     for (int j=0; j<12; j++) {
     print(b[j][i][1]+" ");
     }
     println();
     }*/
    return b;
  }

  //Tegner alle blokkene som beskrevet i bane arrayet
  void DrawBane(int[][][] x, boolean tT) {
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        pushMatrix();
        translate((160*j), (160*i));
        if (tT) translate(2*j, 2*i);
        if (x[j][i][1] == 1) translate(160, 0);
        if (x[j][i][1] == 2) translate(160, 160);
        if (x[j][i][1] == 3) translate(0, 160);
        rotate(x[j][i][1]*PI/2f);

        blok.DrawBlok(x[j][i][0]);
        popMatrix();
      }
    }
  }

  PVector PlacerStart(int[][][] b) {
    //Vælger et tilfældigt sted til starten og rotere starten i forhold til kvadranten
    PVector sted = new PVector(int(random(-0.49f, 11.49f)), int(random(-0.49f, 5.49f)));


    //sørger for at start ikke er i et hjørne
    if (sted.x == 0) {
      if (sted.y == 0) { 
        sted.y++; 
        sted.x++;
      } else if (sted.y == 5) {
        sted.y--;
        sted.x++;
      }
    } else if (sted.x == 11) {
      if (sted.y == 0) { 
        sted.y++; 
        sted.x--;
      } else if (sted.y == 5) {
        sted.y--;
        sted.x--;
      }
    }

    b[int(sted.x)][int(sted.y)][0] = 0;

    //rotering
    if (sted.x != 0 && sted.x != 11) {
      if (sted.y == 2 || sted.y == 3) {
        if (sted.x == 1) b[int(sted.x)][int(sted.y)][1] = 3;
        else if (sted.x == 10) b[int(sted.x)][int(sted.y)][1] = 1;
        else if (sted.y > 2) b[int(sted.x)][int(sted.y)][1] = 2;
      } else if (sted.y > 2) b[int(sted.x)][int(sted.y)][1] = 2;
    } else {
      if (sted.x == 0) b[int(sted.x)][int(sted.y)][1] = 3;
      else b[int(sted.x)][int(sted.y)][1] = 1;
    }
    return sted;
  }


  //Tager alle blokke fra blok klassen og lægger dem ind i en bane én efter hindanden, er lavet til at man nemt kan tjekke hvordan hver blok ser ud ved at trykke t.
  int[][][] LavDebugTileSet(int bIalt) {
    int[][][] a = new int [12][6][2];
    int blok = 0;

    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        a[j][i][0] = blok;
        a[j][i][1] = 3;
        if (blok-1 == bIalt) blok = -1;
        if (blok != -1) {
          blok++;
        }
      }
    }
    return a;
  }
}
