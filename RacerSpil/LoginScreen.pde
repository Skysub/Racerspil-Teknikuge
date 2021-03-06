class LoginScreen {
  TextFieldString username, password;
  String enteredUsername, enteredPassword, topText;
  boolean canClose = false, newEnter = false;
  int textAligner;
  String[] logInData = new String[3];


  LoginScreen(PApplet thePApplet) {
    username = new TextFieldString(thePApplet, "", new PVector(730, 500));
    password = new TextFieldString(thePApplet, "", new PVector(730, 650));
    topText = "Log in";
    textAligner = 0;
  }

  String[] Update(boolean enter, boolean logIn, boolean signUp, int l, int status) {
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
      text("Press Q to close login screen", 855, 830);
    } 

    if (enter) newEnter = true;

    if (status == 1 || status == -1 || status == 2 || status == 4) canClose = false;
    else {
      canClose = true;      
      newEnter = false;
    }
    print(status);

    textSize(20);
    fill(250, 100, 100);

    if (status == 1) text("This username is already in use", 855, 750);
    if (status == -1) text("Wrong username or password", 855, 750);
    if (status == 2) text("No user with this name exists", 855, 750);


    username.Update();
    password.Update();
    print(password.tooShort+" ");
    if (enter) {
      enteredUsername = username.input(false);
      enteredPassword = password.input(false);

      if (!username.tooLong && !username.tooShort && !password.tooLong && !password.tooShort) {
        if (canClose && topText == "Log in") LogIn(enteredUsername, enteredPassword);
        else if (canClose && topText == "Sign up") SignUp(enteredUsername, enteredPassword);
      }
    }

    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      md.update(enteredPassword.getBytes());

      byte[] byteList = md.digest();

      StringBuffer hashedValueBuffer = new StringBuffer();
      for (byte b : byteList)hashedValueBuffer.append(hex(b));

      if (newEnter && !password.tooShort)logInData[0] = topText;
      else {
        logInData[0] = null; 
        newEnter = false;
      }
      logInData[1] = enteredUsername;
      logInData[2] = hashedValueBuffer.toString();
    } 
    catch (Exception e) {
      System.out.println("Exception: "+e);
    }

    return logInData;
  }



  void Draw() {
    fill(180, 200, 220);
    rect(700, 300, 580, 600, 10);

    fill(0, 0, 0);
    textSize(50);
    text(topText, 910 - textAligner, 370);

    textSize(20);
    fill(120, 120, 120);
    text("?????? to change between log in / sign up ", 790, 400);

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
    //Database stuff.
  }
}
