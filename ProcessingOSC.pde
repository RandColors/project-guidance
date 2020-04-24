import oscP5.*;
import netP5.*;

// DMX
import dmxP512.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;

float amp1,amp2,amp3,amp4,amp5,amp6;


//DMX
DmxP512 dmxOutput;
int universeSize=128;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;
String DMXPRO_PORT="COM4";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;


void setup(){
  size(400, 66);

  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  // PLUGS
  osc.plug(this, "newamps", "/amps");

  //DMX
  dmxOutput=new DmxP512(this, universeSize, false);

  if (LANBOX) {
    dmxOutput.setupLanbox(LANBOX_IP);
  }

  if (DMXPRO) {
    dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
  }
}


void draw(){
  //background(0);

  //fai la richiesta di dati a frameRate con .send
  OscMessage msg = new OscMessage("/getAmps");
  osc.send(msg, sc);

 // UI
 noStroke();

        // channel 1
   fill(153,255*amp1,0);
   rect(0,0,width/6,height*amp1);
   dmxOutput.set(1, int(amp1*255.0));

       // channel 2
   fill(153,255*amp2,0);
   rect(66,0,width/6,height*amp2);
   dmxOutput.set(2, int(amp2*255.0));

        // channel 3
   fill(153,255*amp3,0);
   rect(132,0,width/6,height*amp3);
   dmxOutput.set(3, int(amp3*255.0));

           // channel 4
   fill(153,255*amp4,0);
   rect(198,0,width/6,height*amp4);
   dmxOutput.set(4, int(amp4*255.0));

           // channel 5
   fill(153,255*amp5,0);
   rect(264,0,width/6,height*amp5);
   dmxOutput.set(5, int(amp5*255.0));

           // channel 6
   fill(153,255*amp6,0);
   rect(330,0,width/6,height*amp6);
   dmxOutput.set(6, int(amp6*255.0));
}

// funcction  to get the data and send them to the proper place.
void newamps(float rms1, float rms2, float rms3, float rms4, float rms5, float rms6){
   amp1 = rms1; amp2 = rms2; amp3 = rms3; amp4 = rms4; amp5 = rms5; amp6 = rms6;
   println("[",amp1,amp2,amp3,amp4,amp5,amp6,"]");
}
