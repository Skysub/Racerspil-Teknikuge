class Boost {

  PVector location;
  Boolean boosting = false;
  int w = 50, h = 50;
  
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
  
  boolean CheckCollision(PVector carPos){
    if((carPos.x+5 > location.x-w/2f) && (carPos.x-5 < location.x+w/2f) && (carPos.y+5 > location.y-h/2f) && (carPos.y-5 < location.y+h/2f)) return true;    
    return false;
  }
}
