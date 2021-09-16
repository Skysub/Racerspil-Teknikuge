class Menu {
TextField textField;
String enteredSeed;

  Menu(PApplet thePApplet, int seed) {
    textField = new TextField(thePApplet, seed);
  }

  void Update() {
    Draw();
    textField.Update();
    enteredSeed = textField.input();
  }

  void Draw() {
    fill(180, 200, 220);
    rect(700,300,580,600, 10);
    
    fill(0,0,0);
    textSize(50);
    text("RACING GAME 9001", 745, 370);
    
    textSize(25);
    text("Enter seed here", 890, 435);
    
    fill(0,0,0);
    rect(730,590,520,1);
    text("Controls",933,580);
    textSize(20);
    text("←↑↓→ to steer", 910, 630);
    text("R to reset", 935, 670);
    text("TAB to toggle menu", 890, 710);
    text("P to toggle particles", 891, 750);
    text("Mute system audio to toggle sound", 825, 790);
    text("ESC or Alt+F4 to close game", 855, 830);
  }
  
  String input() {
    return enteredSeed;
    }
}
