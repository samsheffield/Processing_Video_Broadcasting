import processing.video.*;

Capture cam;
VideoBroadcaster vb;

void setup() {
  size(320,240);
  vb = new VideoBroadcaster();

  String[] cameras = Capture.list();
  println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    println(i + ": " +cameras[i]);
  }

  cam = new Capture(this, cameras[6]);
  cam.start();
}

void captureEvent( Capture c ) {
  c.read();
  vb.broadcast(c);
}

void draw() {
  image(cam,0,0);
}