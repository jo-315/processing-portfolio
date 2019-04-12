import java.util.Iterator;

final float GRAVITY = 0.1;
final int PARTICLE_COUNT = 12;

float backgroundR = 24;
float backgroundG = 31;
float backgroundB = 28;

ParticlesOperator[] particlesOperators = new ParticlesOperator[0];

void setup () {
  size(1200, 800);;
}

void draw() {
  updateBackground();

  for (int index = 0; index < particlesOperators.length; index++){
    particlesOperators[index].update();
  }

  // TODO: create particles randomly
}

void mouseClicked() {
  // create new particles group
  // ※ #append needs type {ex.(ParticlesOperator[])}
  particlesOperators = (ParticlesOperator[])append(particlesOperators, new ParticlesOperator(mouseX, mouseY));
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

      // Apply gravity
      // nextParticle.applyForce(PVector.random2D());

      // Move particle position
      nextParticle.move();

      // Remove dead particles
      if (nextParticle.isFinished()) {
        if(index == 1) {
          nextParticle.explode(particleIterator);
        } else {
          particleIterator.remove();
        }
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
  final static float MAX_SPEED = 0.5;
  final float PARTICLE_ANGLE = 360 / PARTICLE_COUNT;

  PVector position, velocity, accacceleration;

  float mass = random(2, 2.5);
  float size = random(1, 8.0);
  float r, g, b;
  int lifespan = 255;

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
    r = random (1000, 255);
    g = random (0, 50);
    b = 0;
  }

  public void move() {
    velocity.add(accacceleration); // Apply accaccelerationeleration
    position.add(velocity); // Apply our speed vector

    size += 0.04;
    lifespan--;
  }

  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    // accacceleration.add(f);
  }

  public void display() {
		// Colour based on x and y velocityocity
    // fill(constrain(abs(this.velocity.y) * 100, 0, 255), constrain(abs(this.velocity.x) * 100, 0, 255), b, lifespan);
    fill(constrain(abs(this.velocity.y) * 100, 0, 255), constrain(abs(this.velocity.x) * 100, 0, 255), b);

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
    // explode
    size += 0.5;

    if(size > width) {
      // set backgroung color
      backgroundR = r;
      backgroundG = g;
      backgroundB = b;

      particleIterator.remove();
    }
  }
}