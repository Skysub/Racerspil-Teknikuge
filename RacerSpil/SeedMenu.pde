import java.util.Iterator;

class SeedMenu {
  int spacing = 45;


  SeedMenu() {
  }

  void Update() {
    Draw();
  }

  void Draw() {
    fill(180, 200, 220);
    rect(60, 150, 580, 900, 10);

    fill(0, 0, 0);
    textSize(50);
    text("MANAGE SEEDS", 160, 220);
    textSize(17);
    fill(70,70,70);
    text("Press CTRL+S to save current seed", 200, 250);
    fill(0,0,0);
    rect(90, 230, 520, 1);
    rect(210, 270, 1, 730);
    rect(90, 320, 520, 1);

    textSize(30);
    text("Seed", 110, 315);
    text("Best time", 250, 315);

    textSize(25);

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
}
