
import oscP5.*;
import netP5.*;


OscP5 osc;
NetAddress sc;

float amp1,amp2,amp3,amp4,amp5,amp6;




void setup(){
  size(420, 66);

  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  // PLUGS
  osc.plug(this, "newamps", "/amps");

 
}


void draw(){
  background(0);

  //fai la richiesta di dati a frameRate con .send
  OscMessage msg = new OscMessage("/getAmps");
  osc.send(msg, sc);

 // UI
 //noStroke();
 strokeWeight(0.1);
 

   // channel 1
  fill(153, 255*amp1, 0);
  rect(0, 0, width/6, height*amp1);

  // channel 2
  
  fill(153, 255*amp2, 0);
  rect(70, 0, width/6, height*amp2);

  // channel 3
  fill(153, 255*amp3, 0);
  rect(140, 0, width/6, height*amp3);

  // channel 4
  fill(153, 255*amp4, 0);
  rect(210, 0, width/6, height*amp4);

  // channel 5
  fill(153, 255*amp5, 0);
  rect(280, 0, width/6, height*amp5);

  // channel 6
  fill(153, 255*amp6, 0);
  rect(350, 0, width/6, height*amp6);

}

// funcction  to get the data and send them to the proper place.
void newamps(float rms1, float rms2, float rms3, float rms4, float rms5, float rms6){
   amp1 = rms1; amp2 = rms2; amp3 = rms3; amp4 = rms4; amp5 = rms5; amp6 = rms6;
   println("[",amp1,amp2,amp3,amp4,amp5,amp6,"]");
}
