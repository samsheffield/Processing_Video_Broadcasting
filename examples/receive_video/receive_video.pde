VideoBroadcastReceiver vbr;

void setup() {
  size(320, 240);
  vbr = new VideoBroadcastReceiver();
}

 void draw() {
  background(0);
  vbr.checkForImage();

  // Draw the image
  image(vbr.video,0,0);
}