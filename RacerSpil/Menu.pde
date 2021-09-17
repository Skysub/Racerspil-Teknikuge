class Menu {
TextField textField;
SeedButton seedButton;
String enteredSeed;

  Menu(PApplet thePApplet, int seed) {
    textField = new TextField(thePApplet, seed);
    seedButton = new SeedButton(thePApplet);
  }

  void Update() {
    Draw();
    textField.Update();
    seedButton.Update();
  }

  void Draw() {
    fill(180, 200, 220);
    rect(700,300,580,660, 10);
    
    fill(0,0,0);
    textSize(50);
    text("RACING GAME 9001", 745, 370);
    
    textSize(25);
    text("Enter seed here", 890, 435);
    
    fill(0,0,0);
    rect(730,680,520,1);
    text("Controls",933,670);
    textSize(20);
    text("←↑↓→ to steer", 910, 720);
    text("R to reset", 935, 760);
    text("TAB to toggle menu", 890, 800);
    text("P to toggle particles", 891, 840);
    text("Mute system audio to toggle sound", 825, 880);
    text("ESC or Alt+F4 to close game", 855, 920);
  }
}
