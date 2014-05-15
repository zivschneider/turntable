// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids1; // An ArrayList for all the boids
  ArrayList<Boid> boids2;

  Flock() {
    boids1 = new ArrayList<Boid>(); // Initialize the ArrayList
    boids2 = new ArrayList<Boid>();
  }

  void run() {
    for (Boid b : boids1) {
      b.run(boids1);  // Passing the entire list of boids to each boid individually
    }
    
    for (Boid b : boids2) {
      b.run(boids2);
    }
  }

  void addBoid(Boid b) {
    boids1.add(b);
  }
  
  void addBoid2(Boid b) {
    boids2.add(b);
  }

}
