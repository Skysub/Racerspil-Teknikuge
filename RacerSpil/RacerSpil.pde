import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import controlP5.*;
import processing.sound.*;

GameLogic gameLogic;
PImage backdrop;

void setup() {
  size(1920, 1080);
  frameRate(144);
  gameLogic = new GameLogic(this);
  if (!gameLogic.checkDB()) {
    println("Database Error, shutting down program");
    exit();
  }
  backdrop = loadImage("Dirt.png");
  smooth();
}

void draw() {
  background(220);

  gameLogic.Update();
}

void keyPressed() {
  gameLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  gameLogic.HandleInput(keyCode, false);
} 
