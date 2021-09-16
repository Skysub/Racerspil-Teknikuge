class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector origin) {
    acceleration = new PVector(-0.01,-0.01);
    velocity = new PVector(random(-3,-1),random(-1,1));
    location = origin.get();
    lifespan = 40.0;
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
  }

  void display() {
    stroke(0,lifespan);
    fill(random(50,255),0,0,lifespan);
    triangle(location.x,location.y, location.x-12, location.y-12, location.x-12, location.y+12);
    stroke(0);
  }

  // Is the Particle alive or dead?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
