https://scsynth.org/t/repeat-n-times-a-pattern-newbie-question/2087

s.boot;

// it works
(
    ~ph0func = { arg n;
    	Pbindef(\ph0,
        \instrument, \default,
        \note,Pseq([0,5,1,4,2,3],n.postln),
    	\dur,0.25
    ).play;
    };

)

~ph0func.value(3,);  // prints 3


// Mayer
Pn(Pbind(\note, Pseq([0, 1]), \dur, 0.2), 5).play



// simply  just changing  the key I need and the Pn()
Pbindef(\ph0,\instrument, \default,\dur,0.25).play;
Pbindef(\ph0, \note,Pn(Pseq([0,5,1,4,2,3]),3));
Pbindef(\ph0, \note,Pn(Pseq([0,5,1,4,2,3].reverse),4));


// using .repeat()
(
Pbindef(\testRepeat,
        \instrument, \default,
        \note,Pseq([0,5,1,4,2,3].scramble),
    	\dur,0.125);
)

Pbindef(\testRepeat).repeat((3.rand+1)).play


// RFluff
Pdef(\top, Pchain(Pdef(\filter), Pdef(\sounds)))




//
(
SynthDef(\instr,{|n =1,out =0, freq = 440|
	 Out.ar(out,SinOsc.ar(freq) * Line.kr(1, 0, 0.25, doneAction: Done.freeSelf))
}).add;
)

a = Synth(\instr);
(
    	Pbindef(\ph,
        \instrument, \instr,
	    \n, 4,
	\freq,PlazyEnvir(Pseq([100,200,300],Pkey(\n))),
    	\dur,0.25
    ).play;
)
Pbindef(\ph, \n, 12).play;

Pbindef(\ph).stop;
Pbindef(\ph).clear;

(
(Pbindef(\oneseq,
	\instrument, \default,
	\dur, PlazyEnvir({Pseq(0.15!2, ~reps.postln)}),
	\midinote, PlazyEnvir({Pseq([57, 55], ~reps)})));
)
Pdef(\oneseq).set(\reps, 58)
Pdef(\oneseq).play;
Pdef(\oneseq).stop;
Pdef(\oneseq).clear;