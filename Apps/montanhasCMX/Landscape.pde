


class Landscape {

  int scl;            // size of each cell
  int w, h;           // width and height of thingie
  int rows, cols;     // number of rows and columns
  float posX, posY;   // X and Y position of each line()
  int marginX = 20;   // margin X
  int marginY = 10;   // margin Y

  float zoff = 0.0;   // perlin noise argument
  float dataOut;      // data of perlin noise map
  float xoff, yoff;   // values for noise functin

  float[][] z;        // using an array to store all the height values 
  String type;        // ID of 3dnoise object
 
  Landscape(int scl_, int w_, int h_, String type_) {
    scl = scl_;
    w = w_;
    h = h_;
    type = type_;
    cols = w/scl;
    rows = h/scl;
    z = new float[cols][rows];

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        z[x][y] = 0;
      }
    }
  }

  // Calculate height values (based off a neural netork)
  void calculate() {

    // get first and only CMX
    UniqueCMX cmx = engine.cmxList.get(0);

    // update simulation time
    cmx.update(simulation_time);

    // mapear os valores;
    if (type == "PASSERBY") {
      dataOut =MapValues(cmx.passerby, "PASSERBY"); // Função passando o dado e o tipo
    }

    xoff = 0;
    for (int x = 0; x < cols; x++) {
      z[x][0] = map(noise(xoff, yoff), 0, 1, -dataOut, dataOut);
      xoff += 0.1;
    }
    yoff += 0.1;

    // outros valores
    // MapValues(cmx.visitors , "VISITORS");
    // MapValues(cmx.connected , "CONNECTED");

    /*
    // show interpolated numbers
     int inter_x = 50;
     int inter_y = 25;
     
     // DATA TEXT
     fill(255);
     
     text("USUARIOS CONECTADOS --- " + cmx.connected, inter_x, inter_y * 2);
     text("USUARIOS VISITANTES --- " + cmx.visitors, inter_x, inter_y * 3);
     text("USUARIOS AO LONGE ----- " + cmx.passerby, inter_x, inter_y * 4);
     */
  }



  void render() {

    background(0);

    // Change height of the camera with mouseY
    camera(0.0, height*2, 220.0, // eyeX, eyeY, eyeZ
      0.0, 0.0, 0.0, // centerX, centerY, centerZ
      0.0, 1.0, 0.0); // upX, upY, upZ

    translate(-width+100, -height/2+100, 100);

    for (int x = cols-1; x > 0; x--) {
      for (int y = rows-1; y > 0; y--) {  
        z[x][y] = z[x][y-1];
      }
    }

    posY = 0;
    for (int x = 1; x < cols-1; x++) {
      float jpos = 0;
      posY++; 
      posX = 0;
      for (int y = 1; y < rows-1; y++) {    
        posX++;
        jpos+= 0.01;
        strokeWeight(1);
        //point(posX*scl, posY*scl);

        stroke( 255*noise(jpos/1.0), 255-255*noise(jpos/1.0), 255);

        line(posX*scl,(posY)*scl, z[x][y], posX*scl+scl, (posY)*scl, z[x][y+1]);
      }
    }

    frame = (frame + 1) % (60 * 60 * 24);
    
    // Shader Blur
    filter(blur);
    filter(BLUR, 0.5);
  }
}