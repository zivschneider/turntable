// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com



// Click mouse to add boids into the system
Flock flock;
PVector center;

boolean showvalues = true;
//boolean scrollbar = false;


void setup() {
  size(displayWidth,displayHeight,P2D);
//  setupScrollbars();
  center = new PVector(width/2,height/2);
  colorMode(RGB,255,255,255,100);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 120; i++) {
    flock.addBoid(new Boid(width/2,height/2, 25, 4, 5, color(255,0,0)));
    flock.addBoid2(new Boid(width/2,height/2, 15, 10, 12, color(0,0,255)));
  }
  smooth();
}


void draw() {

  background(255); 
  flock.run();
//  drawScrollbars();

  if (mousePressed) {
    flock.addBoid2(new Boid(mouseX,mouseY, 10, 10, 12, color(0,0,255)));
  }


//  if (showvalues) {
//    fill(0);
//    textAlign(LEFT);
//    text("Total boids: " + flock.boids1.size() + "\n" + "Framerate: " + round(frameRate) + "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
//  }
}

void keyPressed() {
  showvalues = !showvalues;
}

void mousePressed() {
}

