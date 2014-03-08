import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 
import javax.imageio.*; 
import java.awt.image.*; 
import java.io.*; 
import java.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class send_video extends PApplet {



Capture cam;
VideoBroadcaster vb;

public void setup() {
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

public void captureEvent( Capture c ) {
  c.read();
  // Whenever we get a new image, send it!
  vb.broadcast(c);
}

public void draw() {
  image(cam,0,0);
}
// Needed to use BufferedImage in Processing

 

// Needed to use DatagramSocket in Processing



class VideoBroadcaster{
  int remotePort = 9100;
  DatagramSocket ds; 

  VideoBroadcaster(){
    try {
      ds = new DatagramSocket();
    } 
    catch (SocketException e) {
      e.printStackTrace();
    }
  }

  public void broadcast(PImage img) {
    // We need a buffered image to do the JPG encoding
    BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

    // Transfer pixels from localFrame to the BufferedImage
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

    // Need these output streams to get image as bytes for UDP communication
    ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
    BufferedOutputStream bos    = new BufferedOutputStream(baStream);

    // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
    // Requires try/catch
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // Get the byte array, which we will send out via UDP!
    byte[] packet = baStream.toByteArray();

    // Send JPEG data as a datagram
    println("Sending datagram with " + packet.length + " bytes");
    try {
      ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("localhost"), remotePort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "send_video" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
