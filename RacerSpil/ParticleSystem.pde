import java.util.Iterator;

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;


  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle(float strength, float theta, boolean particleBoost) {
    if (!particleBoost) particles.add(new Particle(origin, strength, theta + random(-1.5, 1.5), 65)); //Spørger om der skal laves normalle eller boostpartikler. Boostpartiklerne får et større limit på 200, så de kan ses i længere tid
    if (particleBoost) particles.add(new ParticleBoost(origin, strength, theta + random(-1.5, 1.5), 150));
  }

  void run(PVector location) {
    origin = location.get();
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove(); //Fjerne den 'døde' partikel fra arraylisten
      }
    }
  }
}
