
class Vehicle {

  public PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  color c1;
  ////
  float swt = 10.0;     //sep.mult(25.0f);
  float awt = 2.0;      //ali.mult(4.0f);
  float cwt = 40.0;      //coh.mult(5.0f);
  ////
float a = random (1,6);
float b = random (1,6);
  //constructor  
  
  Vehicle(PVector l, float ms, float mf, color _c) {
  location = l.get();  
    r = 16.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
//    x = random(10);
      velocity = new PVector(0, 0);
    c1 = _c;
 
  }

  public void run() {
    update();
    display();
    flock(vehicles);
   //follow(flowfield);
}  

  ///////////////////////

  // copied from flocationk sliders

  void flock(ArrayList<Vehicle> vehicles) {
   PVector sep = separate(vehicles);   // Separation
   PVector ali = align(vehicles);      // Alignment
   PVector coh = cohesion(vehicles);   // Cohesion
    // Arbitrarily weight these forces
      sep.mult(swt);
    ali.mult(awt);
   // coh.mult(cwt);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
  //applyForce(coh);
  }
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    desired.mult(maxspeed); // Scale it up by maxspeed
       // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }


  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
void update() {
    velocity.add(acceleration);// Update velocity  
    velocity.limit(maxspeed); // Limit speed
    location.add(velocity);
    acceleration.mult(0);// Reset accelertion to 0 each cycle
  }

  void display() {
    
    float theta = velocity.heading2D() + radians(90);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    //beginShape(ELLIPSE);
    rect(0,0,a,b,random(-2,2));
   // image(img2,r,-r);
    fill(c1);
    //endShape();
    popMatrix();
  }

  void checkEdges() {
    if (location.x < r) {
      location.x = r;
      velocity.x *= -1;
    }
    if (location.x > width - r) {
      location.x = width - r;
      velocity.x *= -1;
    }
    if (location.y < r) {
      location.y = r;
      velocity.y *= -1;
    }
    if (location.y > height - r) {
      location.y = height - r;
      velocity.y *= -1;
    }
        
  }


  PVector separate (ArrayList<Vehicle> vehicles) {
    float desiredseparation = 0.0;
    PVector steer = new PVector(0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Vehicle other : vehicles) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Vehicle> vehicles) {
    float neighbordist = 20.0;
    PVector steer = new PVector();
    int count = 0;
    for (Vehicle other : vehicles) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  PVector seek(PVector target) {
    // Normalize desired and scale to maximum speed
    PVector desired = new PVector();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

      return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location

  PVector cohesion (ArrayList<Vehicle> vehicles) {
    float neighbordist = 0.0;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Vehicle other :vehicles) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the loclocation
    }
    return sum;
  }
}
