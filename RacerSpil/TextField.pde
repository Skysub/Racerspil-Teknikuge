// as seen on https://discourse.processing.org/t/get-user-input-with-textbox-class/16150/9
import g4p_controls.*;
GTextField txf1;
String t0;
String enteredSeed;


class TextField {
int MaxCharacters;

  TextField() {
    txf1 = new GTextField(this, 10, 10, 200, 20);
    txf1.setPromptText("Text field 1");
    txf1.setText("test1");
  }

  void Update() {
    Draw();
  }

  void Draw() {
    if(keyPressed && key == ENTER) {
      enteredSeed = t0;
    }
  }
  
  void handleTextEvents(GEditableTextControl textcontrol, GEvent event){
    if(txf1 == textcontrol && event == GEvent.ENTERED) {
      t0 = txf1.getText();
    }
  }
}
