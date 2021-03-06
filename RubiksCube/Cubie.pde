import java.util.Arrays;
class Cubie {

  int nCols = 0;
  float x = 0;
  float y = 0;
  float z = 0;
  PMatrix3D matrix;
  String[] colourNames = {"Orange", "Red", "Yellow", "White", "Green", "Blue"};
  color[] colours = new color[6];
  Face[] faces = new Face[6];

  // create new cubie with 6 faces
  Cubie(PMatrix3D m, float x, float y, float z) {
    matrix = m;
    this.x = x;
    this.y = y;
    this.z = z;
    // Sets colour for each face of the cube dependant on their position on the cube and whether certain faces are visible
    colours[0] = x ==  axis  ?  orange : black;
    colours[1] = x == -axis  ?  red    : black;
    colours[2] = y == -axis  ?  yellow : black;
    colours[3] = y ==  axis  ?  white  : black;
    colours[4] = z ==  axis  ?  green  : black;
    colours[5] = z == -axis  ?  blue   : black;
    for (color c : colours) {
      nCols += c != black ? 1 : 0;
    }
    setColoursGray();

    // Sets each face to their required colours
    faces[0] = new Face(new PVector(1, 0, 0), colours[0]); // Orange / Right
    faces[1] = new Face(new PVector(-1, 0, 0), colours[1]); // Red   / Left
    faces[2] = new Face(new PVector(0, -1, 0), colours[2]); // Yellow / Up
    faces[3] = new Face(new PVector(0, 1, 0), colours[3]); // White  / Down
    faces[4] = new Face(new PVector(0, 0, 1), colours[4]); // Green  / Front
    faces[5] = new Face(new PVector(0, 0, -1), colours[5]); // Blue   / Back
  }

  // Cloning Cubie constructor
  Cubie(Cubie c)  {
    matrix = c.matrix;
    x = c.x;
    y = c.y;
    z = c.z;
    colours = c.colours;
    for(int i = 0; i < faces.length; i++) {
      faces[i] = new Face(c.faces[i]);
    }
  }
  
  Cubie(){};

  void show() {
    noFill();
    noStroke();
    strokeWeight(0.2 / dim);
    push();
      applyMatrix(matrix);
      box(1);
      for (int i = 0; i < faces.length; i++) {
        faces[i].c = colours[i];
        faces[i].show();
      }
    pop();
  }

  void update(float x, float y, float z) {
    matrix.reset();
    matrix.translate(x, y, z);
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void setValue(String s) {
    println("Setting val");
    for(int i = 0; i < 6; i++) {
      faces[i].setValue(s);
    }
  }
  
  void setColoursGray() {
    if(graycube)  {
      for(int i = 0; i < colours.length; i++) {
        colours[i] = grey;
      }
    }
    if(cornersOnly) {
      int colCounter = 0;
      for(int i = 0; i < colours.length; i++) {
        colCounter += colours[i] != black ? 1 : 0;
      }
      if(colCounter != 3) {
        for(int i = 0; i < colours.length; i++) {
          colours[i] = grey;
        }
      }
    }
    if(edgesOnly) {
      int colCounter = 0;
      for(int i = 0; i < colours.length; i++) {
        colCounter += colours[i] != black ? 1 : 0;
      }
      if(colCounter != 2) {
        for(int i = 0; i < colours.length; i++) {
          colours[i] = grey;
        }
      }
    }
    if(centersOnly) {
      int colCounter = 0;
      for(int i = 0; i < colours.length; i++) {
        colCounter += colours[i] != black ? 1 : 0;
      }
      if(colCounter != 1) {
        for(int i = 0; i < colours.length; i++) {
          colours[i] = grey;
        }
      }
    }
  }
  boolean mouseIsOver() {
    return false;
  }
  
  Cubie copy()  {
    Cubie copy = new Cubie();
    copy.matrix = matrix;
    copy.x = x;
    copy.y = y;
    copy.z = z;
    copy.colours = colours.clone();
    copy.nCols = nCols;
    return copy;
  }

  // Responsible for turning the faces of the cubies
  void turnFace(char axisFace, int dir) {
    float angle = dir * HALF_PI;
    for (Face f : faces) {
      f.turn(axisFace, angle);
    }
  }

  // Responsible for changing where colours are on each cubie ready for repositioning on cube.
  void turn(char axisFace, int dir) {

    color[] newColours = colours.clone();
    if (dir == 1) {
      turn(axisFace, -1); 
      turn(axisFace, -1); 
      turn(axisFace, -1);
      return;
    } else if(dir == 2) {
      turn(axisFace, -1);
      turn(axisFace, -1);
      return;
    }

    switch(axisFace) {
    case 'X':
      newColours[2] = colours[4]; // U becomes F
      newColours[4] = colours[3]; // F becomes D
      newColours[3] = colours[5]; // D becomes B
      newColours[5] = colours[2]; // B becomes U
      break;
    case 'Y':
      newColours[1] = colours[5]; // L becomes B
      newColours[5] = colours[0]; // B becomes R
      newColours[0] = colours[4]; // R becomes F
      newColours[4] = colours[1]; // F becomes L
      break;
    case 'Z':
      newColours[2] = colours[0]; // U becomes R
      newColours[0] = colours[3]; // R becomes D
      newColours[3] = colours[1]; // D becomes L
      newColours[1] = colours[2]; // L becomes U
      break;
    }
    
    colours = newColours.clone();
  }

  char getFace(color c) {
    for (int i = 0; i < colours.length; i++) {
      if (colours[i] == c) {
        String faces = "RLUDFB";
        return faces.charAt(i);
      }
    }
    return  ' ';
  }

  // Returns the colour of this cubie's face
  color getFaceColour() {
    for (color c : colours) {
      if (c != black) {
        return c;
      }
    }
    return black;
  }

  // Checks if two colours match
  boolean matchesColours(color[] colourNames) {
    if (nCols != colourNames.length) return false;
    for (color c : colourNames) {
      boolean foundMatch = false;
      for (color b : colours) {
        if (b == c) {
          foundMatch = true;
          break;
        }
      }
      if (!foundMatch)  return false;
    }
    return true;
  }

  // Cubie details - for debugging
  String details()  {
    return x + "\t" + y + "\t" + z + "\n"
                    + "\tFace [0]\t" + colToString(colours[0]) + "\n"
                    + "\tFace [1]\t" + colToString(colours[1]) + "\n"
                    + "\tFace [2]\t" + colToString(colours[2]) + "\n"
                    + "\tFace [3]\t" + colToString(colours[3]) + "\n"
                    + "\tFace [4]\t" + colToString(colours[4]) + "\n"
                    + "\tFace [5]\t" + colToString(colours[5]);
  }

  color getRight() {
    return colours[0];
  }

  color getLeft()  {
    return colours[1];
  }

  color getTop()  {
    return colours[2];
  }

  color getDown()  {
    return colours[3];
  }

  color getFront()  {
    return colours[4];
  }

  PVector getPosition() {
    return new PVector(x, y, z);
  }
  color getBack()  {
    return colours[5];
  }

  color[] getEachColour() {
    return this.colours;
  }

  String[] getEachColourName() {
    return this.colourNames;
  }

  @Override
  boolean equals(final Object other)  {
    if(!(other instanceof Cubie)) {
          return false;
        }
    Cubie c = (Cubie) other;
    return c.x == this.x && c.y == this.y && c.z == this.z && Arrays.equals(colours, c.colours);
  }

  boolean sameColoursAs(final Object other) {
    if(!(other instanceof Cubie)) {
      return false;
    }
    Cubie c = (Cubie) other;
    return Arrays.equals(colours, c.colours);
  }

}
