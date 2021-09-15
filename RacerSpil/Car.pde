class Car {
  PVector pos, vel, acc, rotation, backVel;
  float thetaVel, thetaAcc, linearVel, linearBackVel, theta, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, h = 1;
  int cDrej, accelerate, carWidth, carHeight;
  boolean ice;

  Car(PVector p, boolean i, float sr, float mv, float mbv, float sv, float bv, float mtv, float mtbv, float a, int cw, int ch) {

    vel = new PVector (0, 0);
    backVel = new PVector(0, 0);
    acc = new PVector (0, 0);
    thetaVel = 0;
    thetaAcc = 0.00025;

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
    carWidth = cw;
    carHeight = ch;
  }

  void Update(boolean hojre, boolean venstre, boolean op, boolean ned) {

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
    rect(0, 0, carWidth, carHeight); 
    rectMode(CORNER);
    popMatrix();
  }

  void Turn(int drej) {
    if (thetaVel >= maxThetaVel) thetaVel = maxThetaVel;
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
      if (linearBackVel > 0.02) Stop(-stopVel);
      else {
        backVel.setMag(0);
        vel.add(acc);
        rotation.normalize();
        rotation.mult(mag(vel.x, vel.y)); //Dette gøres hver gang for at sørge for at hastigheden er samme retning som bilen
        vel = rotation;
        vel.limit(maxVel); //Tophastighed
        pos.add(vel);
        h = stopVel; //h er 1/-1 baseret på om bilen er i gang med at køre ligeud/bagud - bruges i Stop-metoden
      }
    } else if (koer == 2) { //Når bilen skal bakke
      if (linearVel > 0.02) Stop(bremseVel);
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

  void DriveIce (int koer) {
    if (koer == 1) {
      vel.add(acc.mult(2));
      vel.limit(3); 
      pos.add(vel); //Forskellen på is vs asfalt er at hastigheden ikke sættes samme retning som bilen - først når accelerationen har "indhentet" den, kan bilen kører dens retning - indtil da glider den
    } else Stop(1);
  }

  void Stop(float h) {
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

  PVector Hit() {
    return pos;
  }
}
