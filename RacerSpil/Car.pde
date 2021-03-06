class Car { //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
    // I am a sneak comment. I sneaked in your code. Sat on your processor. Ate your interrupt handler. Dispatched an ip packet to your mother.
  }

  void Update(boolean hojre, boolean venstre, boolean op, boolean ned, boolean givBoost, boolean hDb, boolean round, boolean cantStart) {
    carRetning = new PVector(carWidth/2f, 0);
    carRetning.rotate(theta+HALF_PI);
    
      if (round && !cantStart) {
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

        //S??rger for at accelerationen vender i bilens retning
        rotation = new PVector(cos(theta), sin(theta));
        acc = rotation.mult(acceleration);

        Turn(cDrej);

        linearVel = mag(vel.x, vel.y); //Udregner den lin??er hastighed og bakke hastighed
        linearBackVel = mag(backVel.x, backVel.y);
        Particles(linearVel, theta, givBoost);

        if (linearVel > 0) speedUp.amp(linearVel/100);
        if (linearBackVel > 0) speedUp.amp(linearBackVel/200);
        if (playSpeedUp) speedUp.play();
        if (speedUp.isPlaying()) playSpeedUp = false;
        else playSpeedUp = true;

        if (!ice) { //Om bilen k??rer p?? is eller ej
          Drive(accelerate, givBoost);
        } else DriveIce(accelerate);
      }
      if (hDb)DrawCarHitbox();
      else DrawCar();
  }

  void placeCar(PVector nyPos, int rot) {
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

  int Hit(float[] ret, boolean tT, boolean boost) {
    //println(carRetning.y > 0);
    //println(carRetning.x > 0);
    //println(vel.mag());
    if (ret[0] == 69420) {
      placeCar(new PVector(500,500),0);
      return -1;
    }
    if (ret[0] != -1 && !tT) {
      vel.mult(1-collisionSpeedLoss);
      backVel.mult(1-collisionSpeedLoss);
      //println(carRetning.y > 0);
      //println(carRetning.x > 0);
      //println(ret[1]);
      int cP;
      if (vel.mag() > 5 || boost) cP = collisionPush*15;
      else cP = collisionPush;

      hitSFX.amp(0.2);
      if (playHitSFX && linearVel > 1.25 || playHitSFX && linearBackVel > 1.25) hitSFX.play();
      if (hitSFX.isPlaying()) playHitSFX = false;
      else playHitSFX = true;

      if (carRetning.y > 0) {
        switch (int(ret[1])) {
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

        switch (int(ret[1])) {
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
    return 0;
  }

  void DrawCar() {
    pushMatrix();
    fill(255, 100, 100);
    translate(pos.x, pos.y);
    rotate(theta);
    imageMode(CENTER);
    image(carSprite, 0, 0, carWidth+5, carHeight+5);
    rectMode(CORNER);
    popMatrix();
  }

  void DrawCarHitbox() {
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
    if (thetaVel >= maxThetaVel) thetaVel = maxThetaVel; //S??rger for at bilen ikke drejer for hurtigt
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



  void Drive(int koer, boolean boost) {

    if (boost) { 
      maxVel = 10; //s??tter maks hastigheden til et h??jere tal
      if (linearVel <= 2) vel.setMag(2); //S??rger for et boost selvom der k??res langsomt
      vel.mult(1.15);

      speedUp.stop();
      speedUp.amp(0.2);
      boostSFX.amp(0.5);
      if (playBoostSFX) boostSFX.play();
      if (boostSFX.isPlaying()) playBoostSFX = false;
      else playBoostSFX = true;
    } else {
      maxVel = constrain(maxVel, 4, 10); 
      maxVel = maxVel - 0.05; //maks hastigheden falder liges?? langsomt til den normalle makshastighed efter boostet
    }

    vel.limit(maxVel);

    if (koer == 1) {
      if (linearBackVel > 0.02) Stop(-stopVel); //S??rger for at man ikke kan k??re ligeud n??r der bakkes
      else {
        backVel.setMag(0);
        vel.add(acc);
        rotation.normalize();
        rotation.mult(mag(vel.x, vel.y)); //Hastigheden vendes i bilens retning
        vel = rotation;
        pos.add(vel);
        h = stopVel; //h er negativt/positivt baseret p?? om man stopper efter et brems eller at k??re ligeud
      }
    } else if (koer == 2) { //N??r bilen skal bakke, alt logik er ens bortset fra at 
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
      if (thetaVel >= maxThetaBackVel) thetaVel = maxThetaBackVel; //S??rger for at bilen ikke kan dreje liges?? hurtigt rundt n??r den bakker
    } else Stop(h);
  }



  void DriveIce (int koer) {
    if (koer == 1) {
      vel.add(acc.mult(2));
      vel.limit(3); 
      pos.add(vel); //Forskellen p?? is vs asfalt er at hastigheden ikke s??ttes samme retning som bilen - f??rst n??r accelerationen har "indhentet" den, kan bilen k??rer dens retning - indtil da glider den
    } else Stop(1);
  }



  void Stop(float h) {
    // virker p?? samme m??de som n??r bilen speeder op, bare med sub istedet for add
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

  PVector GetPos() {
    return pos;
  }

  float GetRot() {
    return theta;
  }

  //Laver partiklerne
  void Particles(float s, float t, boolean which) { //Laver partikelsystemet
    ps.addParticle(s, t, which);
    ps.run(pos);
  }
}
