class Boost {

  PVector location;
  Boolean boosting = false;
  
  //constructer
  Boost(PVector boostLocation) {
    location = boostLocation;

  }
  
  void DrawBoost(){
    fill(252,186,3);
    rectMode(CENTER);
    rect(location.x,location.y,50,50);
    fill(255,0,0);
    rectMode(CORNER);
    noStroke();
    rect(77.5,77.5, 5,5);
    triangle(85,60, 67.5,82.5, 77.5,82.5);
    triangle(82.5,77.5, 92.5,77.5, 77.5,102.5);
    stroke(20);
  }
  
  void UpdateBoost(){
    //collision logic here. Boosting true if colliding
  }
  
  Boolean IsBoosting(){
    return boosting;
  }
}
