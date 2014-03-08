VideoBroadcastReceiver vbr;

void setup() {
  size(320, 240);
  vbr = new VideoBroadcastReceiver(320, 240, 9100); // VideoBroadcastReceiver needs the width and height of the incoming video and the port it is receiving on.
}

 void draw() {
  background(0);

  vbr.getVideo(); // Grab the incoming video frame
  image(vbr.video,0,0);
}