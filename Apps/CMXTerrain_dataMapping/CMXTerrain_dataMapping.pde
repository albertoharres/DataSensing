PFont font;
DataEngineCMX engine;

String yesterday;

float timer_x = 80;

int simulation_time = 4 * 60 * 60;
int frame = 0;
int fMax = 10;
int fMin = 100;

float posY_0, posY_1, posY_2;
float posX;

void setup() {

  background(0);

  // Carregar dados
  engine = new DataEngineCMX();
  thread("loadDataEngineJSON");

  // Tipografia
  font = loadFont("FFFEstudio-8.vlw");
  textFont(font, 8);
  frameRate(1000);
}


void draw() {

  // background(0);

  // Checar status dos dados
  switch (engine.state) {
  case 0:
    drawLoading();
    break;
  case 1:
    drawVis();
    simulation_time += 2;
    simulation_time = simulation_time % (24 * 60 * 60);
    drawTimer();
    break;
  }
}

void drawLoading() {

  fill(255);

  DateFormat dt = DateFormat.getDateInstance(DateFormat.FULL, new Locale("pt", "br"));
  yesterday = dt.format(engine.calendar.getTime()).toUpperCase();

  int baseHeight = OFFSET + int(HEIGHT * SCALEFACTOR);

  // text(yesterday, 15, baseHeight - 55);
  //  text("NUM  " + engine.num_records, 15, baseHeight - 35);
  //text("ANTENAS  " + engine.num_cmx, 15, baseHeight - 15);
}

void drawTimer() {

  fill(255);

  int baseHeight = OFFSET + int(HEIGHT * SCALEFACTOR);

  if (simulation_time % (60 * 60) < 60 * 20) {
    //   text("USUARIOS", 15, baseHeight - 15);
    timer_x += (100 - timer_x) * 0.2;
  } else {
    timer_x += (15 - timer_x) * 0.2;
  }

  //text(getTime(simulation_time), timer_x, baseHeight - 15);
}

void drawVis() {

  // background(0);
  fill(255);

  // get first and only CMX
  UniqueCMX cmx = engine.cmxList.get(0);

  // update simulation time
  cmx.update(simulation_time);

  // show interpolated numbers

  int x = 50;
  int y = 25;

  //TESTE
  if (posX > width) {
    posX = 0;
  }
  posX++;


  posY_0 = MapValues(cmx.passerby, "PASSERBY");
  posY_1 = MapValues(cmx.visitors, "VISITORS");
  posY_2 = MapValues(cmx.connected, "CONNECTED");

  strokeWeight(2);
  stroke(255, 0, 0);
  point(posX, posY_0);

  stroke(0 ,255, 0);
  point(posX, posY_1);
  
  stroke(0, 0, 255);
  point(posX, posY_2);
  
  /* 
   text("USUARIOS CONECTADOS --- " + cmx.connected, x, y * 2);
   text("USUARIOS VISITANTES --- " + cmx.visitors,  x, y * 3);
   text("USUARIOS AO LONGE ----- " + cmx.passerby,  x, y * 4);
   */

  frame = (frame + 1) % (60 * 60 * 24);
}


String getTime(int unixtime) {

  DecimalFormat df = new DecimalFormat("00");

  int hours = floor(unixtime / (60 * 60));
  int minutes = floor(unixtime / 60) % 60;

  return df.format(hours) + "h" + df.format(minutes) + "m";
}


float MapValues(float dado, String type) {

  float max = 0;
  float value;
  float min;

  if (type == "PASSERBY") {
    max = 10000;
  } else 
  if (type == "VISITORS") {
    max = 1150;
  } else 
  if (type == "CONNECTED") {
    max = 85;
  }

  value = map(dado, 0, max, height, 0);

  return value;
}


// THREAD

void loadDataEngineJSON() {
  engine.loadJSON();
}

void mouseClicked() {
  background(0);
  posX= 0;
}