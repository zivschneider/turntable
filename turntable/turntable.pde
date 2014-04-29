PGraphics pg;
boolean debug = true;
int arrayLength = 600;
int arrayLength2 = 600;

// Flowfield object

FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;
ArrayList<Vehicle> vehicles2;

void setup() {
  size(1000, 700,P2D);
  //pg = createGraphics(700, 700,P2D);


  vehicles = new ArrayList<Vehicle>();//Vehicle [arrayLength];
  vehicles2 = new ArrayList<Vehicle>();// new Vehicle [arrayLength2];

  flowfield = new FlowField(10);
  for (int i=0; i<arrayLength; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(1, 4), random(0.5, 1), color(#A6E04B)));
  }
  for (int i=0; i<arrayLength2; i++) {
    vehicles2.add(new Vehicle (new PVector(random(width), random(height)), random(2, 5), random(0.1, 0.5), color(#2046D1)));
  }
}
void draw() {
  //pg.beginDraw(); 

  //pg.background(0);
  background(0);
  // Display the flowfield in "debug" mode
  // if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  //for (int i = 0; i < arrayLength; i++) {
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.flock(vehicles2);
    v.run(); 
    v.checkEdges();
  }
  for (Vehicle v : vehicles2) {
  //for (int j = 0; j < arrayLength2; j++) {
    v.follow(flowfield);
    v.run();
    v.checkEdges();
  }
  //pg.endDraw();
  
  fill(255);
  textSize(32);
  text(int(frameRate),10,60);
  
}

void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

// Make a new flowfield
void mousePressed() {
  flowfield.init();
}


