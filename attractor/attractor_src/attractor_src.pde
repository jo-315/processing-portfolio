Particle partcle = new Particle();

void setup() {
  size(800, 600);
  fill(200, 0, 0);
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
  ArrayList<PVector> targets = new ArrayList<PVector>();
  float size = 10;
  float maxSpeed = 5;
  float yNoise = 0;
  PVector currentPosition, velocity, acceleration;

  Particle () {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    currentPosition = new PVector(
      0,
      height / 2
    );
    setTarget();
  }

  void updata() {
    // if (target.y - currentPosition.y < 100) {
      // setTarget();
    // }
    seek();
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    move();

    display();

    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);
      if (PVector.dist(currentTarget, currentPosition) < 10) {dismissTarget();}
    }

    acceleration.mult(0);

    setHistory();
  }

  void setTarget() {
    targets.add(new PVector(
      200,
      300
    ));
    targets.add(new PVector(
      300,
      100
    ));
    targets.add(new PVector(
      700,
      500
    ));
  }

  void setHistory() {
    history.add(currentPosition.get());
    if (history.size() > 50) {
      history.remove(0);
    }
  }

  void seek() {
    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);
      if (PVector.dist(currentTarget, currentPosition) > 500) {return;}
      PVector targetVector = PVector.sub(currentTarget, currentPosition);
      targetVector.normalize();
      targetVector.mult(maxSpeed * 50 / PVector.dist(currentTarget, currentPosition));
      PVector force = PVector.sub(targetVector, velocity);

      applyForce(force);
    }
  }

  void dismissTarget() {
    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);
      if (currentPosition.x >= currentTarget.x) { targets.remove(index); }
    }
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

    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);
      fill(255, 225, 255);
      ellipse(currentTarget.x, currentTarget.y, size*3, size*3);
    }
  }
}