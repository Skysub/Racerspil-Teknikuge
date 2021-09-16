class TextField {
ControlP5 cp5;
String enteredSeed;

//konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
//PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  TextField(PApplet thePApplet, int seed) {
    enteredSeed = str(seed);
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    cp5.addTextfield("SeedTextField").setPosition(730,450).setSize(520,50).setAutoClear(false).setInputFilter(1).setText(str(seed)).setCaptionLabel("");
  }

  void Update() {
    Draw();
    enteredSeed = cp5.get(Textfield.class,"SeedTextField").getText();
  }

  void Draw() {
      cp5.draw();
    }  
  
  //metode til at returnere input. Input skæres af ved 9 cifre, så værdien ikke bliver for stor for en int
  String input() {
    if (enteredSeed.length()<10) return enteredSeed;
    else if (enteredSeed.length() > 10) {
      return enteredSeed.substring(0,9);
    }
    else return enteredSeed;

    }
  }
