class Blok {

  int blokkeIalt = 4;







  //Start blok Info
  int B0Info(int a) {

    switch (a) {
    case 0: //Size
      return 1;
    case 1: //Inpoint x
      return 0;
    case 2: //Inpoint y
      return 80;
    case 3: //Outpoint x
      return 160;
    case 4: //Outpoint y
      return 80;

    default:
      return -1;
    }
  }

  //Start blok Draw
  void DrawB0() {
    fill(250, 200, 250);
    strokeWeight(2);
    stroke(20);
    square(0, 0, 160);
    strokeWeight(5);
    line(85, 0, 85, 160);
    line(75, 0, 75, 160);
    stroke(255);
    line(80, 0, 80, 160);
  }
}
