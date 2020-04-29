## Video Cuts Analysis ##

The goal is to take inspirations from this video, 
I edited it to try to better understand what's going on about the light design.
By the way, I have to rearrange the sequences for my setup that is made of 6 lights so this is just my interpretation, it's not intended to be a true analysis. 
If you like to try by yourself you could run the processingOSCnodimmer to visualize the envelopes/animations.
    
    import oscP5.*;
    import netP5.*;
    
    OscP5 osc;
    NetAddress sc;
    
    float amp1,amp2,amp3,amp4,amp5,amp6;
    
    void setup(){
      size(400, 66);
    
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
     noStroke();
    
    // channel 1
       fill(153,255*amp1,0);
       rect(0,0,width/6,height*amp1);
    
       // channel 2
       fill(153,255*amp2,0);
       rect(66,0,width/6,height*amp2);
    
    // channel 3
       fill(153,255*amp3,0);
       rect(132,0,width/6,height*amp3);
       
       // channel 4
       fill(153,255*amp4,0);
       rect(198,0,width/6,height*amp4);
      
    
       // channel 5
       fill(153,255*amp5,0);
       rect(264,0,width/6,height*amp5);
    
    
       // channel 6
       fill(153,255*amp6,0);
       rect(330,0,width/6,height*amp6);
    
    }
    
    // funcction  to get the data and send them to the proper place.
    void newamps(float rms1, float rms2, float rms3, float rms4, float rms5, float rms6){
       amp1 = rms1; amp2 = rms2; amp3 = rms3; amp4 = rms4; amp5 = rms5; amp6 = rms6;
       println("[",amp1,amp2,amp3,amp4,amp5,amp6,"]");
    }
    

If you then need to use it with a dimmer just go on github and run the "ProcessingOSC" file.

in SC: 
Run 
- setup.scd
- sketches.scd


## first things first, default phrases: ##

    
    Pbindef(\forward,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5),inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
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
    // a rand seq repeted over and over
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
    



Time stamps youtube:

https://youtu.be/AEpn6HvQSKg

I'm looking only at the bottom row I can reproduce just one row with my 6 lights 
- Env perc long atk .. 
something like that:
[Env.perc(0.899,0.101,1,-2)].plot;

seq first element last element and so on.
 
  


    (
    var n_times = 1;
    Pbindef(\ph0,
    \instrument, \DcOuts,
    	\stretch,4,
    \bus,Pseq([0,5,1,4,2,3],n_times) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.999,0.001,1,-2)]
    ],inf),
    	\dur, Pseq((1/2!2)++(1/4!5),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    // Find a better way to tell how many times a ph has to be repeated
    (
    var n_times = 4;
    Pbindef(\ph0,
    	\bus,Pseq([0,5,1,4,2,3],n_times) + ~lightsBus.index,
    	\dur, Pseq([1/16],inf)
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\ph0).stop
    Pbindef(\ph0).clear
    
    

 
https://youtu.be/AEpn6HvQSKg?t=4



    (
    Pbindef(\ph1,
    \instrument, \DcOuts,
    	\stretch,4,
    \bus,Pseq([(0..2),(3..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.9999,0.0001,1,2)],
    		[Env.perc(0.0001,0.9999,1,1)]
    ],inf),
    	\dur, Pseq([1, 1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\ph1,\dur, Pseq([1/4],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
    
    Pbindef(\ph1).stop
    Pbindef(\ph1).clear


/* 
It's just an idea I added .. 
- growing in brightness over time eg: 1bar ,
- keeping the rhythmic alternating sequence "A-B"  
A = (0..2)
B = (3..5)

you have to add  \amp, ~dynamics.subBus(0).asMap,

Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg(levels:[1,1],durs:[1],curves:4,repeats:1),
).play;

*/

(
Pbindef(\ph2,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
    \bus,Pseq([(0..2),(3..5)],inf)+ ~lightsBus.index,
	\amp, ~dynamics.subBus(0).asMap,
    \env, Pseq([ [Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]],inf),
	\dur, Pseq([1/16],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg(levels:[0,1],durs:[4],curves:4,repeats:1),
).play(~metro.base ,quant:~metro.base.beatsPerBar);



// Similar Idea, group of 2 or 3 contiguous lights, 
(
Pbindef(\ph3_grp2,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
    \bus,Ptuple([
    Pseq([0,1,2,3,4,5],inf),
	Pseq([1,2,3,4,5,0],inf)
    ],inf)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([ [Env.perc]],inf),
    \dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\ph3_grp2).stop
Pbindef(\ph3_grp2).clear



(
Pbindef(\ph3_grp3,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Ptuple([
    Pseq([0,1,2,3,4,5],inf),
	Pseq([1,2,3,4,5,0],inf),
	Pseq([2,3,4,5,0,1],inf)
    ],inf)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([ [Env.perc]],inf),
    \dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\ph3_grp3).stop;
Pbindef(\ph3_grp3).clear;


(
Pbindef(\ph3_grp4,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Ptuple([
    Pseq([0,1,2,3,4,5],inf),
	Pseq([2,3,4,5,0,1],inf),
    ],inf)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([ [Env.perc]],inf),
    \dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\ph3_grp4).stop;
Pbindef(\ph3_grp4).clear;


// sequence of envelopes 

(
Pbindef(\ph4_,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
	\bus,Pseq((0..5),inf) + ~lightsBus.index,
    \amp,1,
	\env, Pseq([ [[Env.perc]],[[Env.perc(0.999,0.001,1,4)]] ],inf),
    \dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\ph4_).stop;
Pbindef(\ph4_).clear;

// parallel envelopes multichannel expansion on busses

(
Pbindef(\ph5,
    \instrument, \DcOuts,
	\legato,1,
	\bus,Pseq([(0..5)],inf) + ~lightsBus.index,
	\stretch,4,
    \amp,1,
\env,Pseq([
        [ [Env.perc], [Env.sine], [Env.sine] ],
        [ [Env.sine], [Env.perc], [Env.perc] ],
    ], inf),
	 \bus,Pseq([(0..1)],inf) + ~lightsBus.index,
	//\bus,Pfunc{|e| 0 + (0..e.env.size-1).postln },
    \dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\ph5).stop
Pbindef(\ph5).clear




https://youtu.be/AEpn6HvQSKg?t=8

My reinterpretation is first- random - last fast envelope 1/0 . 
\env, Pseq([ [Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]],inf),


https://youtu.be/AEpn6HvQSKg?t=11
tutti 
env perc log 
Env.perc(0.001,0.999,1,8).plot;



https://youtu.be/AEpn6HvQSKg?t=13

https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook06_Phrase_Network.html

https://doc.sccode.org/Classes/Dictionary.html


last to first adjacent couple - single -  non adj couple

couple from first to last

random On off from last to first

random On off from  first to last 

seq 5 3 0 X2

seq 0 3 5 X2

group of half  \bus,Pseq([(0..2),(3..5)],inf)+ ~lightsBus.index,
like \ph2

tutti

one on one off all  with decay


https://youtu.be/AEpn6HvQSKg?t=30

one yes one no 
tutti 
one yes one no with offset
it gives the sansation of something that is moving 


https://youtu.be/AEpn6HvQSKg?t=34
one yes one no Decay to black
one yes one no with offset


https://youtu.be/AEpn6HvQSKg?t=36
tutti crescendo to black 


https://youtu.be/AEpn6HvQSKg
It's super fast
on off off on on off 
off off on off off on
black


https://youtu.be/AEpn6HvQSKg?t=46
blink / black 
seq forward -> black


https://youtu.be/AEpn6HvQSKg?t=49
tutti crescendo
ASR one no one yes  alternating 1/8 
it gives us a sense of something that pulsates
superfast seq like before like 32nd or more for 1/8 forward and back
tutti on tutti off 1/8
seq forward ENV "staccato"
tutti on tutti off 1/8 *2
seq reverse ENV "staccato" 
seq forward ENV "staccato"
superfast seq like before like 32nd or more for some 1/8 



https://youtu.be/AEpn6HvQSKg?t=115

0,1,2 off off off forward 
off off off, 3, 4, 5



https://youtu.be/AEpn6HvQSKg?t=123

0,1, superfast like 32nd or more
tutti 1/4 on off on 

https://youtu.be/AEpn6HvQSKg?t=130
last to first 
super fast
on off off on on off 
off off on off off on
that arrives at 
off/on alternating 

super fast
on off off on on off 
off off on off off on
off/on alternating 
tutti

https://youtu.be/AEpn6HvQSKg?t=145
0,1,2 off off off forward 
off off off, 3, 4, 5
0,1,2 off off off forward 
off off off, 3, 4, 5
0,1, superfast like 32nd or more
tutti 1/4 on off Decay

https://youtu.be/AEpn6HvQSKg?t=164
seq tutti on -> off -> on "long" *n-times

https://youtu.be/AEpn6HvQSKg?t=177
turn on all from 0 to 5 
tutti like 80% of the intensity 
+20% like if there was a sinewave + offset 
something like that : https://youtu.be/JBRlZ94J-Jk

on off tutti


https://youtu.be/AEpn6HvQSKg?t=195

on off tutti
on off tutti + offset
seq rand on/off forward 1 element to more elements
tutti


https://youtu.be/AEpn6HvQSKg?t=210
seq forward con env exp 

https://youtu.be/AEpn6HvQSKg?t=222
single element staccato on:
- first group of three forward 
- second group of three back

tutti

- first group of three tutti
- second group of three tutti


https://youtu.be/AEpn6HvQSKg?t=237
back 
back
forward forward
back & forward contemporary
tutti

https://youtu.be/AEpn6HvQSKg?t=271
tutti
seq on off off back
first and last Repetition of the same light 
(0,5)*4times 
(1,4)*4times 
(2,3)*4times 
(1,4)*4times 
(0,5)*4times 

use those two phrases like intermezzo 
start seq back with offset on 2 -> 0
start seq forward with offset on 3 -> 5 
you can play those simultaneously
on on off on off on

https://youtu.be/AEpn6HvQSKg?t=333
seq forward and back group of adj 

https://youtu.be/AEpn6HvQSKg?t=337
https://youtu.be/AEpn6HvQSKg?t=356
on off tutti exp
seq on off offset forward
on off tutti exp
seq on off offset forward
central group (1,2,3)exp 
group 5,4 and 0,1 staccato exp
central group (1,2,3)exp 
group 5,4 and 0,1 staccato exp
seq forward and back group of 2 elements * ntimes
central group (1,2,3) 
group 5,4 and 0,1 staccato 
on off tutti staccto 32nd
seq forward and back group of 2 elements * ntimes
from first and last to center turning all on with ENV Exp
seq forward and back group of 2 elements * ntimes
- first group of three tutti 32nd
- second group of three tutti 32nd

https://youtu.be/AEpn6HvQSKg?t=443
on off tutti exp
on off tutti exp offset
offset on off tutti log from max to black
tutti exp to black 

https://youtu.be/AEpn6HvQSKg?t=450
https://youtu.be/AEpn6HvQSKg?t=473 slowed down.
0,5 - 1,4 - 2,3
seq forward super fast 2 32nd per light
- first group of three tutti 16nd
- second group of three tutti 16nd 
- first group of three tutti 16nd
- second group of three tutti 16nd 
tutti
on off tutti
on off offset
tutti / black *2
- first group of three tutti 16nd
- second group of three tutti 16nd 

tutti pulsating 70% + 30%  8th or 16th

tutti pulsating 70% + 30%  32nd * 4
couple of two forward
tutti
seq forward one light

https://youtu.be/AEpn6HvQSKg?t=499
on off tutti + offset
tutti exp
couple of two forward
tutti exp
seq forward one light




# Project Guidance #


I found myself quite often looking for solutions of technical problems or ideas, implementations and explenations on this forum,in the mailing list or at https://sccode.org/
 
I used to play with a friend that helped me a lot with the programming thing.
Here an extract of one of our projects:  https://youtu.be/BBi-QUU0x0I
Now it's not possible anymore to play togheter, but, to have the possibility of ask here, make me feel enough confidence to start my first project alone.
I'm feeling quite a newbie. 
 
To be explicitly honest I would love to find someone interested in help me out, even sporadically or just when he/she wants/can.
If for you make sense I can open compleatly all the processes of the making including the "ownership" of the Installation, live or whatever will be.. 

Don't get me wrong, I don't think to have the best Ideas of the world, I just copy, or better I take inspiration from other artists that with their works give me a solid starting point.

Said that, I would like to do it collectively and I think that the work belongs to whoever does it.

I usually take inspirations or I copy:
- ideas from other artists, musicians or creatves.
- quite often the code is copied from solutions or implementations made by others.
- the workflow is taken step by step from some tutorials..and so on.. 

For example I copied the way to think/structure a performance from here:
https://youtu.be/P85X1Ut3Hfc

or from here a bunch of synths:
https://github.com/madskjeldgaard/scbookcode

 
A nice thing that I learnt when I studied eletroacustic music from one of my teacher was : "music is sharing" I know that could sounds a bit of a rethoric sentence but I like to think that could be true.
Now, flying down to the planet earth, I kindly ask you your support hoping that this could become a nice moment to confront eachother, bringing out a lean and solid approach to tackle a performative project.

I also hope that this moment of sharing, if it will be so, could become an interesting "place" to discuss how a project can be structured in its entirety, from the development of the idea, which constantly requires to be modified according to the real possibilities and to the limits, up to the physical realization or the technicalities of programming.

Let's try to see what will happen :) 
Here there is a link to the repo on github:
https://github.com/RandColors/project-guidance

For now there is just a file for example.

## About the Performative-Installation  ##
My first multimedia performance installation is based on three elements: Light, Sound and Mechanical Laser oscilloscopes.
Currently being in a preliminary phase I have mounted 6 circular equidistant bulbs attached to the ceiling of a room that is dedicated to the development of this installation.

C:\Users\ET\Desktop\cartella condivisa\img\dimmer circularLightbulbs

The dimmer I use is this one:
C:\Users\ET\Desktop\cartella condivisa\img\B_PROEL_pldm6kn

- user manual: https://www.strumentimusicali.net/manuali/PROEL_PLDM6KN_IT.pdf

- modification with power plugs and sockets, in order to attach different lamps or "objects" to the dimmer.

- C:\Users\ET\Desktop\cartella condivisa\img\dimmer Connections

I'm in Italy, anyway I'm not recommending to buy stuff from where I bought them, it's just for for illustrative purposes and as far as I know, there are cheaper places to buy these items, just in case you are interested.


I found this cheap solution, that it works quite well, and I'm happy to share because I guess It could be used in a lot of  contexts where a maximum of 8 loudspeakers is needed. 

cheap 8-channel sound card:
https://www.amazon.it/portatile-microfono-frequenza-campionamento-compatibile/dp/B07HMWHBXS

Amplifier:
https://www.amazon.it/gp/product/B01CZQAFCO/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1 

Power supply:
https://www.amazon.it/gp/product/B07SRQ4C8K/ref=ppx_yo_dt_b_asin_title_o09_s00?ie=UTF8&psc=1

Loudspeaker:
Calzette, dentini, cavi e saldatore.

cables:
https://www.amazon.it/gp/product/B000L0W5BG/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1

## 1 LIGHTS/DIMMER ##
At the moment I'm working with lights only, writing some obvious/foundamental pattern beheviours.

Video snippet of constant circular motion:
https://www.youtube.com/watch?v=oBUsbq8JqGY


## 2 SOUND /LOUDSPEAKERS ##
Video snippet using PanAz with the loudspeakers:
https://youtu.be/BdYn25hI9Ik

This Idea was taken from: 

**Marcus Fisher**

http://mapmap.ch/index.php/ongoing/multiples/
https://youtu.be/9tW34OvHs24

I hypothesized an approach to sound design, where I physically go to put on and off objects that want to vibrate inside  the loudspeakers.

The objects that I have identified as interesting are:

- rattles
- plastic caps
- glass eroded by the sea
- hunting-fishing sinkers
- leaves and seeds

and casekeeper .. beer bottle caps :)

Here an example with the lights too. 
One to one approach(for light one correspond spaeker one.. and so on..) 
https://youtu.be/SqsNr7X97q0

## 3 MECHANICAL LASER OSCILLOSCOPE ##
Another thing that fascinated me a lot was this "experiment" that I saw on youtube:

Laser + mirror + sound
https://youtu.be/C-V1uXeyGmg

I then decided to try it and I bought the Balloons, lasers and mirrors.

I then looked for information about the generation of Lissajous figures and how an Oscilloscope works.

There are fundamental differences between this way of viewing sound and a real oscilloscope, first of all it is not possible to view the high frequencies, this approach works well only in the low and medium range and I have to build a way to make the system solid and have the certainty that the figure produced will be replicable. I think this will be done with 3d printing techniques, in order to decide the angle and distance between laser and mirror, and it would be essential to find a way to stretch the balloon membrane homogeneously.

For this approach, however, I based myself on additive synthesis and then I found Phase Modulation extremely interesting.

Just a couple of video snippets taken for memo purposes.
complex waveforms additive synthesis:
https://youtu.be/bDcMkBVLNmk

Phase Modulation: https://youtu.be/DZSLobBCEdQ


and I found some intersting ideas to compose waveforms from this book:
 https://www.packtpub.com/application-development/mapping-and-visualization-supercollider#tab-label-table.of.contents

L'unico inconveniente è che avrei voluto non sentire i suoni prodotti ma rimanere in un range subsonico, purtroppo, in questo modo non è molto interessante dal punto di vista visivo. 
Ho anche provato a prendere una lavagnetta luminosa per vedere se era possibile scrivere su di essa con la luce laser in maniera tale da andare a disegnare su di essa l'intero tracciato, ma non ho avuto fortuna a riguardo per ora.


These are the first 3 elements that I am interested to explore.

1 What and how is it possible to do with 6 lights? (search and structuring of a phrasebook)
2 Speakers like Actuator (From punctual to continuous) (Low and Infrasonic music).
3 Draw with sound. waveform composition.


In the end the first thing I'm working on is copying from this teaser the different lights movements. 

Takami Nakamoto - Opacity EP Teaser Medley
https://www.youtube.com/watch?v=1e-ZrxPgnR4
I'm just intersted in having a musical work like a reference



### Tech ###
Technical things that looks really intersting and why I would like to Use the Pattern Libary in conjunction with Envelopes.

Accelerando/decelerando con Envelopes per definire il numero di eventi al secondo.
Guarda il odice che avevi per capire quale è il suono e che "score" ed a che tipo di controlloMIDI è associato. 

- Start Up file (cosa includere)
-  
- Animation Techniques
- ease functions 
- avere pezzi di timeline algoritmica per scrivere delle gesture precise
- modificare 

Primo Argomento da affrontare:
Gesture luminose prese dal teaser di Takami Nakamoto.

- Elenco dei controller MIDI.
- Ipotizza la divisione dei files. 
- vedi il carica files automatico.
- vedi le regole di sintassi suggerite.
- 


I know that she wrote a Quark to work with dimmers and it's clear from her works that it works really well..  

From a musical performance point of view I would love to bring togheter two approaches ,
the first one based on pre-written patterns that I have only to manipulate or play like they are, and the second one based on playing a single note every time a key is pressed , so it's like a traditional instrument or better like a drums played with a keyboard.. 
Here a first list of artists to which I want to inspire for this project: 

### Sound inspirations ###


#### 1 Pattern and Signal Based approach ####
**Marcus Fisher**

http://mapmap.ch/index.php/ongoing/multiples/
video extract: https://youtu.be/9tW34OvHs24

**Mark Fell |Multistability**

http://www.markfell.com/wiki/index.php?n=Mf.Multistability
https://www.youtube.com/watch?v=PHIGHpWKcw0

**Gavin-Harrison-Rhythmic-Illusions**

http://www.gavharrison.com/ 
From this book it's possible to read/study and listen to 
a really nice examples of Rhythmic modulations, polymeters My goal in this regard is just to create polimeters in between from sounds Pattern and light Patterns.

**Nik Bärtsch**


http://www.nikbaertsch.com/

Nik Bärtsch's RONIN, AWASE
Nik Bärtsch's RONIN, LIVE 2-CD Set, 2012
Nik Bärtsch's RONIN, LLYRÌA
Nik Bärtsch's RONIN, HOLON
Nik Bärtsch's RONIN, STOA
Nik Bärtsch's RONIN, REA
Nik Bärtsch's RONIN, LIVE
Nik Bärtsch's RONIN, RANDORI



####2 Controllerism Like approach ####
**Pallavi e Ritmi **

I'm very fascinated by this piece, 
that is rich of rhythmic Ideas and could let me expand in this direction.

https://www.youtube.com/watch?v=ZEtGz-_aabI

**Hip-hop/afro/dub/funk/fusion drums Grooves**


### Lighting Inspirations ###
I found some difficulties to find  artists that work
with lightsbulbs in a musical context.

Takami Nakamoto - Opacity EP Teaser Medley
https://www.youtube.com/watch?v=1e-ZrxPgnR4
I'm just intersted in having a musical work like a reference

Daito Manabe
https://youtu.be/h1P9BswB_v0

Jeff Carey - Ende Tymes
https://www.youtube.com/watch?v=dV47SkjLRMM

Marije Baalman 
https://marijebaalman.eu/projects/n-polytope.html
https://github.com/supercollider-quarks/DMX/blob/master/DMX.sc



**Dividi I problemi nei diversi ambiti**

-Multimetronomic approach: Array of Tempoclocks: 
scusa per postare, la prima parte di codice da ottimizzare.
https://www.youtube.com/watch?v=3o_MFZGQ1jw

- scrivere patterns ritmici? 
- quale approccio utilizzare?
- 
 
AUDIO MULTICANALE: 
http://www.musicaecodice.it/SC_Panning/SC_Panning.php

https://www.youtube.com/watch?v=E8V2TIfT8Bc&list=PLPYzvS8A_rTYeUY_dHEhB_477LsybTvQ8

VBAP Vettoriale(interessante nella luce)
Ambisonic
Mono signal  Over n°
Stereo Signal Over n° 