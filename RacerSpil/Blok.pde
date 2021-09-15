class Blok {

  int blokkeIalt = 1;
  int[][] blokInfo = new int[blokkeIalt][5];

  //constructer
  Blok() {
    
    //hardkoder blokkenes info
    //Size, Inpoint x, Inpoint y, Outpoint x, Outpoint y, outpoint retning i forhold til inpoint(0frem,1højre,2tilbage,3venstre)
    
    //Start blok
    int[] temp = {1,0,80,160,80,0};
    blokInfo[0] = temp;
  }






  //returnerer det tal under en bloks id der er ønsket.
  int GetBlokInfo(int id, int a) {
    return blokInfo[id][a];
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  void DrawBlok(int id) {
    switch (id) {
    case 0: //Start blok
      DrawB0();
      break;

    default:
      return;
      
    }
    //Reverter til default
    stroke(20);
    strokeWeight(1);
  }
  
  int GetBlokIalt(){
   return 2;
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
