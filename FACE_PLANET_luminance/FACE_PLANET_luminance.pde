/**
 * Mirror 2 
 * by Daniel Shiffman. 
 *
 * Each pixel from the video source is drawn as a rectangle with size based on brightness.  
 */

import processing.video.*;
import controlP5.*;

// Size of each cell in the grid
int cellSize = 15;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;
//control P5 stuff
ControlP5 GUI;

//########## FLOWFIELD CODE START#########
boolean debug = false;

//PImage img;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;
//END####
float lumMid;
float d = 0;
float luminance=0;

void setup() {
  size(1280, 960);
  // Set up columns and rows
  cols = width / cellSize;
  rows = height / cellSize;
  //  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);

  // Start capturing the images from the camera
  video.start();  

  vehicles = new ArrayList<Vehicle>();
  //control p5 init values
  //  initGUI();
}



void draw() { 
  println(frameRate);
  if (video.available()) {

    flowfield = new FlowField(cellSize);
    video.read();
    video.loadPixels();
    background(255);



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
        if(luminance >high) high = luminance;
        if(luminance <low) low = luminance;
        lumMid = (high - low)/2;
        d = luminance - lumMid;
//        println(lumMid);
        float redAlpha = map(luminance, low, high, 0, 255);
        float blueAlpha = map(luminance, high, low, 0, 255);
        if (d<0 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(255, 0, 0, redAlpha)));
        }
        if (d>0 && frameCount%2==0) {
          vehicles.add(new Vehicle(new PVector(x, y), frameCount, 1, 0.3, color(0, 0, 255, blueAlpha)));
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
}


void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}
//
//void mouseDragged() {
//  vehicles.add(new Vehicle(new PVector(mouseX, mouseY), 3, 0.3));
//}
void initGUI() {
  GUI = new ControlP5(this);
  //  GUI.addSlider("band").setPosition(10, 10).setRange(0, 50);
  GUI.addSlider("redMid").setPosition(10, 30).setRange(-255, 255);
  GUI.addSlider("blueMid").setPosition(10, 50).setRange(-255, 255);
}

