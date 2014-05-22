
class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  //  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = video.width/resolution;
    rows = video.height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  void init() {
    if (video.available()) {
      float d = 0;
      float luminance=0;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          field[i][j] = new PVector(video.width/2-i*resolution, video.height/2-j*resolution);
          field[i][j].normalize();
        }
      }
// Begin loop for columns
      for (int i = 0; i < cols-1;i++) {
        // Begin loop for rows
        for (int j = 0; j < rows-1;j++) {

 // Where are we, pixel-wise?
          int x = i*resolution;
          int y = j*resolution;
          int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

// Each rect is colored white with a size determined by brightness
          color c = video.pixels[loc];
          int r = (c >> 16) & 0xff;
          int g = (c >> 8) & 0xff;
          int b = c & 0xff;
          luminance = 0.299*r+0.587*g+0.114*b;
          float theta = map(luminance, 0, 255, 0, TWO_PI);

// Polar to cartesian coordinate transformation to get x and y components of the vector
          field[i][j] = PVector.fromAngle(theta);
          field[i][j].normalize();
       
        }
      }
    }
  }

// Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }

// Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
// Translate to location to render vector
    translate(x, y);
    strokeWeight(1);
    stroke(255, 0, 0);
// Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
// Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
 // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }
}
