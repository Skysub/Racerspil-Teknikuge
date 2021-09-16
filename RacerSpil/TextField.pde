class TextField {
int MaxCharacters;
ControlP5 cp5;
String enteredSeed;


  TextField(PApplet thePApplet, int seed) {
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    cp5.addTextfield("SeedTextField").setPosition(730,450).setSize(520,50).setAutoClear(false).setInputFilter(1).setText(str(seed));
  }

  void Update() {
    Draw();
  }

  void Draw() {
      cp5.draw();
    }  
  }
