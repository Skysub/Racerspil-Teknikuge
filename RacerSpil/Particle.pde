class Particle {
  PVector location, velocity, acceleration, currentVelocity;
  float lifespan, theta;

  Particle(PVector origin, float s, float t) {
    acceleration = new PVector(-0.01,-0.01);
    location = origin.get();
    velocity = new PVector(random(-3, -1),random(-1,1));
    lifespan = 20 * s;
    theta = t;
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    currentVelocity = new PVector(velocity.x * cos(theta), velocity.y * sin(theta));
    location.add(currentVelocity);
    lifespan -= 2.0;
  }

  void display() {
    stroke(0,lifespan);
    fill(random(110,130), random(110,130), random(110,130),lifespan);
    ellipse(location.x, location.y, 15 + random(-5, 5), 15 + random(-5, 5));
    stroke(0);
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
