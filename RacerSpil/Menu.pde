class Menu {
  TextField textField;
  String enteredSeed;
  int seed, newSeedDecider;

  Menu(PApplet thePApplet, int s) {
    seed = s;
    textField = new TextField(thePApplet, seed);
  }

  void Update(boolean newSeed) {
    Draw();
    if (newSeed) newSeedDecider = 0;
    newSeedDecider += 1;
    if (newSeedDecider >= 2) seed = int(random(0, 9999)); //Sørger for et enkelt nyt seed per gang der trykkes mellemrum
    textField.Update(seed, newSeed);
  }

  void Draw() {
    fill(180, 200, 220);
    rect(700, 300, 580, 600, 10);

    fill(0, 0, 0);
    textSize(50);
    text("RACING GAME 9001", 745, 370);

    textSize(25);
    text("Enter seed here", 890, 435);

    textSize(20);
    fill(125, 125, 125);
    text("Space to generate new seed", 850, 522);

    textSize(25);
    fill(0, 0, 0);
    rect(730, 590, 520, 1);
    text("Controls", 933, 580);
    textSize(20);
    text("←↑↓→ to steer", 910, 630);
    text("R to reset", 935, 670);
    text("G to toggle fancy graphics", 860, 710);
    text("Mute system audio to toggle sound", 825, 750);
    text("ESC or Alt+F4 to close game", 855, 790);
    text("Q to open login screen", 870, 830);
  }
}
