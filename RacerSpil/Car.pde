class Car{
  PVector pos, vel, acc, fric, boost, rotation, bremsVel;
  float theta, thetaVel, thetaAcc;
  int h = 1;
  boolean ice;
  
  Car(PVector p, PVector v, PVector a, boolean i, PVector b, float t){
    pos = p;
    vel = v;
    acc = a;
    ice = i;
    boost = b;
    theta = t;
    thetaVel = 0;
    thetaAcc = 0.00025;
  }
  
  void Update(int drej, int koer){
    
    rotation = new PVector(cos(theta), sin(theta));
    acc = rotation.mult(0.01);
    
    Turn(drej);
        
    if(!ice){
    Drive(koer);
    } else DriveIce(koer);

    DrawCar();
    
  }
  
  void DrawCar(){
    background(220);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0, 0, 60, 30); 
    //line(0,0, vel.x*50, vel.y*50);
    popMatrix();
  
  }
  
  void Turn(int drej){
    
    if (drej == 0){
      theta += 0;
      thetaVel = 0;
    } else if (drej == 1){
      thetaVel += thetaAcc;
      theta -= thetaVel;
      if(thetaVel >= 0.03) thetaVel = 0.03;
    } else if (drej == 2){
      thetaVel += thetaAcc;
      theta += thetaVel;
      if(thetaVel >= 0.03) thetaVel = 0.03;
    }
  }
  
  void Drive(int koer){
    
     if(koer == 1){
      vel.add(acc);
      rotation.normalize();
      rotation.mult(mag(vel.x, vel.y));
      vel = rotation;
      vel.limit(3);
      pos.add(vel);
      h = 1;
    } else if(koer == 2){
      vel.sub(acc);
      rotation.normalize();
      rotation.mult(mag(vel.x, vel.y));
      pos.sub(rotation);
      vel.limit(0.5);
      if(thetaVel >= 0.01) thetaVel = 0.0099;
      h = -1;
      
    } else Stop(h);
  }
  
  void DriveIce (int koer){
    if(koer == 1){
      vel.add(acc.mult(2));
      vel.limit(3);
      pos.add(vel);
    } else Stop(1); 
    
  }
  
  void Stop(int h){
    vel.sub(acc.mult(h));
    rotation.normalize();
    rotation.mult(mag(vel.x, vel.y));
    vel = rotation;
    pos.add(vel);
  }
  
}
