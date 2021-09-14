class Car{
  PVector pos, vel, acc, fric, boost, rotation;
  float theta, thetaVel, thetaAcc;
  
  Car(PVector p, PVector v, PVector a, PVector f, PVector b, float t){
    pos = p;
    vel = v;
    acc = a;
    fric = f;
    boost = b;
    theta = t;
    thetaVel = 0;
    thetaAcc = 0.001;
  }
  
  void Update(int drej, int koer){
    
    rotation = new PVector(cos(theta), sin(theta));
    acc = rotation.mult(0.01);
    
    if (drej == 0){
      theta += 0;
      thetaVel -= thetaAcc;
      if(thetaVel <=0) thetaVel = 0;
    } else if (drej == 1){
      thetaVel += thetaAcc;
      theta -= thetaVel;
      if(thetaVel >= 0.03) thetaVel = 0.03;
    } else if (drej == 2){
      thetaVel += thetaAcc;
      theta += thetaVel;
      if(thetaVel >= 0.03) thetaVel = 0.03;
    }
    
    
    if(koer == 1){
      vel.add(acc);
      rotation.normalize();
      rotation.mult(mag(vel.x, vel.y));
      vel = rotation;
      pos.add(vel);
      vel.limit(3);
    } else if(koer == 2){
      vel.sub(acc);
      rotation.normalize();
      rotation.mult(mag(vel.x, vel.y));
      vel = rotation;
      pos.add(vel);
      vel.limit(3);
    } else if(koer == 0){
      /*vel.x -= vel.x/1000;
      vel.y -= vel.y/1000;  
      vel = new PVector(vel.x, vel.y);*/
      // skal gøre så bilen stopper ordentligt ikke bare brat op.
      vel.limit(0);
    } 
    
  }
  
  void Display(){
    background(220);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0, 0, 60, 30);
    
    popMatrix();
  
  }
  
}
