import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import processing.sound.*; 
import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RacerSpil extends PApplet {




GameLogic gameLogic;
PImage backdrop;

public void setup() {
  
  frameRate(144);
  gameLogic = new GameLogic(this);
  backdrop = loadImage("Dirt.png");
  
}

public void draw() {
  background(220);

  gameLogic.Update();
}

public void keyPressed() {
  gameLogic.HandleInput(keyCode, true);
}

public void keyReleased() {
  gameLogic.HandleInput(keyCode, false);
} 
class Bane { //<>// //<>//
  int[][][] bane, dBTS;
  Blok blok;
  int bIalt; //Antallet af blokke der er ialt, bruges til at lave debug tilesettet med alle blokkene

  //boost stuff
  int k = 0, boostLimit, currentBoosts = 0; //bruges til at iterere boosts
  float checkForBoost, boostProbability;
  Boolean boosting;
  Boost[] boosts;
  PVector[] boostLocations;
  PVector relativeCarPos = new PVector (0, 0), sted = new PVector(0, 0);
  ;
  int lastStartBox = 0, currentStartBox = 0, lastLastStartBox = 0, medium = 0;
  boolean tick = true;

  Bane(int seed, int maxBoosts, float boostProb) {
    blok = new Blok();
    bIalt = blok.GetBlokIalt();
    dBTS = LavDebugTileSet(bIalt); //Laver debug tilesettet
    boostProbability = boostProb;
    boostLimit = maxBoosts;
    boosts = new Boost[maxBoosts];
    boostLocations = new PVector[maxBoosts];
    NyBane(seed); //genererer banen
  }


  public void Draw(boolean tT, boolean hDb, boolean gfx) {

    pushMatrix();
    translate(0, 120); //flytter alt ned så ui ikke bliver dækket

    //Vælger banen eller debug tilesettet givet tT (tileTest)
    if (!tT)DrawBane(bane, tT, hDb, gfx, boostProbability);
    else DrawBane(dBTS, tT, hDb, gfx, boostProbability);


    popMatrix();
  }

  public int startCollision(int currentRound, boolean r) {

    if (r) {      
      currentStartBox = 0;
      lastStartBox = 1;
      lastLastStartBox = 0;
      return 0;
    }

    /*
    switch (cR) {
     case 0:
     if (bane[int(sted.x)][int(sted.y)][0] == 0) {
     if (relativeCarPos.x < 40) {
     currentStartBox = 0;
     } else if (relativeCarPos.x > 60) {
     currentStartBox = 2;
     } else {
     currentStartBox = 1;
     }
     }
     break;
     case 1:
     if (bane[int(sted.x)][int(sted.y)][0] == 0) {
     if (relativeCarPos.x < 40) {
     currentStartBox = 0;
     } else if (relativeCarPos.x > 60) {
     currentStartBox = 2;
     } else {
     currentStartBox = 1;
     }
     }
     break;
     case 2:
     break;
     case 3:
     break;
     }
     */
    if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0] == 0) {
      PVector tempCarPos = new PVector(relativeCarPos.x, relativeCarPos.y);
      tempCarPos.sub(80, 80);
      tempCarPos.rotate(HALF_PI*bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1]);
      if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] == 1 || bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] == 3) tempCarPos.rotate(PI);
      tempCarPos.add(80, 80);
      if (tempCarPos.x < 40) {
        currentStartBox = 0;
      } else if (tempCarPos.x > 60) {
        currentStartBox = 2;
      } else {
        currentStartBox = 1;
      }
    }
    if (medium != currentStartBox) { 
      lastLastStartBox = lastStartBox;
      lastStartBox = currentStartBox;
      tick = true;
    }
    medium = currentStartBox;

    //println(currentStartBox + " " + lastStartBox + " " + lastLastStartBox);
    if (lastStartBox == 0 && currentStartBox == 0 && lastLastStartBox == 1 && tick) {
      tick = false; 
      return currentRound - 1;
    }
    if (lastStartBox == 2 && currentStartBox == 2 && lastLastStartBox == 1 && tick) {
      tick = false; 
      return currentRound + 1;
    }
    return currentRound;
  }

  public float[] CalculateCollisions(PVector carPos, int carW, int carH, float carRot, boolean hDb) {
    relativeCarPos = new PVector(carPos.x % 160, ((carPos.y-120) % 160));
    sted = new PVector(floor(carPos.x/160), floor((((carPos.y)-120)/160)));
    PVector basisRetning = new PVector(1, 0), b2 = new PVector(0, -1);

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

    if (hDb) {
      for (int i = 0; i<4; i++) {
        pushMatrix();
        translate(0, 120);
        stroke(20);
        line(0, 0, carCorners[i].x+sted.x*160, carCorners[i].y+sted.y*160);
        stroke(20);
        popMatrix();
      }
    }

    for (int i = 0; i<hitBoxes.length; i++) {
      for (int j = 0; j<hitBoxes[i].length; j++) {
        float angle = PVector.angleBetween(basisRetning, carRetning);
        if (carRetning.x < 0) {
          angle = PI-angle;
        }

        int storstX = 0, storstY = 0, mindstX = 0, mindstY = 0;
        float temp1 = carCorners[0].x, temp2 = carCorners[0].x, temp3 = carCorners[0].y, temp4 = carCorners[0].y;
        for (int k = 0; k<4; k++) {
          if (carCorners[k].x > temp1) {
            temp1 = carCorners[k].x;
            storstX = k;
          }
          if (carCorners[k].x < temp2) {
            temp2 = carCorners[k].x;
            mindstX = k;
          }
          if (carCorners[k].y > temp3) {
            temp3 = carCorners[k].y;
            storstY = k;
          }
          if (carCorners[k].y < temp4) {
            temp4 = carCorners[k].y;
            mindstY = k;
          }
        }    

        if (hDb) {
          pushMatrix();
          fill(0, 255, 0);
          translate(0, 120);
          translate(sted.x*160, sted.y*160);
          rect(hitBoxes[i][j][0].x, hitBoxes[i][j][0].y, hitBoxes[i][j][1].x, hitBoxes[i][j][1].y);
          popMatrix();
        }
        for (int s = 0; s<4; s++) {
          int side = 1;

          if (s == storstX) {
            //angle += HALF_PI + PI;
            side = 1;
            angle = HALF_PI - angle;
          }
          if (s == mindstX) {
            side = 3;
            //angle += HALF_PI;
            angle = HALF_PI - angle;
          }
          if (s == storstY) {
            //angle += PI;
            side = 2;
          }
          if (s == mindstY) {
            //angle += HALF_PI + PI;
            side = 0;
            angle = HALF_PI - angle;
          }

          float[] ret = new float[2];
          ret[0] = angle % HALF_PI;
          ret[1] = side;

          //println(degrees(ret[0])); //printer angle

          if (hitBoxes[i][j][1].x < 0) {
            if (hitBoxes[i][j][1].y < 0) {
              if ((carCorners[s].x > hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x < hitBoxes[i][j][0].x) && (carCorners[s].y > hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y < hitBoxes[i][j][0].y)) {
                if (hDb) {
                  println("Collision!");
                  println(i+" "+j);
                  println(degrees(angle));
                  println(millis());
                  fill(0, 0, 255);
                  circle(carPos.x, carPos.y, 45);
                }
                return ret;
              }
            } else {
              if ((carCorners[s].x > hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x < hitBoxes[i][j][0].x) && (carCorners[s].y < hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y > hitBoxes[i][j][0].y)) {
                if (hDb) {
                  println("Collision!");
                  println(i+" "+j);
                  println(degrees(angle));
                  println(millis());
                  fill(255, 255, 100);
                  circle(carPos.x, carPos.y, 50);
                }
                return ret;
              }
            }
          } else {
            if (hitBoxes[i][j][1].y < 0) {
              if ((carCorners[s].x < hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x > hitBoxes[i][j][0].x) && (carCorners[s].y > hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y < hitBoxes[i][j][0].y)) {
                if (hDb) {
                  println("Collision!");
                  println(i+" "+j);
                  println(degrees(angle));
                  println(millis());
                  fill(255, 0, 255);
                  circle(carPos.x, carPos.y, 55);
                }
                return ret;
              }
            } else {
              if ((carCorners[s].x < hitBoxes[i][j][0].x+hitBoxes[i][j][1].x) && (carCorners[s].x > hitBoxes[i][j][0].x) && (carCorners[s].y < hitBoxes[i][j][0].y+hitBoxes[i][j][1].y) && (carCorners[s].y > hitBoxes[i][j][0].y)) {
                if (hDb) {
                  println("Collision!");
                  println(i+" "+j);
                  println(degrees(angle));
                  println(millis());
                  fill(255);
                  circle(carPos.x, carPos.y, 60);
                }
                return ret;
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
    return new float[]{-1f};
  }




  //Genererer en bane givet et seed
  public void NyBane(int seed) {
    //Hvis banen der blev genereret er broken upshifter den seedet med 1 og prøver igen
    while (true) {
      bane = GenererBane(seed, boostProbability);
      if (bane[0][0][0] != -2) break;
      else seed++;
    }
  }

  //Generer banen tilfældigt ved hjælp af et seed
  public int[][][] GenererBane (int seed, float boostProb) {
    currentBoosts = 0;
    randomSeed(seed);

    //initialiserer banen some et 3-dimensionelt array og gør alle blok id'er til -1, så de ikke render hvis de ikke bliver overskrevet.
    int[][][] b = new int [12][6][3];
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
    int rotF = b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1]; //rotation Før, den tidligere briks rotation. Starter med at være startbrikkens rotation
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
        if (b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1] == tRot % 4) {
          blokC = 3;
          rot = b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1];
        }
        if (b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1] == (tRot + 1) % 4) {
          blokC = 1;
          rot = b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1]-1;
          if (rot == -1) rot = 3;
        }
        if (b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1] == (tRot - 1) % 4) {
          blokC = 2;
          rot = b[PApplet.parseInt(start.x)][PApplet.parseInt(start.y)][1]+1;
        }
      } else {
        //Dette while loop forsøger at placere blokke på det 'sted' vi er nået hen til
        while (true) {
          fuck++;
          if (fuck > 25)break; //Har vi prøvet og fejlet at placere blokke så mange gange, then shits fucked og vi daffer
          blokC = PApplet.parseInt(random(1, bIalt)); //Current blok, tilfældigt valgt ud fra alle blokke undtagen start
          rot = rotF+blok.GetBI(blokF, 3); //beregner denne bloks rotation ud fra den tidligere bloks
          tRot = rot+blok.GetBI(blokC, 3); //beregner hvor denne blok nu faktisk peger

          //Første lag if statements bestemmer hvilken vej blokken faktisk peger.
          //Andet lag bestemmet om blokken er inde i en zone hvor den ikke må være (ud fra hvor den peger), og om den peger på en tom plads
          //Zonerne er grafisk beskrevet via billeddet "grid zoner.png" i "hjælp til racerprojekt generering" mappen i repositoriet.
          if ((tRot+1) % 4 == 0) {
            if (sted.y != 0 && !(sted.y == 3 && sted.x > 1) && !(sted.x > 9 && sted.y < 3) && ((b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)-1][0] == -1))) break;
          }
          if ((tRot-1) % 4 == 0) {
            if (sted.y != 5 && !(sted.y == 2 && sted.x < 10) && !(sted.x < 2 && sted.y > 1)&& ((b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)+1][0] == -1))) break;
          }
          if (tRot % 4 == 0) {
            if (sted.x != 11 && !(sted.y > 2)&& ((b[PApplet.parseInt(sted.x)+1][PApplet.parseInt(sted.y)][0] == -1))) break;
          }
          if ((tRot+2) % 4 == 0) {
            if (sted.x != 0 && !(sted.y < 3)&& ((b[PApplet.parseInt(sted.x)-1][PApplet.parseInt(sted.y)][0] == -1))) break;
          }
        }
      }
      //Nu når en brik er blevet placeret opdaterer vi current og før variablerne og skriver blokken ind i griddet.
      if (fuck > 25)break; //Breaker os også ud af dette loop hvis shits fucked
      blokF = blokC;
      rot = rot % 4;
      rotF = rot;
      b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0] = blokF;
      b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = rotF;

      //Der tjekkes, om der skal laves et boost i denne blok
      checkForBoost = random(0, 1);
      //println("Probability: "+boostProbability+" || Booost check: "+checkForBoost+" || Current boosts: "+currentBoosts + "|| Boost limit: "+boostLimit);
      if (boostProbability >= checkForBoost && currentBoosts < boostLimit) {
        b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][2] = 1;
        boostLocations[currentBoosts] = new PVector(80, 80);
        boosts[currentBoosts] = new Boost(boostLocations[currentBoosts]);
        currentBoosts++;
        //println("Probability: "+boostProbability+" || Booost check: "+checkForBoost+" || Current boosts: "+currentBoosts);
      }
    }
    //Er Banen ikke lukket og "før start" har ikke nogen brik, signalerer vi at vi skal skifte seed og prøve igen
    if (b[PApplet.parseInt(fStart.x)][PApplet.parseInt(fStart.y)][0] == -1) b[0][0][0] = -2;

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
     }
     for (int i=0; i<6; i++) {
     for (int j=0; j<12; j++) {
     if (b[j][i][2] != -1)print(" "+b[j][i][2]+" ");
     else print(b[j][i][2]+" ");
     }
     println();
     }*/
    //Vi er done, og banen returneres
    return b;
  }

  //Tegner alle blokkene som beskrevet i bane arrayet

  public void DrawBane(int[][][] x, boolean tT, boolean hDb, boolean gfx, float boostProbability) {
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

        blok.DrawBlok(x[j][i][0], hDb, gfx, boostProbability);

        if (!tT && k<currentBoosts && x [j][i][2]==1) {
          boosts[k].DrawBoost();
          k++;
        }

        popMatrix();
      }
    }
    k = 0;
  }

  //placerer og roterer startfeltet efter et forudvalgt system, se skemaet "grid startretning.png" i "hjælp til racerprojekt generering" mappen i repositoriet.
  public PVector PlacerStart(int[][][] b) {
    //Vælger et tilfældigt sted til starten på banen
    PVector sted = new PVector(PApplet.parseInt(random(-0.49f, 11.49f)), PApplet.parseInt(random(-0.49f, 5.49f))); //Enderne ville normalt kunne have en range af 0,5 hvor de kunne blive valgt efter afrunding, derfor går rangen lige under 0,5 udover grænsen.

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
    b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0] = 0;

    //rotering af startbrikken ud fra systemet som beskrevet i en tidligere kommentar
    if (sted.x != 0 && sted.x != 11) {
      if (sted.y == 2 || sted.y == 3) {
        if (sted.x == 1) b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 3;
        else if (sted.x == 10) b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 1;
        else if (sted.y > 2) b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 2;
      } else if (sted.y > 2) b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 2;
    } else {
      if (sted.x == 0) b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 3;
      else b[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1] = 1;
    }
    return sted;
  }


  //Tager alle blokke fra blok klassen og lægger dem ind i en bane én efter hindanden, er lavet til at man nemt kan tjekke hvordan hver blok ser ud ved at trykke t.
  public int[][][] LavDebugTileSet(int bIalt) {
    int[][][] a = new int [12][6][3];
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

  public int[] whereStart() {
    for (int i=0; i<6; i++) {
      for (int j=0; j<12; j++) {
        if (bane[j][i][0] == 0) {
          return new int[] {j, i, bane[j][i][1]};
        }
      }
    }
    return new int[0];
  }

  public boolean checkBoostCollisions() {
    for (int i = 0; i < currentBoosts; i++) {
      if (boosts[i].CheckCollision(relativeCarPos) && bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][2] == 1) return true;
    }
    return false;
  }
}
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
  public int GetBI(int id, int a) {
    return blokInfo[id][a];
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  //Vælger hvilken blok draw metode der skal bruges ud fra blok id'et
  public void DrawBlok(int id, boolean hDb, Boolean gfx, float boostProb) {
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

  public int GetBlokIalt() {
    return blokkeIalt;
  }

  //returnerer alle hitboxes der kunne skære bilen, med deres relative shift
  public PVector[][][] GetHitboxes(PVector sted, int[][][] bane) {
    int felter = 5;
    if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0] == -1) felter--;
    if (sted.x == 0)felter--;
    else if (bane[PApplet.parseInt(sted.x)-1][PApplet.parseInt(sted.y)][0] == -1) felter--;
    if (sted.x == 11)felter--;
    else if (bane[PApplet.parseInt(sted.x)+1][PApplet.parseInt(sted.y)][0] == -1) felter--;
    if (sted.y == 0)felter--;
    else if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)-1][0] == -1) felter--;
    if (sted.y == 5) felter--;
    else if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)+1][0] == -1) felter--;
    PVector[][][] x = new PVector[felter][][];
    int next = 0;

    if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0] != -1) {
      x[next] = GetBlokHitboxes(bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][0], new PVector(0, 0), bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)][1]);
      next++;
    }

    if (sted.x != 0) {
      if (bane[PApplet.parseInt(sted.x)-1][PApplet.parseInt(sted.y)][0] != -1) {
        x[next] = GetBlokHitboxes(bane[PApplet.parseInt(sted.x)-1][PApplet.parseInt(sted.y)][0], new PVector(-1, 0), bane[PApplet.parseInt(sted.x)-1][PApplet.parseInt(sted.y)][1]);
        next++;
      }
    }
    if (sted.x != 11) {
      if (bane[PApplet.parseInt(sted.x)+1][PApplet.parseInt(sted.y)][0] != -1) {
        x[next] = GetBlokHitboxes(bane[PApplet.parseInt(sted.x)+1][PApplet.parseInt(sted.y)][0], new PVector(1, 0), bane[PApplet.parseInt(sted.x)+1][PApplet.parseInt(sted.y)][1]);

        next++;
      }
    }
    if (sted.y != 0) {
      if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)-1][0] != -1) {
        x[next] = GetBlokHitboxes(bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)-1][0], new PVector(0, -1), bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)-1][1]);
        next++;
      }
    }
    if (sted.y != 5) {
      if (bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)+1][0] != -1) {
        x[next] = GetBlokHitboxes(bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)+1][0], new PVector(0, 1), bane[PApplet.parseInt(sted.x)][PApplet.parseInt(sted.y)+1][1]);
        next++;
      }
    }
    return x;
  }

  //returnerer alle hitboxes fra blokken med relativt shift i forhold til blokken bilen er i
  public PVector[][] GetBlokHitboxes(int id, PVector shift, int blokRot) {
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
  public PVector[][] BoxesB0(int blokRot) {
    PVector[][] boxes = new PVector[2][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(160, 20);

    boxes[1][0] = new PVector(0, 140);
    boxes[1][1] = new PVector(160, 20);

    return boxes;
  }

  //højresvingsblok hitboxes
  public PVector[][] BoxesB1(int blokRot) {
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
  public PVector[][] BoxesB2(int blokRot) {
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
  public PVector[][] BoxesB3(int blokRot) {
    PVector[][] boxes = new PVector[2][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(160, 20);

    boxes[1][0] = new PVector(0, 140);
    boxes[1][1] = new PVector(160, 20);

    return boxes;
  }


  //Initialiserer alle blokkenes info i et info array
  public void InitialiserInfo() {
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
  public void DrawB0(boolean gfx) {
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
  public void DrawB1(boolean gfx, float boostProb) {
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
  public void DrawB2(boolean gfx, float boostProb) {
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
  public void DrawB3(boolean gfx, float boostProb) {
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
  public void DrawOldB0() {
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
  public void DrawOldB1() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 20, 120, 140);
    rect(0, 20, 20, 120);
  }

  //Venstresving blok Draw
  public void DrawOldB2() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(20, 0, 120, 140);
    rect(0, 20, 20, 120);
  }

  //Ligeud blok Draw
  public void DrawOldB3() {
    fill(20);
    noStroke();
    rect(0, 0, 160, 160);
    fill(255);
    rect(0, 20, 160, 120);
  }
}
class Boost {

  PVector location;
  Boolean boosting = false;
  int w = 50, h = 50;
  
  //constructer
  Boost(PVector boostLocation) {
    location = boostLocation;

  }
  
  public void DrawBoost(){
    fill(252,186,3);
    rectMode(CENTER);
    rect(location.x,location.y,50,50);
    fill(255,0,0);
    rectMode(CORNER);
    noStroke();
    rect(77.5f,77.5f, 5,5);
    triangle(85,60, 67.5f,82.5f, 77.5f,82.5f);
    triangle(82.5f,77.5f, 92.5f,77.5f, 77.5f,102.5f);
    stroke(20);
  }
  
  public boolean CheckCollision(PVector carPos){
    if((carPos.x+5 > location.x-w/2f) && (carPos.x-5 < location.x+w/2f) && (carPos.y+5 > location.y-h/2f) && (carPos.y-5 < location.y+h/2f)) return true;    
    return false;
  }
}
class Car { //<>// //<>// //<>// //<>//
  PVector pos, vel, acc, rotation, backVel, endOfCar, carRetning = new PVector(0, 0);

  float thetaVel, thetaAcc, linearVel, linearBackVel, theta, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, h = 1, collisionTurnRate = 0.02f, collisionSpeedLoss = 0.30f;
  int cDrej, accelerate, carWidth, carHeight, collisionPush = 1;
  boolean ice, playSpeedUp = true, playBoostSFX = true, playHitSFX = true;


  PImage carSprite;
  ParticleSystem ps;
  SoundFile speedUp, boostSFX, hitSFX;


  Car(PVector p, boolean i, float sr, float mv, float mbv, float sv, float bv, float mtv, float mtbv, float a, float ta, int carW, int carH) {

    vel = new PVector (0, 0);
    backVel = new PVector(0, 0);
    thetaVel = 0;
    acc = new PVector (0, 0);

    pos = p;
    ice = i;
    theta = sr;
    maxVel = mv;
    maxBackVel = mbv;
    stopVel = sv;
    bremseVel = bv;
    maxThetaVel = mtv;
    maxThetaBackVel = mtbv;
    acceleration = a;
    thetaAcc = ta;
    carWidth = carW;
    carHeight = carH;

    carSprite = loadImage("car.png");
    ps = new ParticleSystem(pos);
    speedUp = new SoundFile(RacerSpil.this, "speedUp.mp3");
    boostSFX = new SoundFile(RacerSpil.this, "boost.mp3");
    hitSFX = new SoundFile(RacerSpil.this, "jembayHit.wav");
  }

  public void Update(boolean hojre, boolean venstre, boolean op, boolean ned, boolean givBoost, boolean hDb, boolean round) {
    carRetning = new PVector(carWidth/2f, 0);
    carRetning.rotate(theta+HALF_PI);
    if (round) {
      // Styrer controls
      if ((hojre && venstre)||(!hojre && !venstre)) {
        cDrej = 0;
      } else if (hojre) {
        cDrej = 2;
      } else {
        cDrej = 1;
      }
      if (op) {
        accelerate = 1;
      } else if (ned) {
        accelerate = 2;
      } else if (!op) {
        accelerate = 0;
      } 

      //Sørger for at accelerationen vender i bilens retning
      rotation = new PVector(cos(theta), sin(theta));
      acc = rotation.mult(acceleration);

      Turn(cDrej);

      linearVel = mag(vel.x, vel.y); //Udregner den linæer hastighed og bakke hastighed
      linearBackVel = mag(backVel.x, backVel.y);
      Particles(linearVel, theta, givBoost);

      if (linearVel > 0) speedUp.amp(linearVel/100);
      if (linearBackVel > 0) speedUp.amp(linearBackVel/200);
      if (playSpeedUp) speedUp.play();
      if (speedUp.isPlaying()) playSpeedUp = false;
      else playSpeedUp = true;

      if (!ice) { //Om bilen kører på is eller ej
        Drive(accelerate, givBoost);
      } else DriveIce(accelerate);
    }
    if (hDb)DrawCarHitbox();
    else DrawCar();
  }

  public void placeCar(PVector nyPos, int rot) {
    if (rot == 2) nyPos.add(83, 0);
    if (rot != 2 && rot != 0) {
      if (rot == 1) { 
        nyPos.add(40, -45);
      } else { 
        nyPos.add(40, 45);
      }
    }
    pos.x = nyPos.x;
    pos.y = nyPos.y;
    vel.mult(0);
    backVel.mult(0);
    theta = rot*HALF_PI;
    acc = new PVector (0, 0);
    thetaVel = 0;

    speedUp.stop();
  }

  public void Hit(float[] ret, boolean tT, boolean boost) {
    //println(carRetning.y > 0);
    //println(carRetning.x > 0);
    //println(vel.mag());
    if (ret[0] != -1 && !tT) {
      vel.mult(1-collisionSpeedLoss);
      backVel.mult(1-collisionSpeedLoss);
      //println(carRetning.y > 0);
      //println(carRetning.x > 0);
      //println(ret[1]);
      int cP;
      if (vel.mag() > 5 || boost) cP = collisionPush*15;
      else cP = collisionPush;

      hitSFX.amp(0.2f);
      if (playHitSFX && linearVel > 1.25f || playHitSFX && linearBackVel > 1.25f) hitSFX.play();
      if (hitSFX.isPlaying()) playHitSFX = false;
      else playHitSFX = true;

      if (carRetning.y > 0) {
        switch (PApplet.parseInt(ret[1])) {
        case 0:
          pos.y += cP;
          if (carRetning.x > 0)theta += collisionTurnRate;
          else theta -= collisionTurnRate;
          break;
        case 1:
          pos.x -= cP;
          if (carRetning.x > 0)theta -= collisionTurnRate;
          else theta += collisionTurnRate;
          break;
        case 2:
          pos.y -= cP;
          if (carRetning.x > 0)theta += collisionTurnRate;
          else theta -= collisionTurnRate;
          break;
        case 3:
          pos.x += cP;
          if (carRetning.x > 0) theta -= collisionTurnRate;
          else theta += collisionTurnRate;
          break;
        }
      } else {

        switch (PApplet.parseInt(ret[1])) {
        case 0:
          pos.y += cP;
          if (carRetning.x > 0)theta -= collisionTurnRate;
          else theta += collisionTurnRate;
          break;
        case 1:
          pos.x -= cP;
          if (carRetning.x > 0)theta += collisionTurnRate;
          else theta -= collisionTurnRate;
          break;
        case 2:
          pos.y -= cP;
          if (carRetning.x > 0)theta -= collisionTurnRate;
          else theta += collisionTurnRate;
          break;
        case 3:
          pos.x += cP;
          if (carRetning.x > 0)theta += collisionTurnRate;
          else theta -= collisionTurnRate;
          break;
        }
      }
    }
  }

  public void DrawCar() {
    pushMatrix();
    fill(255, 100, 100);
    translate(pos.x, pos.y);
    rotate(theta);
    imageMode(CENTER);
    image(carSprite, 0, 0, carWidth+5, carHeight+5);
    rectMode(CORNER);
    popMatrix();
  }

  public void DrawCarHitbox() {
    pushMatrix();
    fill(255, 100, 100);
    translate(pos.x, pos.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0, 0, carWidth, carHeight); 
    rectMode(CORNER);
    popMatrix();
  }



  public void Turn(int drej) {
    if (thetaVel >= maxThetaVel) thetaVel = maxThetaVel; //Sørger for at bilen ikke drejer for hurtigt
    if (linearVel == 0 || linearBackVel == 0) thetaVel = 0;

    if (drej == 0) {
      theta += 0;
      thetaVel = 0;
    } else if (drej == 1) {
      thetaVel += thetaAcc * (linearVel + linearBackVel);
      theta -= thetaVel;
    } else if (drej == 2) {
      thetaVel += thetaAcc* (linearVel + linearBackVel);
      theta += thetaVel;
    }
  }



  public void Drive(int koer, boolean boost) {

    if (boost) { 
      maxVel = 10; //sætter maks hastigheden til et højere tal
      if (linearVel <= 2) vel.setMag(2); //Sørger for et boost selvom der køres langsomt
      vel.mult(1.15f);

      speedUp.stop();
      speedUp.amp(0.2f);
      boostSFX.amp(0.5f);
      if (playBoostSFX) boostSFX.play();
      if (boostSFX.isPlaying()) playBoostSFX = false;
      else playBoostSFX = true;
    } else {
      maxVel = constrain(maxVel, 4, 10); 
      maxVel = maxVel - 0.05f; //maks hastigheden falder ligeså langsomt til den normalle makshastighed efter boostet
    }

    vel.limit(maxVel);

    if (koer == 1) {
      if (linearBackVel > 0.02f) Stop(-stopVel); //Sørger for at man ikke kan køre ligeud når der bakkes
      else {
        backVel.setMag(0);
        vel.add(acc);
        rotation.normalize();
        rotation.mult(mag(vel.x, vel.y)); //Hastigheden vendes i bilens retning
        vel = rotation;
        pos.add(vel);
        h = stopVel; //h er negativt/positivt baseret på om man stopper efter et brems eller at køre ligeud
      }
    } else if (koer == 2) { //Når bilen skal bakke, alt logik er ens bortset fra at 
      if (linearVel > 0.02f) Stop(bremseVel);
      else {
        vel.setMag(0);
        backVel.add(acc);
        rotation.normalize();
        rotation.mult(mag(backVel.x, backVel.y));
        backVel = rotation;
        pos.sub(backVel);
        h = -stopVel;
        backVel.limit(maxBackVel);
      }
      if (thetaVel >= maxThetaBackVel) thetaVel = maxThetaBackVel; //Sørger for at bilen ikke kan dreje ligeså hurtigt rundt når den bakker
    } else Stop(h);
  }



  public void DriveIce (int koer) {
    if (koer == 1) {
      vel.add(acc.mult(2));
      vel.limit(3); 
      pos.add(vel); //Forskellen på is vs asfalt er at hastigheden ikke sættes samme retning som bilen - først når accelerationen har "indhentet" den, kan bilen kører dens retning - indtil da glider den
    } else Stop(1);
  }



  public void Stop(float h) {
    // virker på samme måde som når bilen speeder op, bare med sub istedet for add
    if (h > 0) {
      vel.sub(acc.mult(h));
      rotation.normalize();
      rotation.mult(mag(vel.x, vel.y));
      vel = rotation;
      pos.add(vel);
    }
    if (h < 0) {
      backVel.sub(acc.mult(h));
      rotation.normalize();
      rotation.mult(mag(backVel.x, backVel.y));
      backVel = rotation;
      pos.add(backVel);
    }
  } 

  public PVector GetPos() {
    return pos;
  }

  public float GetRot() {
    return theta;
  }

//Laver partiklerne
  public void Particles(float s, float t, boolean which) { //Laver partikelsystemet
    ps.addParticle(s, t, which);
    ps.run(pos);
  }
}
class GameLogic { //<>//

  Bane bane;
  int mSec, collisionTime, baneDrawTime, miscTime, waitTime = 2500, waitTimer = 0;

  boolean hojre=false, venstre=false, op=false, ned=false, r=false, t=false, tF=false, space=false, tab=false, tabF=false, enter=false, h = false, hF = false, g = false, gF = false; //kun til taster
  boolean ice = false, givBoost = false, tileTest = false, menu = false, hitboxDebug = false, coolGraphics; //til andre bools

  boolean[] toggleTemp; 
  PVector start;

  //Til runde counter
  int currentRound = 0, TotalRounds = 3;

  //Til time counter
  int record, raceTime = 0, raceTimeStart;
  boolean raceStart = false, racing = false;

  //ting til bilen
  PVector carPos = new PVector(width/2, height/2), carBoost = new PVector(0, 0), currentCarPos;
  float startRotation = 0, maxVel = 3, maxBackVel = 1.5f, stopVel = 1, bremseVel = 5, maxThetaVel = 0.02f, maxThetaBackVel = 0.02f, acceleration = 0.01f, thetaAcc = 0.014f;
  int carWidth = 55, carHeight = 25;
  Car car;

  //Til boosts
  float boostProbability = 0.05f;
  int maxBoosts = 3;

  //Ting til seed og menu
  int seed = PApplet.parseInt(random(0, 9999));
  int seedOld = seed;
  Menu gameMenu;

  GameLogic(PApplet thePApplet) {
    car = new Car(carPos, ice, startRotation, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, thetaAcc, carWidth, carHeight);

    gameMenu = new Menu(thePApplet, seed);
    bane = new Bane(seed, maxBoosts, boostProbability);
    ordenBil();
  }

  public void Update() {
    miscTime = millis();

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

    //gør at man kan toggle grafik med g
    toggleTemp = toggle(g, gF, coolGraphics);
    coolGraphics = toggleTemp[0];
    gF = toggleTemp[1];


    baneDrawTime = millis();
    bane.Draw(tileTest, hitboxDebug, coolGraphics);
    //println("BaneDrawTime: "+(millis()-baneDrawTime)); //print time it takes to draw bane

    collisionTime = millis();
    car.Hit(bane.CalculateCollisions(car.GetPos(), carWidth, carHeight, car.GetRot(), hitboxDebug), tileTest, givBoost);
    //println("collision time: "+millis()-collisionTime); //printer tiden det tog a lave collision detection



    //println(1/((millis()-mSec)/1000f)); //printer framerate
    //println("Frametime: "+(millis()-mSec)); //printer frametime
    mSec = millis();

    car.Update(hojre, venstre, op, ned, bane.checkBoostCollisions(), hitboxDebug, racing);



    handleTimer();
    DrawUI();

    if (menu) gameMenu.Update(space);
    if (enter) seed = PApplet.parseInt(gameMenu.textField.input());

    currentCarPos = car.GetPos(); //til når der skal tjekkes kollision med bilen 

    DrawUI();
    if (tileTest) bane.Draw(tileTest, hitboxDebug, coolGraphics);

    //println("MiscTime: "+(millis()-miscTime));
  }

  public void DrawUI() {
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
    textSize(17);
    text("Current seed: "+seed, 1335, 70);
  }

  //sørger for at controls virker
  public void HandleInput(int k, boolean b) {

    if (k == 39) hojre = b;
    if (k == 37) venstre = b;
    if (k == 38) op = b;
    if (k == 40) ned = b;
    if (k == 82) r = b;
    if (k == 84) t = b;
    if (k == 32) space = b; //Kun et random seed per tryk
    if (k == 9) tab = b;
    if (k == 10) enter = b;
    if (k == 66) givBoost = b;
    if (k == 72) h = b;
    if (k == 71) g = b;
  }

  //a bit of stuff for the timer and logic for handling record time when starting a race
  public void handleTimer() {
    if (raceStart) {
      racing = true;
      raceTime = 0;
      raceTimeStart = millis();
      raceStart = false;
    }
    //måler tiden fra starten af race
    if (racing) {
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
  public void DrawTime(int recordTime, int time) {
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
  public boolean[] toggle(boolean x, boolean xF, boolean v) {

    if (x && !xF) {
      xF = x;
      v = !v;
    }
    if (xF && !x) xF = x;
    boolean[] a = {v, xF};
    return a;
  }

  public void ordenBil() {
    int[] tt = bane.whereStart();
    car.placeCar(new PVector(tt[0]*160+40, tt[1]*160+200), tt[2]);
  }
}
class Menu {
  TextField textField;
  String enteredSeed;
  int seed, newSeedDecider;

  Menu(PApplet thePApplet, int s) {
    seed = s;
    textField = new TextField(thePApplet, seed);
  }

  public void Update(boolean newSeed) {
    Draw();
    if (newSeed) newSeedDecider = 0;
    newSeedDecider += 1;
    if (newSeedDecider >= 2) seed = PApplet.parseInt(random(0, 9999)); //Sørger for et enkelt nyt seed per gang der trykkes mellemrum
    textField.Update(seed, newSeed);
  }

  public void Draw() {
    fill(180, 200, 220);
    rect(700, 300, 580, 600, 10);

    fill(0, 0, 0);
    textSize(50);
    text("RACING GAME 9001", 745, 370);

    textSize(25);
    text("Enter seed here", 890, 435);

    textSize(20);
    fill(125, 125, 125);
    text("Space to generate new seed", 850, 522);

    textSize(25);
    fill(0, 0, 0);
    rect(730, 590, 520, 1);
    text("Controls", 933, 580);
    textSize(20);
    text("←↑↓→ to steer", 910, 630);
    text("R to reset", 935, 670);
    text("TAB to toggle menu", 890, 710);
    text("P to toggle particles", 891, 750);
    text("Mute system audio to toggle sound", 825, 790);
    text("ESC or Alt+F4 to close game", 855, 830);
  }
}
class Particle {
  PVector location, velocity, acceleration, currentVelocity;
  float lifespan, theta, limit;

  Particle(PVector origin, float s, float t, float l) {
    acceleration = new PVector(-0.01f, -0.01f);
    location = origin.get();
    velocity = new PVector(random(-3, -1), random(-1, 1));
    lifespan = 16 * s;
    theta = t;
    limit = l;
  }

  public void run() {
    update();
    display();
  }

  public void update() {
    if (lifespan >= limit) lifespan = limit - 0.1f;
    velocity.add(acceleration);
    currentVelocity = new PVector(velocity.x * cos(theta), velocity.y * sin(theta));
    location.add(currentVelocity);
    lifespan -= 2.0f;
  }

  public void display() {
    stroke(0, lifespan);
    fill(random(110, 130), random(110, 130), random(110, 130), lifespan);
    ellipse(location.x, location.y, 15 + random(-5, 5), 15 + random(-5, 5));
    stroke(0);
  }

  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}
class ParticleBoost extends Particle {

  ParticleBoost(PVector p, float s, float t, float l) {
    super(p, s*2, t, l);
    lifespan = 32 * s;
  }

  public void display() {
    float theta = map(location.x, 0, width, 0, TWO_PI*20);

    rectMode(CENTER);
    fill(random(50, 255), random(50, 255), random(50, 255), lifespan);
    stroke(0, lifespan);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    rect(0, 0, 16, 16);
    popMatrix();
  }
}


class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;


  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  public void addParticle(float strength, float theta, boolean particleBoost) {
    if (!particleBoost) particles.add(new Particle(origin, strength, theta + random(-1.5f, 1.5f), 65)); //Spørger om der skal laves normalle eller boostpartikler. Boostpartiklerne får et større limit på 200, så de kan ses i længere tid
    if (particleBoost) particles.add(new ParticleBoost(origin, strength, theta + random(-1.5f, 1.5f), 150));
  }

  public void run(PVector location) {
    origin = location.get();
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove(); //Fjerne den 'døde' partikel fra arraylisten
      }
    }
  }
}
class TextField {
  ControlP5 cp5;
  String enteredSeed, seedTextfield, seedTextfieldOld;
  int firstSeed, textFieldCount;
  Textfield textfield;

  //konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
  //PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  TextField(PApplet thePApplet, int fs) {
    textFieldCount = 0;
    seedTextfield = "SeedTextField";
    firstSeed = fs;
    enteredSeed = str(firstSeed);
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    textfield = cp5.addTextfield("SeedTextField").setPosition(730, 450).setSize(520, 50).setAutoClear(false).setInputFilter(1).setText(str(firstSeed)).setCaptionLabel("").keepFocus(true);
  }

  public void Update(int seed, boolean newRandomSeed) {
    Draw();
    firstSeed = seed;
    if (newRandomSeed) {
      if (textFieldCount == 0) {
        cp5.remove("SeedTextField");
      }
      else {
        cp5.remove(seedTextfield);
      }
      textFieldCount += 1;
      seedTextfield = "SeedTextField" + str(textFieldCount);
      seedTextfieldOld = seedTextfield;

      textfield = cp5.addTextfield(seedTextfieldOld).setPosition(730, 450).setSize(520, 50).setAutoClear(false).setInputFilter(1).setText(str(firstSeed)).setCaptionLabel("").keepFocus(true);
      //cp5.get(Textfield.class, "SeedTextField").setVisible(false);
      //cp5.remove("SeedTextField");
    }
    seedTextfieldOld = null;
    enteredSeed = str(seed);
    enteredSeed = cp5.get(Textfield.class, seedTextfield).getText();
  }

  public void Draw() {
    cp5.draw();
  }  

  //metode til at returnere input. Input skæres af ved 9 cifre, så værdien ikke bliver for stor for en int
  public String input() {
    if (enteredSeed.length()<10) return enteredSeed;
    else if (enteredSeed.length() > 10) {
      return enteredSeed.substring(0, 9);
    } else return enteredSeed;
  }
}
  public void settings() {  size(1920, 1080);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RacerSpil" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
