class Car {
  PVector pos, vel, acc, fric, boost, rotation, backVel;
  float theta, thetaVel, thetaAcc, linearVel, linearBackVel;
  int h = 1, cDrej, accelerate;
  boolean ice;

  Car(PVector p, PVector v, PVector a, boolean i, PVector b, float t) {

    pos = p;
    vel = v;
    acc = a;
    ice = i;
    boost = b;
    theta = t;
    thetaVel = 0;
    thetaAcc = 0.00025;

    backVel = new PVector(0, 0);
  }

  void Update(boolean hojre, boolean venstre, boolean op, boolean ned) {

    // cDrej og accelerate sættes lig et tal der bestemmer hvilken vej der drejes, baseret på de booleans der passes fra GameLogic
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
    acc = rotation.mult(0.01);

    Turn(cDrej);
    //Om bilen kører på is eller ej
    if (!ice) {
      Drive(accelerate);
    } else DriveIce(accelerate);

    DrawCar();
  }

  void DrawCar() {
    pushMatrix();
    fill(255, 100, 100);
    translate(pos.x, pos.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0, 0, 60, 30); 
    rectMode(CORNER);
    popMatrix();
  }

  void Turn(int drej) {
    if (thetaVel >= 0.03) thetaVel = 0.03;
    //Bilen drejer, vinkelacceleration og acceleration vikrer på samme måde som med lineær. 
    if (drej == 0) {
      theta += 0;
      thetaVel = 0;
    } else if (drej == 1) {
      thetaVel += thetaAcc;
      theta -= thetaVel;
    } else if (drej == 2) {
      thetaVel += thetaAcc;
      theta += thetaVel;
    }
  }

  void Drive(int koer) {
    linearVel = mag(vel.x, vel.y);
    linearBackVel = mag(backVel.x, backVel.y);

    if (koer == 1) {
      if (linearBackVel > 0.01) Stop(-2);
      else {
        backVel.setMag(0);
        vel.add(acc);
        rotation.normalize();
        rotation.mult(mag(vel.x, vel.y)); //Dette gøres hver gang for at sørge for at hastigheden er samme retning som bilen
        vel = rotation;
        vel.limit(3); //Tophastighed
        pos.add(vel);
        h = 2; //h er 1/-1 baseret på om bilen er i gang med at køre ligeud/bagud - bruges i Stop-metoden
      }
    } else if (koer == 2) { //Når bilen skal bakke
      if (linearVel > 0.01) Stop(5);
      else {
        vel.setMag(0);
        backVel.add(acc);
        rotation.normalize();
        rotation.mult(mag(backVel.x, backVel.y));
        backVel = rotation;
        pos.sub(backVel);
        //linearVel = linearVel*-1;
        h = -2;
        backVel.limit(1.5);
      }
      if (thetaVel >= 0.02) thetaVel = 0.02; //Sørger for at bilen ikke kan dreje ligeså hurtigt rundt når den bakker
    } else Stop(h);
  }

  void DriveIce (int koer) {
    if (koer == 1) {
      vel.add(acc.mult(2));
      vel.limit(3); 
      pos.add(vel); //Forskellen på is vs asfalt er at hastigheden ikke sættes samme retning som bilen - først når accelerationen har "indhentet" den, kan bilen kører dens retning - indtil da glider den
    } else Stop(1);
  }

  void Stop(int h) {
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
}
