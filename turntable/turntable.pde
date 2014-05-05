//PImage img;
boolean debug = false ;
int arrayLength = 800;
int arrayLength2 = 800;

LeapMotionP5 leap;
FlowField flowfield;

// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;
ArrayList<Vehicle> vehicles2;

void setup() {
  size(1000, 700, P3D);
  background(0);
  
 leap = new LeapMotionP5(this);
 img = loadImage("top_black.png");
//  img2 = loadImage("drops-01.png");
//  img3 = loadImage("drops-02.png");

  vehicles = new ArrayList<Vehicle>();//Vehicle [arrayLength];
  vehicles2 = new ArrayList<Vehicle>();// new Vehicle [arrayLength2];

  flowfield = new FlowField(10);
  for (int i=0; i<arrayLength; i++) {
  vehicles.add(new Vehicle(new PVector((width/2), (height/2)),14, random(-1., 5.), color(#A6E04B)));
  }
  for (int i=0; i<arrayLength2; i++) {
   vehicles2.add(new Vehicle (new PVector((width/2), (height/2)),14 , random(-1, 5.), color(#2046D1)));
  }
}
void draw() {
  flowfield.init();
//background(0);
  // Display the flowfield in "debug" mode
  if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run(); 
    v.checkEdges();
  }
  for (Vehicle v : vehicles2) {
    v.follow(flowfield);
    v.run();
    v.checkEdges();
  }

image (img, 0,0);  
  fill(255);
  textSize(32);
  text(int(frameRate), 10, 60);

}

void keyPressed() {
//  if (key ==' ') {
//    debug = !debug;
//  }
}

