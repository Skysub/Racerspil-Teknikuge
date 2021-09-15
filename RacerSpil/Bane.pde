class Bane {
  int[][][] bane, dBTS;
  Blok blok;
  int ss;

  Bane(int seed) {
    blok = new Blok();
    dBTS = LavDebugTileSet(blok.GetBlokIalt());
    bane = GenererBane(seed);
  }

  void Draw(boolean tT) {
    pushMatrix();
    translate(0, 120);

    if (!tT)DrawBane(bane, tT);
    else DrawBane(dBTS, tT);

    popMatrix();
  }

  //Generer banen tilfældigt ved hjælp af et seed
  int[][][] GenererBane (int seed) {
    randomSeed(seed);

    //initialiserer og gør alle blok id'er til -1, så de ikke render hvis de ikke bliver overskrevet.
    int[][][] b = new int [12][6][2];
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        b[j][i][0] = -1;
      }
    }

    //Vælger et tilfældigt sted til starten og rotere starten i forhold til kvadranten
    PVector sted = new PVector(random(0, 11), random(0, 5));
    b[int(sted.x)][int(sted.y)][0] = 0;

    //sørger for at start ikke er i et hjørne
    if (sted.x == 0 || sted.x == 11) {
      if (sted.y == 0) sted.y++;
      else if (sted.y == 5) sted.y--;
    }

    //rotering
    if (sted.x > 1 && sted.x < 10) {
      if (sted.y > 2) b[int(sted.x)][int(sted.y)][1] = 2;
    } else {
      if (sted.x < 2) b[int(sted.x)][int(sted.y)][1] = 3;
      else b[int(sted.x)][int(sted.y)][1] = 1;
    }


    return b;
  }

  //Tegner alle blokkene som beskrevet i bane arrayet
  void DrawBane(int[][][] x, boolean tT) {
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        pushMatrix();
        resetMatrix();
        translate(width/2,height/2);
        rotate(x[j][i][1]*PI/2f);
        
        translate(-width/2,-height/2);
        translate((160*j), (160*i));
        if (tT) translate(2*j, 2*i);
        blok.DrawBlok(x[j][i][0]);
        popMatrix();
      }
    }
  }

  //Tager alle blokke fra blok klassen og lægger dem ind i en bane én efter hindanden, er lavet til at man nemt kan tjekke hvordan hver blok ser ud ved at trykke t.
  int[][][] LavDebugTileSet(int bIalt) {
    int[][][] a = new int [12][6][2];
    int blok = 0;

    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        a[j][i][0] = blok;
        a[j][i][1] = 0;
        if (blok-1 == bIalt) blok = -1;
        if (blok != -1) {
          blok++;
        }
      }
    }
    return a;
  }
}
