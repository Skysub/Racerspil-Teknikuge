class Bane {
  int[][][] bane;
  boolean tileTest = false;

  Bane() {
    bane = new int [12][6][2];
  }



  void Draw(boolean tT) {
    tileTest = tT;
    pushMatrix();
    translate(120,0);
    
    
    
    
    popMatrix();
  }
}
