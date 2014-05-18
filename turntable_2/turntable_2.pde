// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com



// Click mouse to add boids into the system
Flock flock;
PVector center;
FlowField f;
FlowField f2;
boolean showvalues = false;
//boolean scrollbar = false;


void setup() {
  size(displayWidth, displayHeight, P2D);
  //  setupScrollbars();
  f = new FlowField(20, 150, 220, 90);
  f2 = new FlowField(20, 330, 380, 90);
  center = new PVector(width/2, height/2);
  colorMode(RGB, 255, 255, 255, 100);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 250; i++) {
    flock.addBoid(new Boid(width/2, height/2+330, 7.5, 3, 7, color(255, 0, 0)));
    flock.addBoid(new Boid(width/2, height/2-330, 7.5, 3, 7, color(255, 0, 0)));
    flock.addBoid(new Boid(width/2, height/2, 7, 3, 7, color(0, 0, 255)));
    flock.addBoid2(new Boid(width/2, height/2, 7, 3, 7, color(0, 0, 255)));
  }
  smooth();
}


void draw() {

  background(255); 
  flock.run();
  //  drawScrollbars();

  if (mousePressed) {
//    flock.addBoid2(new Boid(mouseX, mouseY, 10, 10, 12, color(0, 0, 255)));
  }


  if (showvalues) {
   f.display(color(0,255,0));
    f2.display(color(0,0,0));
    //    fill(0);
    //    textAlign(LEFT);
    //    text("Total boids: " + flock.boids1.size() + "\n" + "Framerate: " + round(frameRate) + "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
  }
}

void keyPressed() {
    showvalues = !showvalues;
//  if (key=='r') {
//    flock.addBoid(new Boid(mouseX, mouseY, 7, 3, 7, color(255, 0, 0)));
//  }
//  if (key=='c') {
//    flock.addBoid2(new Boid(mouseX, mouseY, 7, 3, 9, color(0, 0, 255)));
//  }
}

void mousePressed() {
}

