class Car {
  PVector pos, vel, acc, rotation, backVel, endOfCar, carRetning = new PVector(0, 0);
  float thetaVel, thetaAcc, linearVel, linearBackVel, theta, maxVel, maxBackVel, stopVel, bremseVel, maxThetaVel, maxThetaBackVel, acceleration, h = 1;
  int cDrej, accelerate, carWidth, carHeight;
  boolean ice, playSpeedUp = true;
  long startWait;

  PImage carSprite;
  ParticleSystem ps;
  SoundFile speedUp;


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

    startWait = millis();
  }

  void Update(boolean hojre, boolean venstre, boolean op, boolean ned, boolean givBoost, boolean hDb) {
    carRetning = new PVector(carWidth/2f, 0);
    carRetning.rotate(theta+HALF_PI);

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

    speedUp.amp(linearVel/4);

    if (playSpeedUp) speedUp.play();

    if (speedUp.isPlaying()) playSpeedUp = false;
    else playSpeedUp = true;




    if (!ice) { //Om bieln kører på si eller ej
      Drive(accelerate, givBoost);
    } else DriveIce(accelerate);

    if (hDb)DrawCarHitbox();
    else DrawCar();
  }

  void Hit(float[] ret, boolean tT) {
    //println(carRetning.y > 0);
    //println(carRetning.x > 0);
    if (ret[0] != -1 && !tT) {
      vel.mult(0.9);
      if (carRetning.y > 0) {
        switch (int(ret[1])) {
        case 0:
          if (carRetning.x > 0)theta += 0.1f;
          else theta -= 0.1f;
          break;
        case 1:
          if (carRetning.x > 0)theta -= 0.1f;
          else theta += 0.1f;
          break;
        case 2:
          if (carRetning.x > 0)theta += 0.1f;
          else theta -= 0.1f;
          break;
        case 3:
          if (carRetning.x > 0)theta -= 0.1f;
          else theta += 0.1f;
          break;
        }
      } else {

        switch (int(ret[1])) {
        case 0:
          if (carRetning.x > 0)theta -= 0.1f;
          else theta += 0.1f;
          break;
        case 1:
          if (carRetning.x > 0)theta += 0.1f;
          else theta -= 0.1f;
          break;
        case 2:
          if (carRetning.x > 0)theta -= 0.1f;
          else theta += 0.1f;
          break;
        case 3:
          if (carRetning.x > 0)theta += 0.1f;
          else theta -= 0.1f;
          break;
        }
      }
    }
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



  void Drive(int koer, boolean boost) {

    if (boost) { 
      maxVel = 10; //sætter maks hastigheden til et højere tal
      if (linearVel <= 2) vel.setMag(2); //Sørger for et boost selvom der køres langsomt
      vel.mult(1.15);
    } else {
      maxVel = constrain(maxVel, 4, 10); 
      maxVel = maxVel - 0.05; //maks hastigheden falder ligeså langsomt til den normalle makshastighed efter boostet
    }

    vel.limit(maxVel);

    if (koer == 1) {
      if (linearBackVel > 0.02) Stop(-stopVel); //Sørger for at man ikke kan køre ligeud når der bakkes
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

  PVector GetPos() {
    return pos;
  }

  float GetRot() {
    return theta;
  }

  void Particles(float s, float t, boolean which) { //Laver partikelsystemet
    ps.addParticle(s, t, which);
    ps.run(pos);
  }
}
