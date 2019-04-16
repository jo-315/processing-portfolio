Particle partcle = new Particle();

void setup() {
  size(800, 600);
  fill(0, 0, 0);
  rect(0, 0, width, height);
}

void draw() {
  updateBackground();
  partcle.updata();
}

void updateBackground() {
  noStroke();
  fill(0, 0, 0, 100);
  rect(0, 0, width, height);
}

class Particle {
  ArrayList<PVector> history = new ArrayList<PVector>();
  float size = 10;
  float maxSpeed = 5;
  PVector currentPosition, target, velocity, acceleration;

  Particle () {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    currentPosition = new PVector(
      random(width),
      random(height)
    );
    setTarget();
  }

  void updata() {
    if (PVector.dist(target, currentPosition) < 100) {
      setTarget();
    }
    seek();
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    move();

    display();

    acceleration.mult(0);

    setHistory();
  }

  void setTarget() {
    target = new PVector(
      noise(random(width)) * width,
      noise(random(height)) * height
    );
  }

  void setHistory() {
    history.add(currentPosition.get());
    if (history.size() > 50) {
      history.remove(0);
    }
  }

  void seek() {
    PVector targetVector = PVector.sub(target, currentPosition);
    targetVector.normalize();
    targetVector.mult(maxSpeed);
    PVector force = PVector.sub(targetVector, velocity);

    applyForce(force);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void move() {
    currentPosition.add(velocity);
  }

  void display() {
    beginShape();
      stroke(255, 225, 0, 160);
      strokeWeight(1);
      noFill();
      for(PVector v: history) {
        vertex(v.x,v.y);
      }
    endShape();

    fill(255, 225, 0);
    ellipse(currentPosition.x, currentPosition.y, size, size);
  }
}