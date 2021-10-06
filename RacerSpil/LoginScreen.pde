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

  void Update(boolean enter, boolean logIn, boolean signUp, int l) {
    Draw();
    username.input(false);
    password.input(false);

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
    if (enteredPassword != null && l != 1 && enteredUsername != null) {
      canClose = true;
      textSize(20);
      fill(120, 120, 120);
      text("Press F1 to close login screen", 850, 830);
    }

    username.Update();
    password.Update();

    if (enter) {
      enteredUsername = username.input(false);
      enteredPassword = password.input(false);

      if (!username.tooLong && !username.tooShort && !password.tooLong && !password.tooShort) {
        if (canClose && topText == "Log in") LogIn(enteredUsername, enteredPassword);
        else if (canClose && topText == "Sign up") SignUp(enteredUsername, enteredPassword);
      }
    }
  }

  void Draw() {
    fill(180, 200, 220);
    rect(700, 300, 580, 600, 10);

    fill(0, 0, 0);
    textSize(50);
    text(topText, 910 - textAligner, 370);

    textSize(20);
    fill(120, 120, 120);
    text("↑↓ to change between log in / sign up ", 790, 400);

    fill(0);
    textSize(25);
    text("Username", 920, 485);
    text("Password", 920, 635);

    text("Press enter to " + topText, 860 - textAligner/3, 800);

    textSize(20);
    fill(250, 100, 100);
    if (username.tooLong) text("Your username is too long", 855, 572);
    if (username.tooShort) text("Your username is too short", 855, 572);
    if (password.tooLong) text("Your password is too long", 855, 722);
    if (password.tooShort) text("Your password is too short", 855, 722);
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
