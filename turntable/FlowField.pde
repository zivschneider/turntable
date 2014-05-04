class FlowField {
  float t, x, y, f, a;
  float xoff, yoff;
  PVector center;
  int resolution;
  PVector[][] field;
  int cols, rows, flowBand;

  FlowField(int r) {
    resolution = r;
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    t = 0; //theta, angle around the circle
    xoff = width/2; //x pos of center of field
    yoff = height/2; //y pos of center of field
    center = new PVector(xoff, yoff);
    a = 300; //radius of the circular flowfield
    flowBand = 5; //this will make the size of the circular flow field bigger or smaller (cannot be zero)
    for (int i = 0; i <cols; i++) {
      for (int j=0; j < rows; j++) {
        field[i][j] = new PVector(0, 0);
      }
    } 
    initC();
  }

  void init() {
    while (t<TWO_PI) {
      t += .01;
      float x = cos(t)*a + xoff;
      float y = sin(t)*a + yoff;
      for (int i = 0; i <cols; i++) {
        for (int j=0; j < rows; j++) {
          int cx = i*resolution;
          int cy = j*resolution;
          //find the points in the flowfield that are in our band
          float d = dist(cx, cy, x, y);
          if (d<width/(cols/flowBand)) {
            field[i][j] = new PVector(cos(t+PI/2), sin(t+PI/2));
          }
        }
      }
    }
  }

  void initC() {
    for (int i = 0; i <cols; i++) {
      for (int j=0; j < rows; j++) {
        int cx = i*resolution;
        int cy = j*resolution;
        PVector cv = new PVector(cx, cy);
        cv.sub(center);
        if (cv.mag()<a) {
          //float angle = PVector.angleBetween(center, a);
          float angle = atan2(cy-center.y, cx-center.x);
          //println(i + "," + j + "," + angle);
          field[i][j] = new PVector(cos(angle+PI/2), sin(angle+PI/2));
        }
      }
    }
  }

  void display() { // Draw every vector
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //println(field[i][j].x + "," + field[i][j].y);
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    translate(x, y); // Translate to ation to render vector
    stroke(0, 100);
    rotate(v.heading()); // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    float len = v.mag()*scayl;  // Calculate length of vector & scale it to be bigger or smaller if necessary
    line(0, 0, len, 0);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }
}

