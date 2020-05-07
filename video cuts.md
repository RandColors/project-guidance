## Video Cuts ##

The goal is to take inspirations from this video, 
I edited it to try to better understand what's going on about the light design.
By the way, I have to rearrange the sequences for my setup that is made of 6 lights so this is just my interpretation, it's not intended to be a true analysis. 
If you like to try by yourself you could run the processingOSCnodimmer to visualize the envelopes/animations.

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
I just added some ideas .. little divagation.. 

- growing in brightness over time eg: 1bar ,
- keeping the rhythmic alternating sequence "A-B"  
A = (0..2)
B = (3..5)

you have to change  \amp, ~dynamics.subBus(0).asMap,

and add the Pmono  

Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg(levels:[0,1],durs:[10],curves:4,repeats:1),
).play;

*/

(
Pbindef(\ph2,
    \instrument, \DcOut,
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



// Similar Idea, Group of  2 contiguous lights.
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

// Group of  3 contiguous lights
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


// Group of  2 non contiguous lights
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

 Pbindef(\firstRandlast,
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


https://youtu.be/AEpn6HvQSKg?t=11
tutti 
env perc log 
Env.perc(0.001,0.999,1,8).plot;
    
    (
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([2],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\tutti).stop
    Pbindef(\tutti).clear


https://youtu.be/AEpn6HvQSKg?t=13

here I try to make a "phrase" made by different "words" or better little articulations of a word.
Are not even close to what is happen in the video.

- last to first adjacent couple - single -  non adj couple
- couple from first to last
- random On off from last to first
- random On off from  first to last 
- seq 5 3 0 X2
- seq 0 3 5 X2
- group of half \ph2
- tutti
- one on one off all  with decay


// last to first adjacent couple

    (
    Pbindef(\adj,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Ptuple([
    Pseq([0,1,2,3,4,5].reverse,inf),
    	Pseq([1,2,3,4,5,0].reverse,inf),
    ],1)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    			[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\adj).stop;
    Pbindef(\adj).clear; 

// last to first

    (
    Pbindef(\reverse,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Pseq((0..5).reverse,1) + ~lightsBus.index,
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
    

// non adj couple

    (
    a = Pseq([0,1,2,3,4,5], 1);
    b =  (2+3.rand)+a; //
    
    Pbindef(\nonAdj,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Ptuple([a, b%6], 2) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\nonAdj).stop;
    Pbindef(\nonAdj).clear;
    
    

// couple from first to last same as /adj

    (
    Pbindef(\adj,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Ptuple([
    Pseq([0,1,2,3,4,5],inf),
    	Pseq([1,2,3,4,5,0],inf),
    ],1)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    			[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\adj).stop;
    Pbindef(\adj).clear;
    
    /*
    (
    a = Pseq([0,1,2,3,4,5], inf);
    b =  (1)+a; //
    
    Pbindef(\seqplus,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Ptuple([a, b%6], inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\seqplus).stop;
    Pbindef(\seqplus).clear;*/
    
    



//random On off from last to first \amp,Prand((0..1),inf)
    
    (
    Pbindef(\ronoffreverse,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([0,1,2,3,4,5].reverse, inf) + ~lightsBus.index,
    \amp,Prand((0..1),inf),
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\ronoffreverse).stop;
    Pbindef(\ronoffreverse).clear;
    
// random On off from  first to last
    
    (
    Pbindef(\ronoff,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([0,1,2,3,4,5], inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32,Rest(1/32)],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\ronoff).stop;
    Pbindef(\ronoff).clear;
    

//seq [5 3 0] 
    
    (
    Pbindef(\seq,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([5,3,0], 2) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\seq).stop;
    Pbindef(\seq).clear;
    
//seq [0 3 5] 
    
    (
    Pbindef(\seqrev,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([5,3,0].reverse, 4) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
     ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\seqrev).stop;
    Pbindef(\seqrev).clear;
    

// group of half  \bus,Pseq([(0..2),(3..5)],inf)
    
    (
    Pbindef(\grphalf,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..2),(3..5)],inf)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq((1/8!3),1),
    \finish, ~beatsToSeconds
    );
    
    
    // Pbindef(\ghalf).stop;
    // Pbindef(\ghalf).clear;
    
    
// one on one off all with decay
    
    Pbindef(\oneononeoff,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4]],1)+ ~lightsBus.index,
    \amp, 1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,-4)]
    ],inf),
    	\dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
    );
    
    // Pbindef(\oneononeoff).stop;
    // Pbindef(\oneononeoff).clear;
    
 // tutti 
   
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    	\dur, Pseq((1!1),1),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    // Pbindef(\tutti).stop;
    // Pbindef(\tutti).clear;
    


https://youtu.be/AEpn6HvQSKg?t=30

- one yes one no

- tutti

- one yes one no with offset

//fake movement,it gives the sansation of something that is moving

    (
    Pbindef(\moving,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4],[0,1,2,3,4,5],[1,3,5]],6)+ ~lightsBus.index,
    \amp, 1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,-4)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\moving).stop;
    Pbindef(\moving).clear;
    


https://youtu.be/AEpn6HvQSKg?t=34

- one yes one no Decay to black
- one yes one no with offset

// one on one off all with decay

    (
    Pbindef(\oneononeoff,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4]],1)+ ~lightsBus.index,
    	\amp, 1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,-4)]
    ],inf),
    	\dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\oneononeoff).stop;
    Pbindef(\oneononeoff).clear;


 	(
    Pbindef(\combmov,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4],[1,3,5]],1)+ ~lightsBus.index,
    \amp, 1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,-4)]
    ],inf),
    \dur, Pseq([1/32,1/16],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\combmov).stop;
    Pbindef(\combmov).clear;




https://youtu.be/AEpn6HvQSKg?t=39

- It's super fast,you could try with a rand on-off *2times
black

// tutti rhythm

    (
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    	\dur, Pseq((1/16!1)++Rest(1/16),2),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\tutti).stop;
    Pbindef(\tutti).clear;
    
    
    //
    (
    Pbindef(\ronoff,
    \instrument, \DcOuts,
    	\legato,1,
    	\stretch,4,
    	\bus, Pseq([0,1,2,3,4,5], 4) + ~lightsBus.index,
    	\amp,Prand((0..1),inf),
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,8)]
    ],inf),
    	\dur, Pseq([1/32],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\ronoff).stop;
    Pbindef(\ronoff).clear;
    
    
    (
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    \dur, Pseq((1/16!1++Rest(1/8)),1),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\tutti).stop;
    Pbindef(\tutti).clear;



    



https://youtu.be/AEpn6HvQSKg?t=46

- seq forward -> black

(
	Pbindef(\forward,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Pseq((0..5),1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    \dur, Pseq((1/64!6)++Rest(1),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


    Pbindef(\forward).stop;
    Pbindef(\forward).clear;




https://youtu.be/AEpn6HvQSKg?t=49

- tutti crescendo
- ASR one no one yes  alternating 1/8 
it gives us a sense of something that pulsates
- forward and back in 1/8
- tutti on tutti off 1/8
- seq forward ENV "staccato"
- tutti on tutti off 1/8 *2
- seq reverse ENV "staccato" 
- seq forward ENV "staccato"
- superfast seq like before like 32nd or more for some 1/8 
    


// tutti crescendo

    (
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    \dur, Pseq((1/8!1),1),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    
    Pbindef(\tutti).stop;
    Pbindef(\tutti).clear;


// Env([0.001,0.8,1.0,1.0,0.001],[0.7,0.01,0.29,0.01],-4).plot;

// ASR one no one yes  alternating 1/8

// it gives us a sense of something that pulsates

    (
    Pbindef(\combmov,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4],[1,3,5]],3)+ ~lightsBus.index,
    \amp, 1,
    \env, Pseq([
    		[Env([0.001,0.8,1.0,1.0,0.001],[0.7,0.01,0.29,0.01],-4)]
    ],inf),
    \dur, Pseq([1/8],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\combmov).stop;
    Pbindef(\combmov).clear;


// palindromo make a 5tuplet..
    
    (
    Pbindef(\palindromo,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5).mirror1,1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    	\dur, Pseq((1/40!10),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )
    
    Pbindef(\palindromo).stop;
    Pbindef(\palindromo).clear;

- ASR one no one yes  alternating 1/8
it gives us a sense of something that pulsates

(
    Pbindef(\combmov,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus, Pseq([[0,2,4],[1,3,5]],3)+ ~lightsBus.index,
    \amp, 1,
    \env, Pseq([
    		[Env([0.001,0.8,1.0,1.0,0.001],[0.7,0.01,0.29,0.01],-4)]
    ],inf),
    \dur, Pseq([1/8],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\combmov).stop;
Pbindef(\combmov).clear;


// palindromo make a 5tuplet..

(
    Pbindef(\palindromo,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5).mirror1,1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq((1/40!10),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )

    Pbindef(\palindromo).stop;
    Pbindef(\palindromo).clear;

// - tutti on tutti off 1/8
(
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],4) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    \dur, Pseq((1/8!1),1),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\tutti).stop;
Pbindef(\tutti).clear;

- seq forward ENV "staccato"

(
	Pbindef(\forward,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Pseq((0..5),1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    \dur, Pseq((1/12!6),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


    Pbindef(\forward).stop;
    Pbindef(\forward).clear;

// - tutti on tutti off 1/8
(
    Pbindef(\tutti,
    \instrument, \DcOuts,
    \legato,1,
    \stretch,4,
    \bus,Pseq([(0..5)],2) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.001,0.999,1,-4)]
    ],inf),
    \dur, Pseq((1/8!1),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\tutti).stop;
Pbindef(\tutti).clear;

- seq reverse ENV "staccato"
(
Pbindef(\reverse,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Pseq((0..5).reverse,1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq([1/6],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\reverse).stop;
Pbindef(\reverse).clear;


- seq forward ENV "staccato"
(
	Pbindef(\forward,
    \instrument, \DcOuts,
    \stretch,4,
    \legato,1,
    \bus,Pseq((0..5),1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
    \dur, Pseq((1/12!6),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


    Pbindef(\forward).stop;
    Pbindef(\forward).clear;



// superfast seq like before like 32nd or more for some 1/8
(
    Pbindef(\palindromo,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5).mirror1,1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq((1/40!10),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )

    Pbindef(\palindromo).stop;
    Pbindef(\palindromo).clear;




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
