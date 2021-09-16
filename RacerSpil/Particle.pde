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
