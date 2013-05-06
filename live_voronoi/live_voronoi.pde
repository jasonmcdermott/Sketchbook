
// You'll need to add this file to your Processing Sketch Folder; http://www.leebyron.com/else/mesh/mesh-0002.zip
// Also look at Lee Byron's library page for more examples; http://www.leebyron.com/else/mesh/

import megamu.mesh.*;
ArrayList vpoints = new ArrayList();
boolean dragged;
PFont font;

Voronoi myVoronoi;
float[][] points = new float[11][2];
int b = 10;
int e = 50;
float cols;

void setup() {
  smooth();
  // font = createFont("Gotham Rounded",24);
  // textFont(font);
  size(1000,700);  


  for (int i=0;i<2;i++) {
    vpoints.add(new vPoint(1,random(0,b),random(0,height)));
    vpoints.add(new vPoint(1,random(width-b,width),random(0,height)));

    vpoints.add(new vPoint(1,random(0,width),random(0,b)));
    vpoints.add(new vPoint(1,random(0,width),random(height-b,height)));
  }

  points = new float[vpoints.size()][2];
  cols = 255/vpoints.size();
  vpoints.add(new vPoint(0,width/2,height/2));
}

void draw() {
  background(255);
  noFill();
  points = new float[vpoints.size()][2];

  for (int i=vpoints.size()-1;i>0;i--) {
    vPoint v = (vPoint) vpoints.get(i);
    v.update();
    PVector temp = v.loc;
    points[i][0] = temp.x;
    points[i][1] = temp.y;
  }
  


  myVoronoi = new Voronoi( points );
  MPolygon[] myRegions = myVoronoi.getRegions();

  for(int i=0; i<myRegions.length; i++) {
    float[][] regionCoordinates = myRegions[i].getCoords();
    fill(i*cols);
    stroke(0);
    myRegions[i].draw(this); // draw this shape
  }

  for (int i=vpoints.size()-1;i>0;i--) {
    vPoint v = (vPoint) vpoints.get(i);
    v.update();
    v.render();
  }

  dragged = false;

  text(" Press 'a' to add a new Voronoi point \n Press 's' to remove the last one",20,20);
  text(" You can move each point by using the mouse",20,60);  
}

void mouseDragged() {
  dragged = true;
}

void keyPressed() {

  if (key == 'a') {
    vpoints.add(new vPoint(0,mouseX,mouseY));
  }
  else if (key == 's') {
    vpoints.remove(vpoints.size()-1);
  }
}


class vPoint { 

  PVector loc, mid,v3;
  boolean hover = false;
  boolean mDown = false;


  vPoint (int type, float x_, float y_) {
    loc = new PVector(x_,y_);
    mid = new PVector(width/2,height/2);
  }

  void update() {

    PVector v1 = new PVector(mouseX, mouseY, 0);
    float d = v1.dist(loc);
    v3 = PVector.sub(loc, mid);
    if (dragged) {
      mDown = true;
      if (d < 40) {
        hover = true;
      }
    } 
    if (hover) {
      loc = new PVector(mouseX, mouseY);
    }
    hover = false;
  } 

  void render() {
    stroke(0);
    noFill();
    ellipse(loc.x,loc.y,5,5);
  }
}

