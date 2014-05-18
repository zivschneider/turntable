// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float frameCreated;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  color c;

  Vehicle(PVector l, float _fc, float ms, float mf, color _c) {
    frameCreated = _fc;
    location = l.get();
    r = 3.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    c=_c;
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    noStroke();
    fill(c);
//    stroke(c);
//    strokeWeight(3);
    rect(location.x, location.y, 2, 2);
    //    pushMatrix();
    //    translate(location.x,location.y);
    //    rotate(theta);
    //    beginShape(TRIANGLES);
    //    vertex(0, -r*2);
    //    vertex(-r, r*2);
    //    vertex(r, r*2);
    //    endShape();
    //    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  boolean kill() {
        PVector temp = new PVector(location.x, location.y);
    PVector center = new PVector(width/2, height/2);
    temp.sub(center);
    if((frameCount - frameCreated > 120) || (temp.mag()>250)){
      return true;
    } else {
      return false;
    }

//    if ((location.x < -r) || (location.y < -r) || (location.x > width+r) || (location.y > height+r)) {
//      return true;
//    } 
//    else {
//      return false;
//    }
  }
}

