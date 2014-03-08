VideoBroadcastReceiver vbr;

void setup() {
  size(320, 240);
  vbr = new VideoBroadcastReceiver(320, 180, 9100);
}

 void draw() {
  background(0);

  vbr.getVideo();
  image(vbr.video,0,0);
}