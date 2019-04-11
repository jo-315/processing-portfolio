import java.util.Iterator;

final float GRAVITY = -0.1;

Particles particles = new Particles();

void setup () {
  size(1200, 800);;
}

void draw() {
  updateBackground();
  particles.update();
}

void mouseMoved() {
  // add pressed key value
  particles.particles.add(new Particle(new PVector(mouseX, mouseY)));
}

void updateBackground() {
  noStroke();
  fill(24, 31, 28);
  rect(0, 0, width, height);
}

class Particles {
  ArrayList<Particle> particles = new ArrayList<Particle>();

  void update() {
    // particlesのデータがある場合の処理を記述→ここでparticleのデータは持たないので、iteratorを使う
    Iterator<Particle> particleIterator = particles.iterator();

    while (particleIterator.hasNext()) {
      Particle nextParticle = particleIterator.next();

      // Remove any particles outside of the screen
      if (nextParticle.position.x > width
        || nextParticle.position.x < 0
        || nextParticle.position.y > height
        || nextParticle.position.y < 0) {
          particleIterator.remove();
          continue;
      }

      // Apply gravity
      nextParticle.applyForce(PVector.random2D());

      // Move particle position
      nextParticle.move();

      // Remove dead particles
      if (nextParticle.isFinished()) {
        particleIterator.remove();
        continue;
      } else {
        nextParticle.display();
        continue;
      }
    }
  }
}

class Particle {
  final static float BOUNCE = -0.5;
  final static float MAX_SPEED = 0.1;

  PVector vel = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector acc = new PVector(0, 0);
  PVector position;

  float mass = random(2, 2.5);
  float size = random(0.1, 2.0);
  float r, g, b;
  int lifespan = 255;

  Particle(PVector p) {
    position = new PVector(p.x, p.y);
    acc = new PVector(random(0.1, 1.5), 0);
    r = random (1000, 255);
    g = random (0, 50);
    b = 0;
  }

  public void move() {
    vel.add(acc); // Apply acceleration
    position.add(vel); // Apply our speed vector
    acc.mult(0);

    size += 0.01; //0.015
    lifespan--;
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  public void display() {
		// Colour based on x and y velocity
    fill(constrain(abs(this.vel.y) * 100, 0, 255), constrain(abs(this.vel.x) * 100, 0, 255), b, lifespan);

    ellipse(position.x, position.y, size * 4, size * 4);
  }

  public boolean isFinished() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}