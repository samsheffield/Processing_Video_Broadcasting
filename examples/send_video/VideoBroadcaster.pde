// Needed to use BufferedImage in Processing
import javax.imageio.*;
import java.awt.image.*; 

// Needed to use DatagramSocket in Processing
import java.io.*;
import java.net.*;

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

  void broadcast(PImage img) {
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