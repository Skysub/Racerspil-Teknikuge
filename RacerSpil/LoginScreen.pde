class LoginScreen {
  TextFieldString username, password;
  String enteredUsername, enteredPassword, topText;
  boolean canClose = false;
  int textAligner;


  LoginScreen(PApplet thePApplet) {
    username = new TextFieldString(thePApplet, "", new PVector(730, 500));
    password = new TextFieldString(thePApplet, "", new PVector(730, 650));
    topText = "Log in";
    textAligner = 0;
  }

  void Update(boolean enter, boolean logIn, boolean signUp, boolean space, int l, boolean blank) {
    if(blank){
      username.input(true);
      blank = false;
    }
    
    
    Draw();

    if (logIn) {
      topText = "Log in";
      signUp = false;
      textAligner = 0;
    } else if (signUp) {
      topText = "Sign up";
      logIn = false;
      textAligner = 10;
    }
    if (enteredPassword != null && enteredUsername != null) l++;
    if (enteredPassword != null && l != 1 && enteredUsername != null) canClose = true;

    username.Update();
    password.Update();

    if (enter) {
      enteredUsername = username.input(false);
      enteredPassword = password.input(false);
    }
   
    if (space && canClose && topText == "Log in") LogIn(enteredUsername, enteredPassword);
    else if (space && canClose && topText == "Sign up") SignUp(enteredUsername, enteredPassword);
    
    print(enteredUsername, "||", enteredPassword, "||", canClose, "||", l, "||");
  }

  void Draw() {
    fill(180, 200, 220);
    rect(700, 300, 580, 600, 10);

    fill(0, 0, 0);
    textSize(50);
    text(topText, 910 - textAligner, 370);

    textSize(25);
    text("Username", 920, 485);
    text("Password", 920, 635);

    textSize(20);
    fill(125, 125, 125);
    text("Enter to confirm username", 855, 572);
    text("Enter to confirm password", 855, 722);
    text("Space to " + topText, 905 - textAligner/3, 800);

    text("Press ↑↓ to change between log in / sign in", 770, 420);
  }

  void LogIn(String un, String pw) {
    print(un, pw);
    //Database stuff
  }

  void SignUp(String un, String pw) {
    print(un, pw);
    //Database stuff. Der skal være noget her der også gør at man så logger ind når den har oprettet navnet og koden i databsen
  }
  
}
