class Bane {
  int[][][] bane, dBTS;
  Blok blok;
  int ss;

  Bane() {
    blok = new Blok();

    bane = new int [12][6][2];
    dBTS = lavDebugTileSet(blok.GetBlokIalt());
  }



  void Draw(boolean tT) {
    pushMatrix();
    translate(120, 0);

    if(!tT)DrawBane(bane);
    else DrawBane(dBTS);

    popMatrix();
  }

  //Tegner selve alle tilesne som beskrevet i bane arrayet
  void DrawBane(int[][][] x) {
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
