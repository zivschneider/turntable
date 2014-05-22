import codeanticode.syphon.*;
PGraphics canvas;
PImage img;
SyphonServer server;
import processing.video.*;
import controlP5.*;
import processing.serial.*;

boolean takePic;
// Size of each cell in the grid
int cellSize = 15;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;
//control P5 stuff
ControlP5 GUI;
Serial myPort;

//########## FLOWFIELD CODE START#########
boolean debug = false;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

//END####
float lumInterval;
float d = 0;
float luminance=0;


void setup() {
  size(720, 480, P2D);
  img = loadImage("background-02.png");
  String portName = Serial.list()[11];
  myPort = new Serial(this, portName, 9600);

  /////bring in the flir cam
  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, width, height);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    } 
    video = new Capture(this, cameras[0]);
    video.start();
  }
  //// end of bring flir

  canvas = createGraphics(width, height, P2D);
  server = new SyphonServer(this, "Processing Syphon");
  // Set up columns and rows
  cols = width / cellSize;
  rows = height / cellSize;
  rectMode(CENTER);
  vehicles = new ArrayList<Vehicle>();
  takePic = false;
}



void draw() { 
  canvas.beginDraw();
  if (video.available()) {
    flowfield = new FlowField(cellSize);
    video.read();
    video.loadPixels();

    //    Display the flowfield in "debug" mode
    if (debug) flowfield.display();
    //    Tell all the vehicles to follow the flow field\
    float high = 0;
    float low = 255;
    float d = 0;
    float luminance=0;
    //Begin loop for columns
    for (int i = 0; i < cols;i++) {
      // Begin loop for rows
      for (int j = 0; j < rows;j++) {

        // Where are we, pixel-wise?
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        // Each rect is colored white with a size determined by brightness
        color c = video.pixels[loc];

        int count = 0;
        while (count <1000) count ++;
        if (c == 0.0) c = video.pixels[loc];
        //luminance
        int r = (c >> 16) & 0xff;
        int g = (c >> 8) & 0xff;
        int b = c & 0xff;
        luminance = 0.299*r+0.587*g+0.114*b;
        if (luminance >high) high = luminance;
        if (luminance <low) low = luminance;
        lumInterval = (high - low)/5;

        float redAlpha = map(luminance, low, high, 0, 255);
        float blueAlpha = map(luminance, high, low, 0, 255);
        if (luminance<lumInterval && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(13, 73, 206, blueAlpha)));
        }
        else if (luminance<lumInterval*2 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(94, 229, 239, redAlpha)));
        }
        else if (luminance<lumInterval*3 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(101, 186, 2, redAlpha)));
        }
        else if (luminance<lumInterval*4 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(249, 103, 38, redAlpha)));
        }
        else if (luminance<lumInterval*5 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(237, 217, 7, redAlpha)));
        }
      }
    }
  }

  for (int i=0; i<vehicles.size(); i++) {
    Vehicle v = vehicles.get(i);
    if (v.kill()) {
      vehicles.remove(i);
    }
    v.follow(flowfield);
    v.run();
  }
  canvas.endDraw();
  image(canvas, 0, 0);
  image(img, 0, 0);
  server.sendImage(canvas);
  if (takePic) {
    saveFrame("name-###.jpg");
    println("saving frame");
    takePic = false;
  }
}


void keyPressed() {

  if (key == 'p') {
    // debug = !debug;
    saveFrame("name-###.jpg");
    println("saving frame");
  }
}

void serialEvent (Serial myPort) {
  // get the byte:
  int inByte = myPort.read(); 
  if (inByte == 1) {
    takePic = true;
  }
}
