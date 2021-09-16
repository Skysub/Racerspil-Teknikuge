class ParticleBoost extends Particle {

  ParticleBoost(PVector p, float s, float t, float l) {
    super(p, s*2, t, l);
    lifespan = 32 * s;
  }

  /*void Update() {
    if (lifespan >= 200) lifespan = 199.9;
    rect(200,200,200,200);
  }*/

  void display() {
    float theta = map(location.x, 0, width, 0, TWO_PI*20);

    rectMode(CENTER);
    fill(random(50, 255), random(50, 255), random(50, 255), lifespan);
    stroke(0, lifespan);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    rect(0, 0, 16, 16);
    popMatrix();
  }
}
