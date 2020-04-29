// sketches.scd
// this file can be used to write sketches,
// before they become scenes or other parts of the codebase


/* TO DO/ TO UNDERSTAND

Add n_times = I mean how many times a seq has to be repeated
make everything inside a a dictionary, maybe you should put eery pattern in a function with n_times, metronomes sequences..
Change the SynthDef adding another envelope that is for crescendos etc, so long envelope over the pattern
How to change metro.beat?
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
    \dur, Pseq([1,0.5,0.5,0.25,0.25],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

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
    \bus, Pseq([(0..5)],n_times) + ~lightsBus.index,
    \amp, ~dynamics.subBus(0).asMap,
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
    \amp, Pseg(levels:[1,1],durs:[1],curves:4,repeats:1),
).play;
)




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
    \bus,Pseq((0..5).mirror1,inf) + ~lightsBus.index,
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


/*
Realizzazione di FRASI ispirate dal lavoro di:
"Takami Nakamoto - Opacity EP Teaser Medley" https://www.youtube.com/watch?v=1e-ZrxPgnR4


Frase 1: Crescendo su metà delle luci con inviluppo esponenziale
la prima metà A e poi B già al massimo(255) stabile.
fai che A e B siano intercambiabili.

Frase 2:
alternato, con crescendo 3DX/3SX.

Frase 3:
fai gruppi di 2-3 e sposta l'offset sulla circonferenza(avanza).

Frase 4:
sequenza fatta da più inviluppi con avanzamento

Frase 5:
GRUPPO stesso punto di partenza temporale dur, ma con diversi tempi di inviluppo
*/


(
var n_times = 1;
Pbindef(\ph0,
    \instrument, \DcOuts,
	\legato,1,
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


//1


(
[Env.perc(0.999,0.001,1,2)].plot(name:"first");
[Env.perc(0.001,0.999,1,1)].plot(name:"second");
)

(
Pbindef(\ph1,
    \instrument, \DcOuts,
	\legato,1,
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

Pbindef(\ph1).stop;
Pbindef(\ph1).clear;

/*
vorrei fare una linea tra 0.0 e 1.0 lunga 4/4 = 1
ciclico...


Pseg(
		levels:Pseq([0.0, 1.0], inf),
		durs:Pseq([1],inf),
		curves: \linear),

Non va ..

   \amp, Penv(levels:[0.0,1.0,1.0,0.0],times:[0.001,3.998,0.001],curve:'lin'),

1/64 = 0.015625;
Pseries(0.0, 1/(16*4),4);
4/4 * 4 volte
0.125*8

(
var a;
//a = Pseries(0.125,0.125,8);
a = Pseries(0.0,0.015625,64);
a.asStream.nextN(64).plot;
)
To avoid to strt from 0.0 the pseries
we can start from something that is visible i the light like ..
0.25
0.75/64

*/

Env.perc(0.001,0.999,1,8).plot;

(
Pbindef(\ph2,
    \instrument, \DcOuts,
	\legato,1,
	\stretch,4,
    \bus,Pseq([(0..2),(3..5)],inf)+ ~lightsBus.index,
	\amp, Pn(Pseries(0.25,0.01171875,64),inf),
    \env, Pseq([ [Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]],inf),
	\dur, Pseq([1/16],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


(

Pbindef(\ph2, \dur, Pseq([1/2],inf),
	\amp, Pn(Pseries(0.25,0.09375 ,8),inf),
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

(
Pbindef(\ph2, \dur, Pseq([1/4],inf),
	\amp, Pn(Pseries(0.25,0.046875,16),inf),
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\ph2).stop;
Pbindef(\ph2).clear;


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


(
Pbindef(\ph3_grp2, \env, Pseq([[Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]
],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


Pbindef(\ph3_grp2, \dur, Pseq([1],inf),\env, Pseq([[Env.perc(0.999,0.001,1,4)]],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);


( // sequence of Envelopes as well
Pbindef(\ph3_grp2, \dur, Pseq([1],inf),
	\env, Pseq([ [[Env.perc]],[[Env.perc(0.999,0.001,1,4)]] ],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
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

(
Pbindef(\ph3_grp3, \env, Pseq([[Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]
],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\ph3_grp3, \dur, Pseq([1],inf),\env, Pseq([[Env.perc(0.999,0.001,1,4)]],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);

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

(
Pbindef(\ph3_grp4, \env, Pseq([[Env.new([0,1,1,0],[0.0,1.0,0.0], 'lin')]
],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\ph3_grp4, \dur, Pseq([1],inf),\env, Pseq([[Env.perc(0.999,0.001,1,4)]],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);

Pbindef(\ph3_grp4).stop;
Pbindef(\ph3_grp4).clear;


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

Pbindef(\ph4_, \dur, Pseq([1],inf),\env, Pseq([[Env.perc(0.999,0.001,1,4)]],inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);

Pbindef(\ph4_).stop;
Pbindef(\ph4_).clear;


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

(
Pbindef(\ph5,
	\env,Pseq([ [ [Env.perc(0.999,0.001,1,-4)], [Env.perc(0.999,0.001,1,4)] ] ], inf)).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\ph5).stop
Pbindef(\ph5).clear



