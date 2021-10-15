import java.util.Iterator;

class SeedMenu {
  int spacing = 45;
  int spacingCount = 0;
  String convertedTime;
  int displayCount = 0;
  int maxDisplay = 10;
  
  String dbUsername;

  SeedMenu() {
  }

  void Update(SQLite db, String currentUsername) {
    Draw(db, currentUsername);
  }

  void Draw(SQLite db, String currentUsername) {
    fill(180, 200, 220);
    rect(60, 150, 580, 900, 10);

    fill(0, 0, 0);
    textSize(50);
    text("MANAGE SEEDS", 160, 220);
    textSize(16);
    fill(70, 70, 70);
    text("Press CTRL+S to save current seed (last "+maxDisplay+" saves are displayed).", 102.5, 250);
    fill(0, 0, 0);
    rect(90, 230, 520, 1);
    rect(210, 270, 1, 730);
    rect(90, 320, 520, 1);

    textSize(30);
    text("Seed", 110, 315);
    text("Best time", 250, 315);

    textSize(25);

    printSQL(db, currentUsername);


    //for (int i = 0; i < savedSeeds.length; i++) {
    //  text(savedSeeds[i], 100, 315+(spacing-3)*(i+1));
    //  text(savedTimes[i], 240, 315+(spacing-3)*(i+1));
    //  rect(90, 315+spacing*(i+1), 520, 1);
    //}

    //for (int row = 0; row < savedSeedScores.length; row++) {
    //  for (int col = 0; col < savedSeedScores[row].length; col++) {
    //    savedSeedScores[row][col] = row * col;
    //    println(savedSeedScores[row][col]+"/t");
    //  }
    //}
  }

  void printSQL(SQLite db, String currentUsername) {
    spacingCount = 0;
    displayCount = 0;
    db.query("SELECT seed, time, username FROM HS WHERE username='"+currentUsername+"';");
 //<>//

  //  while (db.next()) {
  //    if (db.getString("username") == currentUsername && displayCount < maxDisplay) {
  //      text(db.getInt("seed"),100,315+(spacing-3)*(spacingCount+1));
  //      text(convertTime(db.getInt("time")),240,315+(spacing-3)*(spacingCount+1));
  //      spacingCount++;
  //      displayCount++;
  //  }
  //}
  while (db.next()) {
      println("DB Username = "+db.getString("username")+"    currentUsername = "+currentUsername);
      if (db.getString("username")==currentUsername) println("Usernames are identical!");
      
      if (displayCount < maxDisplay) { //<>//
        text(db.getInt("seed"),100,315+(spacing-3)*(spacingCount+1));
        text(convertTime(db.getInt("time")),240,315+(spacing-3)*(spacingCount+1));
        spacingCount++;
        displayCount++;
    }
  }
}

String convertTime (int time) {

  int min, sec;

  //konverterer tiden til læsbar format for racetime
  min = floor(time/60000f);
  time = time - floor(time/60000f)*60000;
  sec = floor(time/1000f);
  time = time - floor(time/1000f)*1000;

  convertedTime = min+":"+sec+"."+time;

  return convertedTime;
}
}
