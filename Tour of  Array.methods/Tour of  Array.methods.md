    ## Tour of  Array.methods ##
I'm moving the first steps to see how and what I could do with 6 lights.
I thought that the first thing to do it was to explore some array methods.
If you like to try by yourself you could run the processingOSCnodimmer to visualize the envelopes/animations.
If you know some nice concatenations of methods it' would be a plasure to try it out
 

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
    
      //ask data at frameRate with .send
      OscMessage msg = new OscMessage("/getAmps");
      osc.send(msg, sc);
    
     // UI
     noStroke();
    
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
    

Then if you need to use it with a   dimmer just go on github https://github.com/RandColors/project-guidance/tree/master/ProcessingOSC and run the "ProcessingOSC.pde" file in Processing
https://processing.org/

in SC: 
Run 
- setup.scd
- sketches.scd




if you like to make .gif files from your pattern, here the code:


    import gifAnimation.*;
    import oscP5.*;
    import netP5.*;
    
    GifMaker gifExport;
    int frames = 0;
    
    OscP5 osc;
    NetAddress sc;
    
    float amp1, amp2, amp3, amp4, amp5, amp6;
    
    public void setup() {
    frameRate(60);
      smooth();
      size(420, 66);
     
      osc = new OscP5(this, 12321);
      sc = new NetAddress("127.0.0.1", 57120);
      osc.plug(this, "newamps", "/amps");
      osc.plug(this, "startrec", "/startrec");
      osc.plug(this, "stoprec", "/stoprec");
     
    
      noFill();
      stroke(0);
      strokeWeight(20);
     
      gifExport = new GifMaker(this, "export.gif", 100);
    }
    
    void draw() {
    
      background(255);
    
      background(0);
    
      //ask data at frameRate using .send
      OscMessage msg = new OscMessage("/getAmps");
      osc.send(msg, sc);
    
      // UI
      noStroke();
    
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
    
      if (gifExport != null) {
    gifExport.setDelay(20);
    gifExport.addFrame();
    frames++;
      }
    }
    
    void newamps(float rms1, float rms2, float rms3, float rms4, float rms5, float rms6) {
      amp1 = rms1;
      amp2 = rms2;
      amp3 = rms3;
      amp4 = rms4;
      amp5 = rms5;
      amp6 = rms6;
      println("[", amp1, amp2, amp3, amp4, amp5, amp6, "]");
    }
    
    void startrec(String s) {
      gifExport = new GifMaker(this, "export.gif", 100);
      gifExport.setRepeat(0); // make it an "endless" animation
      println("----------- start " + s);
    }
    
    void stoprec(String s) {
      gifExport.finish();
      exit();
      println("----------- stop " + s);
    }
    
// replace the pattern in p 

       // Start/
    (
    p = Pbindef(\forward,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    	\bus,Pseq((0..5).stutter(4),1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/8],inf),
    \finish, ~beatsToSeconds
    );
    )
    
    (
    var lightsAddr = ~lightsAddr;
    
    Pfset(
    	func:{lightsAddr.sendMsg('/startrec',"startrec".postln)},
    	pattern:p ,
    	cleanupFunc:{lightsAddr.sendMsg('/stoprec',"stoprec".postln)}
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    p.play(~metro.base ,quant:~metro.base.beatsPerBar);


## first things first, default words: ##

Definition of a "word" in this context.
- a word is made by a sequence.
- a word need an Envelope. 
- a word has a non inf duration.
    
Dictionary of seqs
Dictionary of Envelope
Dictionary of duration
Dictionary of words
Dictionary of phrases(Pdict? .. see how.. ?!)

    




    Pbindef(\forward,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5),inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[~dEnv[\perc]]
    ],inf),
    	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\forward).stop;
    Pbindef(\forward).clear;
    
    
    (
    Pbindef(\reverse,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5).reverse,inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\reverse).stop;
    Pbindef(\reverse).clear;
    
    
    (
    Pbindef(\palindromo,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5).mirror1,inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\palindromo).stop;
    Pbindef(\palindromo).clear;
    
    
    (
    // a scrambled array sequenced,  repeted over and over
    Pbindef(\scramble,
    \instrument, \DcOuts,
    	\legato,1,
    	\stretch,4,
    \bus,Pseq((0..5).scramble,inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\scramble).stop;
    Pbindef(\scramble).clear;
    
    
    // all togheter 
    (
    Pbindef(\tutti,
    \instrument, \DcOuts,
    	\legato,1,
    	\stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc],
    [Env.perc(0.999,0.001,1,4)]
    ],inf),
    \dur, Pseq(1++(1/2!2)++(1/4!2),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\tutti).stop
    Pbindef(\tutti).clear

	


## more methods

if you would like to plot the array manipuleted just to have another graphic way to understand what is going on.

    ~aplot = [0,2,3,2,1,0.4].plot;
    i = Image.fromWindow(~aplot.parent, ~aplot.interactionView.bounds);
    i.write("~/desktop/test.png".standardizePath);
    i.free;
    
**.powerset
Returns all possible combinations of the array's elements.**

    
    (0..5).powerset.postln;
[ [  ], [ 0 ], [ 1 ], [ 0, 1 ], [ 2 ], [ 0, 2 ], [ 1, 2 ], [ 0, 1, 2 ], [ 3 ], [ 0, 3 ], [ 1, 3 ], [ 0, 1, 3 ], [ 2, 3 ], [ 0, 2, 3 ], [ 1, 2, 3 ], [ 0, 1, 2, 3 ], [ 4 ], [ 0, 4 ], [ 1, 4 ], [ 0, 1, 4 ], [ 2, 4 ], [ 0, 2, 4 ], [ 1, 2, 4 ], [ 0, 1, 2, 4 ], [ 3, 4 ], [ 0, 3, 4 ], [ 1, 3, 4 ], [ 0, 1, 3, 4 ], [ 2, 3, 4 ], [ 0, 2, 3, 4 ], [ 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4 ], [ 5 ], [ 0, 5 ], [ 1, 5 ], [ 0, 1, 5 ], [ 2, 5 ], [ 0, 2, 5 ], [ 1, 2, 5 ], [ 0, 1, 2, 5 ], [ 3, 5 ], [ 0, 3, 5 ], [ 1, 3, 5 ], [ 0, 1, 3, 5...etc...



    (0..5).powerset.sort({ |a, b| a.size > b.size }); // sort by size, big first
[ [ 0, 1, 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 0, 2, 3, 4, 5 ], [ 0, 1, 3, 4, 5 ], [ 0, 1, 2, 4, 5 ], [ 0, 1, 2, 3, 5 ], [ 0, 1, 2, 3, 4 ], [ 2, 3, 4, 5 ], [ 1, 3, 4, 5 ], [ 0, 3, 4, 5 ], [ 1, 2, 4, 5 ], [ 0, 2, 4, 5 ], [ 0, 1, 4, 5 ], [ 1, 2, 3, 5 ], [ 0, 2, 3, 5 ], [ 0, 1, 3, 5 ], [ 0, 1, 2, 5 ], [ 1, 2, 3, 4 ], [ 0, 2, 3, 4 ], [ 0, 1, 3, 4 ], [ 0, 1, 2, 4 ], [ 0, 1, 2, 3 ], [ 3, 4, 5 ], [ 2, 4, 5 ], [ 1, 4, 5 ], [ 0, 4, 5 ], [ 2, 3, 5 ], [ 1, 3, 5 ], [ 0, 3, 5 ], [ 1, 2, 5 ], [ 0, 2, 5 ], [ 0, 1, 5 ], [ 2,...etc...



    (0..5).powerset.sort({ |a, b| a.size > b.size }).reverse; // by size, small first
[ [  ], [ 0 ], [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 0, 1 ], [ 0, 2 ], [ 1, 2 ], [ 0, 3 ], [ 1, 3 ], [ 2, 3 ], [ 0, 4 ], [ 1, 4 ], [ 2, 4 ], [ 3, 4 ], [ 0, 5 ], [ 1, 5 ], [ 2, 5 ], [ 3, 5 ], [ 4, 5 ], [ 0, 1, 2 ], [ 0, 1, 3 ], [ 0, 2, 3 ], [ 1, 2, 3 ], [ 0, 1, 4 ], [ 0, 2, 4 ], [ 1, 2, 4 ], [ 0, 3, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ], [ 0, 1, 5 ], [ 0, 2, 5 ], [ 1, 2, 5 ], [ 0, 3, 5 ], [ 1, 3, 5 ], [ 2, 3, 5 ], [ 0, 4, 5 ], [ 1, 4, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ], [ 0, 1, 2, 3 ], [ 0, 1, 2, 4 ], [ 0, 1, 3, 4 ], [ 0,...etc...



**.pyramid(patternType: 1)
Return a new Array whose elements have been reordered via one of 10 "counting" algorithms. Run the examples to see the algorithms.**

    (
    10.do({ arg i;
    	(0..5).pyramid(i + 1).postcs;
    });
    )

[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5 ]

[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5 ]

[ 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0 ]

[ 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ]

[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0 ]

[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ]

[ 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5 ]

[ 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5 ]

[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ]

[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0 ]

**
.pyramidg(patternType: 1)
Like pyramid, but keep the resulting values grouped in subarrays**

    (
      10.do({ arg i;
    (0..5).pyramidg(i + 1).postcs;
      });
    )
    

// 6
[ [ 0 ], [ 0, 1 ], [ 0, 1, 2 ], [ 0, 1, 2, 3 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4, 5 ] ]

// 6
[ [ 5 ], [ 4, 5 ], [ 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4, 5 ] ]

// 6
[ [ 0, 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3 ], [ 0, 1, 2 ], [ 0, 1 ], [ 0 ] ]

// 6
[ [ 0, 1, 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 3, 4, 5 ], [ 4, 5 ], [ 5 ] ]

// 11
[ [ 0 ], [ 0, 1 ], [ 0, 1, 2 ], [ 0, 1, 2, 3 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3 ], [ 0, 1, 2 ], [ 0, 1 ], [ 0 ] ]


// 11
[ [ 5 ], [ 4, 5 ], [ 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 3, 4, 5 ], [ 4, 5 ], [ 5 ] ]

// 11
[ [ 0, 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3 ], [ 0, 1, 2 ], [ 0, 1 ], [ 0 ], [ 0, 1 ], [ 0, 1, 2 ], [ 0, 1, 2, 3 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4, 5 ] ]

// 11
[ [ 0, 1, 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 3, 4, 5 ], [ 4, 5 ], [ 5 ], [ 4, 5 ], [ 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4, 5 ] ]


// 11
[ [ 0 ], [ 0, 1 ], [ 0, 1, 2 ], [ 0, 1, 2, 3 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 3, 4, 5 ], [ 4, 5 ], [ 5 ] ]


// 11
[ [ 5 ], [ 4, 5 ], [ 3, 4, 5 ], [ 2, 3, 4, 5 ], [ 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4, 5 ], [ 0, 1, 2, 3, 4 ], [ 0, 1, 2, 3 ], [ 0, 1, 2 ], [ 0, 1 ], [ 0 ] ]





**.slide(windowLength: 3, stepSize: 1)
Return a new Array whose elements are repeated subsequences from the receiver. Easier to demonstrate than explain.**


(0..5).slide(2, 1).asCompileString.postln;
[ 0, 1, 1, 2, 2, 3, 3, 4, 4, 5 ]


(0..5).slide(3, 1).asCompileString.postln;
[ 0, 1, 2, 1, 2, 3, 2, 3, 4, 3, 4, 5 ]

(0..5).slide(4, 1).asCompileString.postln;
[ 0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5 ]

(0..5).slide(5, 1).asCompileString.postln;
[ 0, 1, 2, 3, 4, 1, 2, 3, 4, 5 ]


(0..5).slide(1, 2).asCompileString.postln;
[ 0, 2, 4 ]


(0..5).slide(3, 2).asCompileString.postln;
[ 0, 1, 2, 2, 3, 4 ]

(0..5).slide(4, 2).asCompileString.postln;
[ 0, 1, 2, 3, 2, 3, 4, 5 ]

(0..5).slide(5, 2).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]


(0..5).slide(1, 3).asCompileString.postln;
[ 0, 3 ]

(0..5).slide(2, 3).asCompileString.postln;
[ 0, 1, 3, 4 ]


(0..5).slide(4, 3).asCompileString.postln;
[ 0, 1, 2, 3 ]
(0..5).slide(5, 3).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]
(0..5).slide(6, 3).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]



(0..5).slide(1, 4).asCompileString.postln;
[ 0, 4 ]

(0..5).slide(2, 4).asCompileString.postln;
[ 0, 1, 4, 5 ]

(0..5).slide(3, 4).asCompileString.postln;
[ 0, 1, 2 ]

(0..5).slide(4, 4).asCompileString.postln;
[ 0, 1, 2, 3 ]
(0..5).slide(5, 4).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]
(0..5).slide(6, 4).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]


(0..5).slide(1, 5).asCompileString.postln;
[ 0, 5 ]
(0..5).slide(2, 5).asCompileString.postln;
[ 0, 1 ]
(0..5).slide(3, 5).asCompileString.postln;
[ 0, 1, 2 ]
(0..5).slide(4, 5).asCompileString.postln;
[ 0, 1, 2, 3 ]
(0..5).slide(5, 5).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]
(0..5).slide(6, 5).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]


**.mirror2
Return a new Array which is the receiver concatenated with a reversal of itself. The center element is duplicated. The receiver is unchanged.**

    (0..5).mirror2
[ 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0 ]


**
.stutter(n: 2)
Return a new Array whose elements are repeated n times. The receiver is unchanged.**

(0..5).stutter(2).postln;
[ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5 ]

(0..5).stutter(3).postln;
[ 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5 ]

(0..5).stutter(4).postln;
[ 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5 ]


(0..5).stutter(2).postln;
[ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5 ]


.sputter(probability: 0.25, maxlen: 100)
Return a new Array of length maxlen with the items partly repeated (random choice of given probability).
// compare:

    10.do{(0..5).sputter(0.1, 6).postln;};
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 4 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 4 ]
[ 0, 1, 2, 3, 3, 4 ]


    10.do{(0..5).sputter(0.1, 100).postln;};
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 3, 3, 4, 5, 5 ]
[ 0, 0, 1, 2, 2, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 5 ]
[ 0, 1, 1, 2, 2, 3, 4, 5 ]
[ 0, 1, 1, 2, 3, 4, 5 ]



    10.do{(0..5).sputter(0.2, 6).postln;};
[ 0, 1, 2, 3, 4, 4 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 3 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 3 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 4 ]
[ 0, 1, 2, 2, 3, 4 ]



    10.do{(0..5).sputter(0.2, 100).postln;};
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 5 ]
[ 0, 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 3, 4, 5 ]
[ 0, 1, 1, 2, 3, 3, 4, 4, 5 ]
[ 0, 1, 1, 2, 3, 3, 4, 5 ]
[ 0, 0, 1, 2, 3, 3, 4, 5, 5 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 1, 2, 3, 4, 5 ]



    10.do{(0..5).sputter(0.3, 6).postln;};
[ 0, 1, 2, 3, 3, 4 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 0, 1, 1, 2, 3 ]
[ 0, 1, 2, 3, 3, 3 ]
[ 0, 0, 1, 2, 2, 3 ]
[ 0, 0, 1, 2, 3, 4 ]
[ 0, 1, 2, 3, 4, 5 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 1, 1, 1, 2, 3 ]
[ 0, 1, 1, 2, 2, 3 ]


    10.do{(0..5).sputter(0.3, 100).postln;};
[ 0, 1, 2, 2, 3, 4, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 5, 5 ]
[ 0, 0, 1, 2, 3, 3, 4, 4, 5 ]
[ 0, 0, 1, 1, 1, 2, 3, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5 ]
[ 0, 1, 1, 2, 3, 4, 5, 5 ]
[ 0, 1, 2, 3, 3, 4, 5, 5, 5 ]
[ 0, 0, 1, 1, 2, 3, 4, 5, 5, 5 ]
[ 0, 0, 1, 2, 3, 3, 4, 4, 5 ]
[ 0, 0, 1, 2, 3, 4, 5 ]




    10.do{(0..5).sputter(0.4, 6).postln;};
[ 0, 0, 1, 1, 1, 1 ]
[ 0, 0, 1, 2, 2, 2 ]
[ 0, 0, 0, 0, 1, 2 ]
[ 0, 1, 2, 3, 3, 3 ]
[ 0, 0, 0, 0, 1, 2 ]
[ 0, 1, 2, 2, 3, 4 ]
[ 0, 1, 2, 3, 3, 4 ]
[ 0, 0, 1, 1, 2, 3 ]
[ 0, 0, 1, 1, 2, 3 ]
[ 0, 1, 1, 2, 2, 3 ]
    
    10.do{(0..5).sputter(0.4, 100).postln;};
[ 0, 0, 1, 2, 2, 3, 4, 5 ]
[ 0, 0, 0, 1, 2, 2, 3, 4, 4, 5, 5 ]
[ 0, 1, 2, 3, 3, 4, 5 ]
[ 0, 1, 1, 2, 3, 3, 4, 5, 5 ]
[ 0, 1, 2, 3, 3, 4, 4, 5, 5 ]
[ 0, 0, 0, 0, 1, 2, 3, 3, 4, 5, 5 ]
[ 0, 0, 0, 0, 0, 1, 1, 2, 3, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 4, 5 ]
    
    
    10.do{(0..5).sputter(0.5, 6).postln;};
[ 0, 0, 0, 1, 1, 2 ]
[ 0, 1, 2, 2, 3, 3 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 1, 1, 1, 1 ]
[ 0, 0, 0, 1, 1, 2 ]
[ 0, 1, 2, 2, 3, 3 ]
[ 0, 1, 2, 2, 2, 2 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 1, 2, 3, 4 ]
[ 0, 1, 1, 2, 3, 4 ]
    10.do{(0..5).sputter(0.5, 100).postln;};
[ 0, 1, 2, 2, 2, 2, 2, 2, 3, 4, 5 ]
[ 0, 1, 2, 2, 3, 3, 4, 4, 5 ]
[ 0, 0, 0, 1, 2, 3, 4, 4, 5, 5, 5 ]
[ 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 4, 5 ]
[ 0, 0, 0, 0, 1, 2, 3, 4, 4, 5 ]
[ 0, 0, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 5, 5, 5 ]
[ 0, 0, 1, 1, 2, 3, 4, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 3, 4, 5 ]
[ 0, 0, 1, 2, 2, 3, 3, 3, 4, 5, 5 ]
[ 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 4, 5, 5 ]




    10.do{(0..5).sputter(0.6, 6).postln;};
[ 0, 1, 1, 2, 2, 2 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 1, 1, 2, 3 ]
[ 0, 0, 0, 1, 2, 3 ]
[ 0, 1, 1, 1, 1, 2 ]
[ 0, 1, 1, 2, 3, 3 ]
[ 0, 1, 1, 1, 1, 2 ]
[ 0, 0, 0, 1, 1, 2 ]
[ 0, 0, 1, 2, 2, 3 ]
[ 0, 0, 0, 0, 0, 0 ]

    10.do{(0..5).sputter(0.6, 100).postln;};
[ 0, 0, 1, 1, 1, 2, 3, 3, 3, 3, 3, 4, 5, 5, 5 ]
[ 0, 0, 1, 2, 2, 3, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 1, 2, 3, 3, 3, 3, 4, 4, 4, 5 ]
[ 0, 0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 5 ]
[ 0, 1, 1, 2, 2, 2, 2, 2, 2, 3, 4, 4, 4, 5, 5 ]
[ 0, 1, 2, 3, 3, 4, 5 ]
[ 0, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 5, 5 ]
[ 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5 ]
[ 0, 0, 0, 1, 2, 3, 3, 3, 4, 4, 5, 5 ]
[ 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 4, 5 ]


    10.do{(0..5).sputter(0.7, 6).postln;};
[ 0, 0, 0, 0, 1, 1 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 1, 2, 3, 3, 3 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 1, 1, 2, 2 ]
[ 0, 0, 0, 0, 1, 1 ]
[ 0, 0, 0, 1, 2, 3 ]
[ 0, 0, 0, 0, 1, 2 ]
[ 0, 1, 1, 2, 2, 3 ]
[ 0, 1, 1, 2, 2, 3 ]
    10.do{(0..5).sputter(0.7, 100).postln;};
[ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5 ]
[ 0, 0, 0, 0, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5 ]
[ 0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5 ]
[ 0, 0, 1, 1, 2, 2, 3, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 1, 1, 2, 2, 2, 3, 4, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
[ 0, 1, 1, 1, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5 ]
[ 0, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 5, 5, 5, 5 ]



    
    10.do{(0..5).sputter(0.8, 6).postln;};
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 1, 1, 1, 2, 2 ]
[ 0, 0, 1, 2, 2, 2 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 1, 1, 1 ]
[ 0, 0, 1, 1, 1, 1 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 1, 1, 1 ]
    10.do{(0..5).sputter(0.8, 100).postln;};
[ 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5 ]
[ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 5 ]
[ 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5 ]
[ 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5 ]
[ 0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5 ]
[ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 4, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5 ]
[ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
[ 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5 ]


    10.do{(0..5).sputter(0.9, 6).postln;};
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 1, 1, 1 ]
[ 0, 0, 0, 1, 1, 1 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 1, 1, 1, 1, 1 ]
[ 0, 0, 0, 0, 0, 1 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 1, 1, 1, 1, 2 ]
    10.do{(0..5).sputter(0.9, 100).postln;};
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5 ]
[ 0, 0, 0, 0, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5 ]
[ 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5 ]

    
    10.do{(0..5).sputter(1.0, 6).postln;};
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
[ 0, 0, 0, 0, 0, 0 ]
    10.do{(0..5).sputter(1.0, 100).postln;};
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
... 


**.allTuples(maxTuples: 16384)
Returns a new Array whose elements contain all possible combinations of the receiver's subcollections.**

    [(0..5), (0..5)].allTuples;
-> [ [ 0, 0 ], [ 0, 1 ], [ 0, 2 ], [ 0, 3 ], [ 0, 4 ], [ 0, 5 ], [ 1, 0 ], [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 0 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 2, 5 ], [ 3, 0 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ], [ 3, 4 ], [ 3, 5 ], [ 4, 0 ], [ 4, 1 ], [ 4, 2 ], [ 4, 3 ], [ 4, 4 ], [ 4, 5 ], [ 5, 0 ], [ 5, 1 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ], [ 5, 5 ] ]



