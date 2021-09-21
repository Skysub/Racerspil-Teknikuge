class TextField {
  ControlP5 cp5;
  String enteredSeed, seedTextfield, seedTextfieldOld;
  int firstSeed, textFieldCount;
  Textfield textfield;

  //konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
  //PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  TextField(PApplet thePApplet, int fs) {
    textFieldCount = 0;
    seedTextfield = "SeedTextField";
    firstSeed = fs;
    enteredSeed = str(firstSeed);
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    textfield = cp5.addTextfield("SeedTextField").setPosition(730, 450).setSize(520, 50).setAutoClear(false).setInputFilter(1).setText(str(firstSeed)).setCaptionLabel("").keepFocus(true);
  }

  void Update(int seed, boolean newRandomSeed) {
    Draw();
    firstSeed = seed;
    if (newRandomSeed) {
      if (textFieldCount == 0) {
        cp5.remove("SeedTextField");
      }
      else {
        cp5.remove(seedTextfield);
      }
      textFieldCount += 1;
      seedTextfield = "SeedTextField" + str(textFieldCount);
      seedTextfieldOld = seedTextfield;

      textfield = cp5.addTextfield(seedTextfieldOld).setPosition(730, 450).setSize(520, 50).setAutoClear(false).setInputFilter(1).setText(str(firstSeed)).setCaptionLabel("").keepFocus(true);
      //cp5.get(Textfield.class, "SeedTextField").setVisible(false);
      //cp5.remove("SeedTextField");
    }
    seedTextfieldOld = null;
    enteredSeed = str(seed);
    enteredSeed = cp5.get(Textfield.class, seedTextfield).getText();
  }

  void Draw() {
    cp5.draw();
  }  

  //metode til at returnere input. Input skæres af ved 9 cifre, så værdien ikke bliver for stor for en int
  String input() {
    if (enteredSeed.length()<10) return enteredSeed;
    else if (enteredSeed.length() > 10) {
      return enteredSeed.substring(0, 9);
    } else return enteredSeed;
  }
}
