import java.awt.image.*; 
import javax.imageio.*;

// Needed to use DatagramSocket in Processing
import java.io.*;
import java.net.*;

class VideoBroadcastReceiver{
  int port; // Port we are receiving.
  DatagramSocket ds; 
  byte[] buffer = new byte[65536]; // A byte array to read into (max size of 65536, could be smaller)
  PImage video;
  boolean verbose;

  VideoBroadcastReceiver(int _videoWidth, int _videoHeight, int _port){
    port = _port;
    try {
      ds = new DatagramSocket(port);
    } catch (SocketException e) {
      e.printStackTrace();
    } 
      video = createImage(_videoWidth, _videoHeight,RGB);
  }

  void getVideo() {
    DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
    try {
      ds.receive(p);
    } catch (IOException e) {
      e.printStackTrace();
    } 
    byte[] data = p.getData();

    if(verbose) println("Received datagram with " + data.length + " bytes." );

    // Read incoming data into a ByteArrayInputStream
    ByteArrayInputStream bais = new ByteArrayInputStream( data );

    // We need to unpack JPG and put it in the PImage video
    video.loadPixels();
    try {
      // Make a BufferedImage out of the incoming bytes
      BufferedImage img = ImageIO.read(bais);
      // Put the pixels into the video PImage
      img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
    } catch (Exception e) {
      e.printStackTrace();
    }
    // Update the PImage pixels
    video.updatePixels();
  }
}