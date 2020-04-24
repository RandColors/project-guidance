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
  osc.plug(this, "newamp1", "/amp1"); 
  osc.plug(this, "newamp2", "/amp2"); 
  osc.plug(this, "newamp3", "/amp3"); 
  osc.plug(this, "newamp4", "/amp4"); 
  osc.plug(this, "newamp5", "/amp5"); 
  osc.plug(this, "newamp6", "/amp6"); 
  
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
  OscMessage msg1 = new OscMessage("/getamp1");
  osc.send(msg1, sc);
  
  OscMessage msg2 = new OscMessage("/getamp2");
  osc.send(msg2, sc);
  
  OscMessage msg3 = new OscMessage("/getamp3");
  osc.send(msg3, sc);
  
  OscMessage msg4 = new OscMessage("/getamp4");
  osc.send(msg4, sc);
  
  OscMessage msg5 = new OscMessage("/getamp5");
  osc.send(msg5, sc);
  
  OscMessage msg6 = new OscMessage("/getamp6");
  osc.send(msg6, sc);
  
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



// funcctions  to get the data and send them to the proper place.
void newamp1(float rms){
   amp1 = rms;
   println(amp1);
}

void newamp2(float rms){
   amp2 = rms;
  // println(amp2);
}

void newamp3(float rms){
   amp3 = rms;
  // println(amp3);
}

void newamp4(float rms){
   amp4 = rms;
  // println(amp4);
}

void newamp5(float rms){
   amp5 = rms;
  // println(amp5);
}

void newamp6(float rms){
   amp6 = rms;
  // println(amp6);
}
