import java.util.Iterator;

final float GRAVITY = 0.1;
final int PARTICLE_COUNT = 12;

float backgroundR = 24;
float backgroundG = 31;
float backgroundB = 28;

ParticlesOperator[] particlesOperators = new ParticlesOperator[0];

void setup () {
  size(1200, 800);
}

void draw() {
  updateBackground();

  for (int index = 0; index < particlesOperators.length; index++){
    particlesOperators[index].update();
  }

  // create particles randomly
  int random_int = int(random(0, 1) * 100);
  if(random_int < 20) {
    float randomX = random(1, width);
    float randomY = random(1, height);

    // ※ #append needs type {ex.(ParticlesOperator[])}
    particlesOperators = (ParticlesOperator[])append(
      particlesOperators,
      new ParticlesOperator(int(randomX), int(randomY))
    );
  }
}

void mouseClicked() {
  // create new particles group
  particlesOperators = (ParticlesOperator[])append(
    particlesOperators,
    new ParticlesOperator(mouseX, mouseY)
  );
}

void updateBackground() {
  noStroke();
  fill(backgroundR, backgroundG, backgroundB);
  rect(0, 0, width, height);
}

class ParticlesOperator {
  ArrayList<Particle> particles = new ArrayList<Particle>();

  ParticlesOperator(int x, int y) {
    int index = 0;
    PVector newVector = new PVector(x, y);

    // create Particle
    while(index < PARTICLE_COUNT) {
      particles.add(new Particle(newVector, index));
      index ++;
    }
  }

  void update() {
    // particlesのデータがある場合の処理を記述→ここでparticleのデータは持たないので、iteratorを使う
    Iterator<Particle> particleIterator = particles.iterator();

    int index = 0;

    while (particleIterator.hasNext()) {
      index++;

      Particle nextParticle = particleIterator.next();

      // Remove any particles outside of the screen
      if (nextParticle.position.x > width
        || nextParticle.position.x < 0
        || nextParticle.position.y > height
        || nextParticle.position.y < 0) {
          particleIterator.remove();
          continue;
      }

      // Move particle position
      nextParticle.move();

      // Remove dead particles
      if (nextParticle.isFinished()) {
        if(nextParticle.isExpload) {
          nextParticle.explode(particleIterator);
        } else {
          particleIterator.remove();
        }
      } else {
        nextParticle.display();
      }
    }
  }
}

class Particle {
  final static float MAX_SPEED = 0.5;
  final float PARTICLE_ANGLE = 360 / PARTICLE_COUNT;

  PVector position, velocity, accacceleration;

  float mass = random(2, 2.5);
  float size = random(1, 8.0);
  float r, g, b;
  int lifespan = 255;
  boolean isExpload;

  Particle(PVector p, int index) {
    velocity = new PVector(
      MAX_SPEED * cos(radians(index * PARTICLE_ANGLE)),
      MAX_SPEED * sin(radians(index * PARTICLE_ANGLE)) - 1
    );
    position = new PVector(p.x, p.y);
    accacceleration = new PVector(
      MAX_SPEED * cos(radians(index * PARTICLE_ANGLE)) / 100,
      mass * GRAVITY / 50
    );
    r = random (0, 255);
    g = random (0, 255);
    b = random (0, 255);
    isExpload = index == 0;
  }

  public void move() {
    velocity.add(accacceleration); // Apply accaccelerationeleration
    position.add(velocity); // Apply our speed vector

    size += 0.04;
    lifespan--;
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
  }

  public void display() {
		// Colour based on x and y velocityocity
    fill(r, g, b);
    ellipse(position.x, position.y, size, size);
  }

  public boolean isFinished() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }

  public void explode(Iterator<Particle> particleIterator) {
    // stop position
    velocity.mult(0);
    accacceleration.mult(0);

    // explode
    size += 30;
    display();

    if(size > width * 2) {
      // set backgroung color
      backgroundR = r;
      backgroundG = g;
      backgroundB = b;

      particleIterator.remove();
    }
  }
}