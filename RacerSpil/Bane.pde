class Bane {
  int[][][] bane, dBTS;
  Blok blok;
  int ss;

  Bane() {
    blok = new Blok();

    bane = new int [12][6][2];
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        bane[j][i][0] = -1;
      }
    }



    dBTS = lavDebugTileSet(blok.GetBlokIalt());
  }



  void Draw(boolean tT) {
    pushMatrix();
    translate(0, 120);

    if (!tT)DrawBane(bane, tT);
    else DrawBane(dBTS, tT);

    popMatrix();
  }

  //Tegner selve alle tilesne som beskrevet i bane arrayet
  void DrawBane(int[][][] x, boolean tT) {
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        pushMatrix();
        translate(-80, -80);
        rotate(x[j][i][1]*PI/2f);
        translate(80+(160*j), 80+(160*i));
        if (tT) translate(2*j, 2*i);
        blok.DrawBlok(x[j][i][0]);
        popMatrix();
      }
    }
  }



  //Tager alle blokke fra blok klassen og lægger dem ind i en bane én efter hindanden, er lavet til at man nemt kan tjekke hvordan hver blok ser ud ved at trykke t.
  int[][][] lavDebugTileSet(int bIalt) {
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
