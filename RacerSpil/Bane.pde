class Bane {
  int[][][] bane, dBTS;
  Blok blok;
  int bIalt; //Antallet af blokke der er ialt, bruges til at lave debug tilesettet med alle blokkene

  Bane(int seed) {
    blok = new Blok();
    bIalt = blok.GetBlokIalt();
    dBTS = LavDebugTileSet(bIalt); //Laver debug tilesettet
    NyBane(seed); //genererer banen
  }

  void Draw(boolean tT, boolean hDb) {
    pushMatrix();
    translate(0, 120); //flytter alt ned så ui ikke bliver dækket

    //Vælger banen eller debug tilesettet givet tT (tileTest)
    if (!tT)DrawBane(bane, tT, hDb);
    else DrawBane(dBTS, tT, hDb);

    popMatrix();
  }

  float CalculateCollisions(PVector carPos, int carW, int carH, float carRot, boolean hDb) {
    PVector relativeCarPos = new PVector(carPos.x % 160, (carPos.y % 160)+40);
    PVector sted = new PVector(floor(carPos.x/160), floor(((carPos.y-120)/160)));

    PVector[][][] hitBoxes = blok.GetHitboxes(sted, bane);
    PVector[] carCorners = new PVector[4];
    carCorners[0] = new PVector(-carW/2f, -carH/2f); //top left
    carCorners[1]= new PVector(-carW/2f, carH/2f); // Bottom Left
    carCorners[2]= new PVector(carW/2f, -carH/2f); // Top Right
    carCorners[3]= new PVector(carW/2f, carH/2f); // Bottom Right

    PVector carRetning = new PVector(carW/2f, 0);
    carRetning.rotate(carRot);

    for (int i = 0; i<4; i++) {
      carCorners[i].rotate(carRot);
      carCorners[i].add(relativeCarPos);
    }

    for (int i = 0; i<hitBoxes.length; i++) {
      for (int j = 0; j<hitBoxes[i].length; j++) {
        if (hDb) {
          pushMatrix();
          fill(0, 255, 0);
          translate(0, 120);
          translate(sted.x*160, sted.y*160);
          rect(hitBoxes[i][j][0].x, hitBoxes[i][j][0].y, hitBoxes[i][j][1].x, hitBoxes[i][j][1].y);
          popMatrix();
        }
        for (int s = 0; s<4; s++) {

          if (hitBoxes[i][j][1].x < 0) {
            if (hitBoxes[i][j][1].y < 0) {
              if ((carCorners[s].x > hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x < hitBoxes[i][j][0].x) && (carCorners[s].y > hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y < hitBoxes[i][j][0].y)) {
                if (hDb) {
                  println("Collision!");
                  println(millis());
                  fill(255);
                  circle(carPos.x, carPos.y, 50);
                }
              } else {
                if ((carCorners[s].x > hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x < hitBoxes[i][j][0].x) && (carCorners[s].y < hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y > hitBoxes[i][j][0].y)) {
                  if (hDb) {
                    println("Collision!");
                    println(millis());
                    fill(255);
                    circle(carPos.x, carPos.y, 50);
                  }
                }
              } else {
                if (hitBoxes[i][j][1].y < 0) {
                  if ((carCorners[s].x < hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x > hitBoxes[i][j][0].x) && (carCorners[s].y > hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y < hitBoxes[i][j][0].y)) {
                    if (hDb) {
                      println("Collision!");
                      println(millis());
                      fill(255);
                      circle(carPos.x, carPos.y, 50);
                    }
                  } else {
                    if ((carCorners[s].x < hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x > hitBoxes[i][j][0].x) && (carCorners[s].y < hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y > hitBoxes[i][j][0].y)) {
                      if (hDb) {
                        println("Collision!");
                        println(millis());
                        fill(255);
                        circle(carPos.x, carPos.y, 50);
                      }
                    }
                  }


/*
                  if ((carCorners[s].x < hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x > hitBoxes[i][j][0].x) && (carCorners[s].y < hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y > hitBoxes[i][j][0].y)) {
                    //Det er fordi indersiden af kassen ikke nødvendig vis er x positiv i forhold til hitboxens position
                    //Hvis hitboxens expanse ikke er positiv i y og x er lortet broken
                    //Skal reworke metoden for hvordan punket beregnes at være inde i kassen

                    if (hDb) {
                      println("Collision!");
                      println(millis());
                      fill(255);
                      circle(carPos.x, carPos.y, 50);*/
                    }
                  }
                }
              }
            }

            return 0;
          }


          //Genererer en bane givet et seed
          void NyBane(int seed) {
            //Hvis banen der blev genereret er broken upshifter den seedet med 1 og prøver igen
            while (true) {
              bane = GenererBane(seed);
              if (bane[0][0][0] != -2) break;
              else seed++;
            }
          }

          //Generer banen tilfældigt ved hjælp af et seed
          int[][][] GenererBane (int seed) {
            randomSeed(seed);

            //initialiserer banen some et 3-dimensionelt array og gør alle blok id'er til -1, så de ikke render hvis de ikke bliver overskrevet.
            int[][][] b = new int [12][6][2];
            for (int i=0; i<6; i++) {
              for (int j=0; j<12; j++) {
                b[j][i][0] = -1;        
                b[j][i][1] = 0;
              }
            }
            PVector start = PlacerStart(b); //Så vi ved hvor start blokken er
            PVector sted = new PVector(start.x, start.y); //Et udgangspunkt til starten af generering
            PVector fStart = new PVector(start.x, start.y); //Vi skal vide hvor blokken lige før start er

            int blokF = 0, blokke = 0;
            int blokC=0, rot=0, tRot;  //tRot er den retning vi ender med at gå ud af hvis vi tænker over brikkens rotation og om den svinger
            int rotF = b[int(sted.x)][int(sted.y)][1]; //rotation Før, den tidligere briks rotation. Starter med at være startbrikkens rotation
            tRot = rotF;

            //bestemmer "før start" lokation ud fra startbrikkens rotation
            if ((tRot+1) % 4 == 0) fStart.add(new PVector(0, 1));//3
            if ((tRot-1) % 4 == 0) fStart.sub(new PVector(0, 1)); //1
            if (tRot % 4 == 0)   fStart.sub(new PVector(1, 0)); //0
            if ((tRot+2) % 4 == 0) fStart.add(new PVector(1, 0));//2

            //Dette while loop genererer banen, når banen er done springer den ud af loopet
            while (true) {
              //finder ud af hvor blokken faktisk peger hen
              tRot = rotF+blok.GetBI(blokF, 3);

              //Går til næste felt ud fra hvor den forrige blok pegede hen
              if ((tRot+1) % 4 == 0) sted.sub(new PVector(0, 1));//3
              if ((tRot-1) % 4 == 0) sted.add(new PVector(0, 1)); //1
              if (tRot % 4 == 0)   sted.add(new PVector(1, 0)); //0
              if ((tRot+2) % 4 == 0) sted.sub(new PVector(1, 0));//2

              if (sted.x == start.x && sted.y == start.y) break; //Er vi nået tilbage til der vi startede er vi done og breaker loopet
              int fuck = 0; //Fuck holder styr på hvor mange gange en blok har er blevet forsøgt placeret men fejlede.

              //Er vi der hvor den sidste brik skal sætte, gør vi det på en forudbestemt måde istedet for at bruge den tilfældige del af algoritmen
              if (sted.x == fStart.x && sted.y == fStart.y) {

                //Der bestemmes hvilken retning start peger, så vi kan vælge hvilken type blok der skal bruges. De bliver yderligere roteret for at passe.
                if (b[int(start.x)][int(start.y)][1] == tRot % 4) {
                  blokC = 3;
                  rot = b[int(start.x)][int(start.y)][1];
                }
                if (b[int(start.x)][int(start.y)][1] == (tRot + 1) % 4) {
                  blokC = 1;
                  rot = b[int(start.x)][int(start.y)][1]-1;
                  if (rot == -1) rot = 3;
                }
                if (b[int(start.x)][int(start.y)][1] == (tRot - 1) % 4) {
                  blokC = 2;
                  rot = b[int(start.x)][int(start.y)][1]+1;
                }
              } else {
                //Dette while loop forsøger at placere blokke på det 'sted' vi er nået hen til
                while (true) {
                  fuck++;
                  if (fuck > 25)break; //Har vi prøvet og fejlet at placere blokke så mange gange, then shits fucked og vi daffer
                  blokC = int(random(1, bIalt)); //Current blok, tilfældigt valgt ud fra alle blokke undtagen start
                  rot = rotF+blok.GetBI(blokF, 3); //beregner denne bloks rotation ud fra den tidligere bloks
                  tRot = rot+blok.GetBI(blokC, 3); //beregner hvor denne blok nu faktisk peger

                  //Første lag if statements bestemmer hvilken vej blokken faktisk peger.
                  //Andet lag bestemmet om blokken er inde i en zone hvor den ikke må være (ud fra hvor den peger), og om den peger på en tom plads
                  //Zonerne er grafisk beskrevet via billeddet "grid zoner.png" i "hjælp til racerprojekt generering" mappen i repositoriet.
                  if ((tRot+1) % 4 == 0) {
                    if (sted.y != 0 && !(sted.y == 3 && sted.x > 1) && !(sted.x > 9 && sted.y < 3) && ((b[int(sted.x)][int(sted.y)-1][0] == -1))) break;
                  }
                  if ((tRot-1) % 4 == 0) {
                    if (sted.y != 5 && !(sted.y == 2 && sted.x < 10) && !(sted.x < 2 && sted.y > 1)&& ((b[int(sted.x)][int(sted.y)+1][0] == -1))) break;
                  }
                  if (tRot % 4 == 0) {
                    if (sted.x != 11 && !(sted.y > 2)&& ((b[int(sted.x)+1][int(sted.y)][0] == -1))) break;
                  }
                  if ((tRot+2) % 4 == 0) {
                    if (sted.x != 0 && !(sted.y < 3)&& ((b[int(sted.x)-1][int(sted.y)][0] == -1))) break;
                  }
                }
              }
              //Nu når en brik er blevet placeret opdaterer vi current og før variablerne og skriver blokken ind i griddet.
              if (fuck > 25)break; //Breaker os også ud af dette loop hvis shits fucked
              blokF = blokC;
              rot = rot % 4;
              rotF = rot;
              b[int(sted.x)][int(sted.y)][0] = blokF;
              b[int(sted.x)][int(sted.y)][1] = rotF;
            }
            //Er Banen ikke lukket og "før start" har ikke nogen brik, signalerer vi at vi skal skifte seed og prøve igen
            if (b[int(fStart.x)][int(fStart.y)][0] == -1) b[0][0][0] = -2;

            //Kode til at printe hele arrayet så det ser godt ud i konsollen, både id og rotation
            /*for (int i=0; i<6; i++) {
             for (int j=0; j<12; j++) {
             if (b[j][i][0] != -1)print(" "+b[j][i][0]+" ");
             else print(b[j][i][0]+" ");
             }
             println();
             }
             for (int i=0; i<6; i++) {
             for (int j=0; j<12; j++) {
             print(b[j][i][1]+" ");
             }
             println();
             }*/

            //Vi er done, og banen returneres
            return b;
          }

          //Tegner alle blokkene som beskrevet i bane arrayet
          void DrawBane(int[][][] x, boolean tT, boolean hDb) {
            for (int i=0; i<6; i++) {
              for (int j=0; j<12; j++) {
                pushMatrix();

                //flytter hen til hvor vi skal tegne på griddet
                translate((160*j), (160*i));

                //tilføjer et lille mellemrum hvis vi debugger så man kan skelne mellem blokkene
                if (tT) translate(2*j, 2*i);

                //fikser bug med rotation af tiles
                if (x[j][i][1] == 1) translate(160, 0);
                if (x[j][i][1] == 2) translate(160, 160);
                if (x[j][i][1] == 3) translate(0, 160);

                //Bullshit in a can
                rotate(x[j][i][1]*PI/2f);

                //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
                blok.DrawBlok(x[j][i][0], hDb);
                popMatrix();
              }
            }
          }

          //placerer og roterer startfeltet efter et forudvalgt system, se skemaet "grid startretning.png" i "hjælp til racerprojekt generering" mappen i repositoriet.
          PVector PlacerStart(int[][][] b) {
            //Vælger et tilfældigt sted til starten på banen
            PVector sted = new PVector(int(random(-0.49f, 11.49f)), int(random(-0.49f, 5.49f))); //Enderne ville normalt kunne have en range af 0,5 hvor de kunne blive valgt efter afrunding, derfor går rangen lige under 0,5 udover grænsen.

            //Vektoren sted beskriver hvor vi er på griddet

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

            //Sætter blok id'et på det valgte sted til 0; startblokkens id
            b[int(sted.x)][int(sted.y)][0] = 0;

            //rotering af startbrikken ud fra systemet som beskrevet i en tidligere kommentar
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
