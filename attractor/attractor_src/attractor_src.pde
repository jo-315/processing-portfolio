Particle partcle = new Particle();
int backgroundR = 6;
int backgroundG = 16;
int backgroundB = 39;

void setup() {
  size(800, 600);
  fill(backgroundR, backgroundG, backgroundB);
  rect(0, 0, width, height);
}

void draw() {
  updateBackground();
  partcle.updata();
}

void updateBackground() {
  noStroke();
  fill(backgroundR, backgroundG, backgroundB, 150);
  rect(0, 0, width, height);
}

class Particle {
  ArrayList<PVector> history = new ArrayList<PVector>();
  int historyCount = 100;
  ArrayList<PVector> targets = new ArrayList<PVector>();
  float size;
  float maxSpeed = 5;
  int boudry = 10;
  int eatCount = 0;
  boolean isMovingForward = true;
  PVector currentPosition, velocity, acceleration;

  // min force for move ahead
  PVector xMinForce = new PVector(0.1, 0);

  Particle () {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);

    currentPosition = new PVector(
      random(15, width - 15),
      random(15, height - 15)
    );
    setTarget(3);
  }

  void updata() {
    // calc length by target and set accelaration
    seek();

    // if outsede, change force
    checkInScreen();

    // vecocity.add(acceleration)
    setVelocity();

    move();

    // draw particle and targets
    display();

    // if target's force is unnecessary
    dismissTarget();

    // set acceleration
    acceleration.mult(0);

    // to draw tail
    setHistory();
  }

  void setTarget(int count) {
    for(int index=0; index < count; index++) {
      targets.add(new PVector(
        random(0, width),
        random(0, height)
      ));
    }
  }

  void seek() {
    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);

      // not influenced by too far or too near target
      if (PVector.dist(currentTarget, currentPosition) > 500 ||
        PVector.dist(currentTarget, currentPosition) < 40) {
          return;
      }

      PVector targetVector = new PVector(0, currentTarget.y - currentPosition.y);
      targetVector.normalize();
      targetVector.mult(maxSpeed * 5 / PVector.dist(currentTarget, currentPosition));

      PVector force = targetVector;
      // PVector force = PVector.sub(targetVector, velocity);
      if(isMovingForward) { force.add(xMinForce); } else { force.sub(xMinForce); }

      applyForce(force);
    }
  }

  void checkInScreen() {
    PVector targetVector = null;
    if (currentPosition.x < boudry) {
      targetVector = new PVector(maxSpeed, velocity.y);
      isMovingForward = true;
    } else if (currentPosition.x > width - boudry){
      targetVector = new PVector(-maxSpeed, velocity.y);
      isMovingForward = false;
    } else if (currentPosition.y < boudry) {
      targetVector = new PVector(velocity.x, maxSpeed);
    } else if (currentPosition.y > height- boudry) {
      targetVector = new PVector(velocity.x, -maxSpeed);
    }

    if(targetVector != null) {
      PVector force = PVector.sub(targetVector, velocity);
      applyForce(force);
    }
  }

  // m * a = f (m = 1)
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void dismissTarget() {
    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);

      if ((isMovingForward && currentPosition.x > currentTarget.x + 100) ||
        (!isMovingForward && currentPosition.x < currentTarget.x + -100)) {
          targets.remove(index);
          setTarget(1);
          // eatCount++;
          // size += 20;
      }
    }
  }

  void setVelocity() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
  }

  void move() {
    currentPosition.add(velocity);
  }

  void display() {
    // draw tail
    beginShape();
      stroke(255, 225, 0, 160);
      strokeWeight(1);
      noFill();
      for(PVector v: history) {
        vertex(v.x,v.y);
      }
    endShape();

    // draw particle
    size = currentPosition.x / 20;
    fill(255, 225, 0);
    ellipse(currentPosition.x, currentPosition.y, size, size);

    // draw targets
    noStroke();
    fill(169, 251, 215);
    for (int index = 0; index < targets.size(); index++) {
      PVector currentTarget = targets.get(index);
      ellipse(currentTarget.x, currentTarget.y, 15, 15);
    }
  }

  void setHistory() {
    history.add(currentPosition.get());
    if (history.size() > historyCount) {
      history.remove(0);
    }
  }
}