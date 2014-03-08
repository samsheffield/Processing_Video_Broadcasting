import processing.video.*;

Capture cam;
VideoBroadcaster vb;

void setup() {
  size(320,240);
  vb = new VideoBroadcaster("127.0.0.1", 9100); // VideoBroadcaster needs an IP address and port for the remote computer

  String[] cameras = Capture.list();
  println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    println(i + ": " +cameras[i]);
  }

  // IMPORTANT: Choose a suitable webcam. I've chosen a low resolution setting (320 x 180) to reduce amount of data to send.
  cam = new Capture(this, cameras[6]);
  cam.start();
}

// Broadcast video as it becomes available from the webcam
void captureEvent( Capture c ) {
  c.read();
  vb.broadcast(c);
}

void draw() {
  image(cam,0,0);
}