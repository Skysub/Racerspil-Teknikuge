import java.util.Iterator;

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;


  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle(float strength, float theta) {
    particles.add(new Particle(origin, strength, theta + random(-1.5, 1.5)));
  }

  void run(PVector location) {
    origin = location.get();
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
}