// sketches.scd
// this file can be used to write sketches,
// before they become scenes or other parts of the codebase


/* TO DO/ TO UNDERSTAND

Add n_times = I mean how many times a seq can be repeated
make everything inside a a dictionary, maybe you should put eery pattern in a function with n_times, metronomes sequences..
Change the SynthDef adding another envelope that is for crescendos etc, long envelopes over the pattern

How to quant to next bar? quant:[~metro.base.timeToNextBeat,0]
How to add a GUI for the env where it's possible to change dynamically the curves

*/


/*
http://www.musicaecodice.it/SC_Controllo/SC_Gui/SC_Gui.php#sf
(
w = Window.new("EnvelopeView", 500@400);
e = EnvelopeView.new(w, Rect(10,10,480,380));

~h = Env.new([0,1,0.4,0],[0.2,0.5,1],[3,-2.3,1.5]);
~dur = h.duration; // recupera la durata dell'inviluppo (può servire)
e.setEnv(~h);

w.front;
w.alwaysOnTop_(true);
w.onClose_({e.free;w.free;~h.free;r.stop});

Pbindef(\scramble,\env, Pseq([[~h]],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
)
*/

/* how to schedule 2 patterns in sequence that are based on 2 different metros eg: repeat the first one 4 times then repet the second one 4 times over and over in loop. .play(~metro.base ,quant:~metro.base.beatsPerBar);
I mean : How could I change the metro in the quantization at the end of the first repetion...???

*/

/*
Granular stuff from the book \constQ ;) and all the behaviors:

- \dur, Pstutter(Pwhite(2, 15),Pfunc({ exprand(0.01, 0.3) }),inf)
- \dur, 1/16 * Pbrown(0.6, 2.4, 0.2,inf)

*/



/* polyrhythmic/2metros   pattern
write it in the new way.

~playMetroBase = Pbind(
	\instrument, \bleep,
	\note, Pseq((72!1)++(60!(~metroBase.beatsPerBar.asFloat-1)),inf),
	\sustain, 1,
	\dur, 1).play(~metroBase,quant:~metroBase.beatsPerBar);
//~playMetroBase.stop;

~playMetro1 = Pbind(
	\instrument, \bleep,
	\note, Pseq((75!1)++(63!(~metroBase.beatsPerBar.asFloat-1)),inf),
	\sustain, 1,
\dur, 1).play(~metro[1],quant:~metro[1].beatsPerBar);
//~playMetro1.stop;
)
~playMetro1.stop;
~playMetroBase.stop;
*/



// patterns:
// specify sequences with as few conversions as possile
// - bus: lightsBus.index is added at the end
// - env:
//   - every single envelope needs to be inside an array
//   - every envelope should last a total of 1
// - dur: expressed in beats, converted later
// - finish: here we call our conversion function

/*
(
r = Routine({

	~lightsAddr.sendMsg("/startrec","startrec".postln);

(
Pbindef(\frase,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
	\amp,1,
    \env, Pseq([
        [Env.perc],
        [Env.perc(0.999,0.001,1,4)]
    ],inf),
    \dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
);

4.wait;

	~lightsAddr.sendMsg("/stoprec", "stoprec");
	Pbindef(\frase,).stop;
	"done".postln;
});
)

r.play;

~lightsAddr.sendMsg('/startrec',"startrec".postln);

~lightsAddr.sendMsg('/stoprec', "stoprec");

*/

(
Pbindef(\frase,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
    \bus,Pseq([(0..5)],inf) + ~lightsBus.index,
	\amp,1,
    \env, Pseq([
        [Env.perc],
        [Env.perc(0.999,0.001,1,4)]
    ],inf),
    \dur, Pseq([1],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
);



// start a crescendo   \amp, ~dynamics.subBus(0).asMap,
Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg([0,3,0],[9,1],4,1),
    \dur, 0.01
).play
)

Pbindef(\frase).stop
Pbindef(\frase).clear

// if you want to quickly sonify it, for testing
Ndef(\monitor){
    var trigs = In.kr(~lightsBus,6);
    Mix(Pan2.ar(SinOsc.ar(100*Scale.partch_o2.ratios)*trigs, [-1,1])/10)
}.play



// launch a pattern, reading amp from ~dynamics
(


 ~ph0func = { arg n;
Pbindef(\frase,
    \instrument, \DcOuts,
    \bus, Pseq([(0..5)],n) + ~lightsBus.index,
    \amp, 1,//~dynamics.subBus(0).asMap,
    \env, Pseq([
        [Env.perc],
        [Env.perc(0.999,0.001,1,4)]
    ],inf),
    \stretch,1,
    \dur, Pseq([1,0.5,0.5,0.25,0.25],inf),
).play;

// Pseg(levels:[0,1],durs:[4],curves:4,repeats:1),
Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg(levels:[0,1],durs:[10],curves:4,repeats:1),
).play;
})

~ph0func.value(20);


/*
write a set of phrases that u can consider like: "default"
*/


/*(
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


Pbindef(\forward,\dur, Pseq([1/8],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
Pbindef(\forward,\dur, Pseq((1/8!9)++(1/4!3),inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);

Pbindef(\forward).stop;
Pbindef(\forward).clear;*/


(
~ph_forward = { arg n;
Pbindef(\forward,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Pseq((0..5),n) + ~lightsBus.index,
    \amp, ~dynamics.subBus(0).asMap,
    \env, Pseq([
		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
};

// Pseg(levels:[0,1],durs:[4],curves:4,repeats:1),
Pmono(\ampControl,
	\stretch,4,
	\legato,1,
    \out, ~dynamics.subBus(0),
    \amp, Pseg(levels:[1,1],durs:[1],curves:4,repeats:1), // set Crescendo and or Diminuendo if needed
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

~ph_forward.value(1);

Pbindef(\forward,\dur, Pseq([1/8],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
Pbindef(\forward,\dur, Pseq((1/8!9)++(1/4!3),inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);

Pbindef(\forward).stop;
Pbindef(\forward).clear;


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
	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base);

	(6.01).wait;




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

Pbindef(\reverse,\dur, Pseq([1/12],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
// palindromo == seq of 10
Pbindef(\reverse,\dur, Pseq((1/4!6)++(1/12!6)++(1/16!6)++(1/24!12)++(1/32!12),inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);

Pbindef(\reverse).stop;
Pbindef(\reverse).clear;



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
	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\palindromo,\dur, Pseq([1/12],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
// palindromo == seq of 10
Pbindef(\palindromo,\dur, Pseq((1/8!7)++(1/4!3),inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);

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

// Change the Envelope duration and shape
Pbindef(\scramble,\env, Pseq([[Env.perc(0.001,4.999,1,4)]],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
Pbindef(\scramble,\env, Pseq([[Env.perc(0.999,0.001,1,4)]],inf)).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);


Pbindef(\scramble).stop;
Pbindef(\scramble).clear;

// all togheter appassionatamente
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





