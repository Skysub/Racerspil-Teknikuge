class SeedButton {
ControlP5 cp5;
int GeneratedSeed;


//konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
//PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  SeedButton(PApplet thePApplet) {
    cp5 = new ControlP5(thePApplet);
    cp5.setAutoDraw(false);
    cp5.addButton("Button1").setValue(0).setPosition(815,520).setSize(350,50).setCaptionLabel("");
  }

  void Update() {
    Draw();
    //if (cp5.get(Button.class,"Button").isPressed()){
    //  GeneratedSeed = int(random(0,9999));
    //  println(GeneratedSeed);

    }

  void Button2(int value) {
    GeneratedSeed = int(random(0,9999));
    println(GeneratedSeed);
  }

  void Draw() {
      cp5.draw();
      fill(255,255,255);
      text("Generate random seed", 877,555);
      
    } 
    
}

  
