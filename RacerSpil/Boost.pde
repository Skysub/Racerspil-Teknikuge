class Boost {

  PVector location;
  
  //constructer
  Boost(PVector boostLocation) {
    location = boostLocation;

  }
  
  void DrawBoost(){
    fill(252,186,3);
    rectMode(CENTER);
    rect(location.x,location.y,50,50);
    fill(255,0,0);
    triangle(30,5, 12.5,27.5, 22.5,27.5);
    //rect();
    //triangle();
    
    rectMode(CORNER);
  }
}
