class TextFieldString {
  ControlP5 cp5;
  String enteredString, stringTextfield, seedTextfieldOld;
  boolean tooLong;
  Textfield textfield;

  //konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
  //PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  TextFieldString(PApplet thePApplet, String s, PVector pos) {
    stringTextfield = "StringTextField";
    enteredString = s;
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    textfield = cp5.addTextfield("StringTextField").setPosition(pos.x, pos.y).setSize(520, 50).setAutoClear(false).setText(s).setCaptionLabel("").keepFocus(false);
  }

  void Update() {
    Draw();
  }

  void Draw() {
    cp5.draw();
  }  

  String input() {
    if (enteredString.length()<10) tooLong = false;
    else tooLong = true;
    
    return enteredString;
  }
}
