// Post the number of output channels
https://scsynth.org/t/discretize-sendcollection/1144/2
s.boot;
(
e = Env([0, 1, 0.5, 0], [0.1, 0.4, 0.8]);
e.discretize(512).plot;


)


// mouse control of trigger rate and startpos
SynthDef(\help_PlayBuf, { arg out=0, bufnum=0;
    var trig;
    trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
    )
}).play(s, [\out, 0, \bufnum, b]);


s.options.numOutputBusChannels_(8);
s.options.numOutputBusChannels.postln;

Server.killAll;
s.boot;
(
s.plotTree;
s.meter;
)

s.scope;
//s.waitForBoot
// Metronomo

~bpm = 60;
~beatsPerBar = 4;
~secondPerBar= (60/~bpm)*~beatsPerBar;
"Bar dur: ".post;~secondPerBar.postln;

// Inizializzazione metronomi

// Metronomo base

~metroBase = TempoClock.new;
~metroBase.tempo = ~bpm/60;
~metroBase.permanent_(true);
~metroBase.schedAbs(~metroBase.nextBar,{~metroBase.beatsPerBar_(~beatsPerBar)});



SynthDef(\clickPing, { |phase = 0, amp = 0.25|
	var silence, s,r;
	s = Impulse.ar(0);
	r = Ringz.ar(s,2000,0.2,3,0);
	silence = DetectSilence.ar(r,time:0.1,doneAction:2);
	Out.ar(0,r*amp);
}).add;


~playMetroBase = Pbind(
	\instrument, \clickPing,
	\stretch,4,
	\amp,0.4,
	\dur,1/4 // bar
	).play(~metroBase,quant:~metroBase.beatsPerBar);


// OscSender~
~n1 = NetAddr("127.0.0.1", 12321);

/*
Soluzione 1 a 1
2 busses - 2 anlaizzatori - 2 out - 2 messaggi
*/

~bus0 = Bus.control(s,1);
~bus1 = Bus.control(s,1);
~bus2 = Bus.control(s,1);
~bus3 = Bus.control(s,1);
~bus4 = Bus.control(s,1);
~bus5 = Bus.control(s,1);


(
~playMetroBase.stop;
~forkSendDati.stop;  // come pause
)


(
~playMetroBase.play(~metroBase,quant:~metroBase.beatsPerBar);
~forkSendDati.reset.play;
)


(
~forkSendDati = {

loop{
		// UNO
OSCdef(\getamp1,{
	~n1.sendMsg('/amp1',~bus0.getSynchronous.asFloat);
				}, "/getamp1");
		// DUE
	OSCdef(\getamp2,{
    ~n1.sendMsg('/amp2',~bus1.getSynchronous.asFloat);
	}, "/getamp2");

		// TRE
OSCdef(\getamp3,{
	~n1.sendMsg('/amp3',~bus2.getSynchronous.asFloat);
				}, "/getamp3");

		// QUATTRO
OSCdef(\getamp4,{
	~n1.sendMsg('/amp4',~bus3.getSynchronous.asFloat);
				}, "/getamp4");

			// CINQUE
OSCdef(\getamp5,{
	~n1.sendMsg('/amp5',~bus4.getSynchronous.asFloat);
				}, "/getamp5");

			// SEI
OSCdef(\getamp6,{
	~n1.sendMsg('/amp6',~bus5.getSynchronous.asFloat);
				}, "/getamp6");

	0.01.wait;
	}

}.fork;
)

~forkSendDati.reset.play;
~forkSendDati.stop;   // come pause


// Un segnale audio che viene analizzato e sparato fuori da uno dei BUS

/*(
SynthDef(\DcOuts,{|amp=0.1,dur=0.2,bus,atk=0.1,an_Scale =1.0|
		var sig,env,analysis;
	    sig = DC.ar(1.0); // segnale massimo = o db
		env =  EnvGen.kr(Env.perc(atk,dur-atk), doneAction:2);
		sig = sig*env;

	analysis = Amplitude.kr(sig).ampdb.linlin(-30.0, 0.0, 0.0, 1.0);

	Out.kr(bus,analysis*an_Scale);


//Out.ar(outKR,sig);
}).add;
{~dcOuts = Synth(\DcOuts, [\bus, ~bus1.index])}.defer(0.1);
)
~dcOuts = Synth(\DcOuts, [\bus,~bus++6.rand]);*/



(
SynthDef(\DcOuts,{|ampSig=0.1,envdur=1.0,bus,atk=0.1,rel=0.1,curva=4,fakeTime,fakeBpm|
		var sig,env;
	    sig = DC.ar(ampSig);
	env =  EnvGen.kr(Env([0.0,1.0,1,0,0.0], [atk,envdur-(atk+rel),rel],curva), doneAction:2);
		sig = sig*env;

	Out.kr(bus,sig);
}).add;
{~dcOuts = Synth(\DcOuts, [\bus, ~bus1.index])}.defer(0.1);
)
~dcOuts = Synth(\DcOuts, [\bus,~bus++6.rand,\atk,1,\envdur,1.0,\rel,1,\curva,\lin,\ampSig,1]);



/*
https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook05_Using_Samples.html

- scrivere un segnale in un buffer, utilizzare gli inviluppi perchè sono comodi per essere scritti.
- leggere il segnale tramite PlayBuf o bufRd o Phasor ...
- leggere il segnale alla velocità giusta per  essere n synch con i pattern e pensare in 1/4 1/8 etc ...


(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// one loop segment
SynthDef(\oneLoop, { |out, bufnum, start, time, amp, rate = 1|
    var sig = PlayBuf.ar(1, bufnum,
        rate: rate * BufRateScale.kr(bufnum),
        startPos: start, loop: 0
    ),
    env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp),
        doneAction: Done.freeSelf);
    Out.ar(out, (sig * env).dup);
}).add;

SynthDef(\bell, { |out, accent = 0, amp = 0.1, decayScale = 1|
    var exc = PinkNoise.ar(amp)
    * Decay2.kr(Impulse.kr(0), 0.01, 0.05),
    sig = Klank.ar(`[
        { ExpRand(400, 1600) } ! 4,
        1 ! 4,
        { ExpRand(0.1, 0.4) } ! 4
    ], exc, freqscale: accent + 1, decayscale: decayScale);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(out, sig.dup)
}).add;
)

(
var start = 0.404561, end = 3.185917,
beatsInLoop = 4,
originalTempo = beatsInLoop / (end - start);

TempoClock.tempo = originalTempo;

p = Ptpar([
    0, Pbind(
        \instrument, \oneLoop,
        \bufnum, b,
        \amp, 0.4,
        \start, start * b.sampleRate,
        \dur, beatsInLoop,
        \time, Pkey(\dur) / Pfunc { thisThread.clock.tempo },
        \rate, Pfunc { thisThread.clock.tempo / originalTempo }
    ),
    0.5, Pn(
        Pfindur(4,
            Pbind(
                \instrument, \bell,
                \accent, Pseq([2, Pn(0, inf)], 1),
                \amp, Pseq([0.3, Pn(0.1, inf)], 1),
                \decayScale, Pseq([6, Pn(1, inf)], 1),
                \dur, Pwrand(#[0.25, 0.5, 0.75, 1], #[2, 3, 1, 1].normalizeSum, inf)
            )
        ),
    inf),
    0.5, Pbind(
        \instrument, \bell,
        \accent, -0.6,
        \amp, 0.2,
        \decayScale, 0.1,
        \dur, 1
    )
], 1).play;
)

// for fun, change tempo
// resyncs on next bar
TempoClock.tempo = 124/60;

p.stop;
(
SynthDef(\bufOuts,{|ampSig=0.1,envdur=1.0,bus,atk=0.1,rel=0.1,curva=4,fakeTime,fakeBpm|
	var sig,env;
	sig = DC.ar(ampSig);
	env =  EnvGen.kr(Env([0.0,1.0,1,0,0.0], [atk,envdur-(atk+rel),rel],curva), doneAction:2);
	sig = sig*env;

	Out.kr(bus,sig);
}).add;
{~dcOuts = Synth(\DcOuts, [\bus, ~bus1.index])}.defer(0.1);
)


~\bufOuts = Synth(\bufOuts, [\bus,~bus++6.rand,\atk,1,\envdur,1.0,\rel,1,\curva,\lin,\ampSig,1]);

{
	e = Env.sine.asStream;
	5.do({
		e.next.postln;
		0.25.wait;
})}.fork
)
Inherit

(
{
	e = Env.sine.asStream;
	5.do({
		e.next.postln;
		0.25.wait;
})}.fork
)

(
a = Signal.newClear(16);
a.waveFill({ arg x, prev, i; [x, prev, i].postln; sin(x).max(0) }, 0, 3pi);
a.plot;
)


(
// make some white noise
v = FloatArray.fill(44100, {1.0.ra}.plot);

//b = Env.linen(0.1, 0.2, 0.1, 0.6).asSignal.plot;
b = Buffer.alloc(s, 44100);
)
(
// load the FloatArray into b, then play it
b.loadCollection(v, action: {|buf|
	x = { PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf), loop: 1)
	* 0.2 }.play;
});
)
x.free;

Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'lin', offset: 0).plot()
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'lin', offset: 0).plot();
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'step', offset: 0).plot();
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'exp', offset: 0).plot();
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'sine', offset: 0).plot();
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'sqr', offset: 0).plot();
// Env.new(levels: [ 0, 1, 0 ], times: [ 1, 1 ], curve: 'cub', offset: 0).plot();

(
[Env([0,0.5,0.1,0],        [0.1,0.2,1], \step),      // Scalini
	Env([0,0.5,0.1,0],        [0.1,0.2,1], \lin),       // Curva lineare
	Env([0.0001,0.5,0.1,0.0001],[0.1,0.2,1], \exp),     // Curva esponenziale
	Env([0,0.5,0.1,0],        [0.1,0.2,1], \sin),       // Curva sinusoidale
	Env([0,0.5,0.1,0],        [0.1,0.2,1], \wel),       // Curva welch
	Env([0,0.5,0.1,0],        [0.1,0.2,1], \sqr),       // Curva radice
Env([0,0.5,0.1,0],        [0.1,0.2,1], \cub)].plot; // Curva quartica
)

(
[Env([0,0.5,0.1,0],[0.1,0.2,1], -0.8),           // Curva logaritmica_n
Env([0,0.5,0.1,0],[0.1,0.2,1],  0.8)].plot      // Curva esponenziale_n
)

(
{EnvGen.kr(
	Env.new([0,1,0.1,0],[0.01,0.7,1], \cub), // Istanza inviluppo
	1)                                       // gate
}.scope;
)


s.boot;
s.scope(1);
s.meter(1,1);

(
SynthDef(\envi,
	{arg freq, gate=0;
		var sig,bpf,env;
		// sig = SinOsc.ar(freq);
		bpf = Env.new([0,1,0.3,0],[0.01,0.2,3],\cub, 2); // aggiunto un nuovo argomento (2)
		env = EnvGen.kr(bpf,gate,doneAction:0).scope;          // doneAction:0
		Out.ar(0,env)
	}
).add;

{a = Synth(\envi)}.defer(0.01);        // creo una sola istanza
)

a.set(\freq,rrand(200,2000), \gate,1); // note on
a.set(\gate,0);




Env.linen(1, 2, 3, 0.6).test.plot;
Env.linen(1, 2, 3, 0.6, \sine).test.plot;
Env.linen(1, 2, 3, 0.6, \welch).test.plot;
Env.linen(1, 2, 3, 0.6, -3).test.plot;
Env.linen(1, 2, 3, 0.6, -3).test.plot;
Env.linen(1, 2, 3, 0.6, [[\sine, \welch, \lin, \exp]]).plot; // Confronto grafico...



Wavetable.sineFill(512, [1]).asSignal.plot;
*/


// note off
// Itera su tutti

// .reverse .scramble
~tutti = ~bus++(0..5)// [~bus1,~bus2,~bus3,~bus4,~bus5,~bus6];

(
Pbindef(\tutti).stop;
 Pbindef(\tutti,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,1/4*(60/~bpm)*~beatsPerBar;,
	\atk,0.1*(60/~bpm)*~beatsPerBar;,
	\rel,0.0*(60/~bpm)*~beatsPerBar;,
	\curva,\lin,
	\bus,Pseq(~tutti,inf),
	\dur,1/4,
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\tutti).stop;


(
Pbindef(\reverse).stop;
 Pbindef(\reverse,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,1/8*(60/~bpm)*~beatsPerBar;,
	\atk,0*(60/~bpm)*~beatsPerBar;,
	\rel,0*(60/~bpm)*~beatsPerBar;,
	\curva,\lin,
	\bus,Pseq(~tutti.reverse,inf),
	\dur,1/8,
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\reverse).stop;


(
Pbindef(\palindromo).stop;
 Pbindef(\palindromo,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,1/8*(60/~bpm)*~beatsPerBar;,
	\atk,0*(60/~bpm)*~beatsPerBar;,
	\rel,0*(60/~bpm)*~beatsPerBar;,
	\curva,\lin,
	\bus,Pseq(~tutti.mirror1,inf),
	\dur,1/8,
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\palindromo).stop;


(
Pbindef(\scramble).stop;
 Pbindef(\scramble,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,1/8*(60/~bpm)*~beatsPerBar;,
	\atk,0*(60/~bpm)*~beatsPerBar;,
	\rel,0*(60/~bpm)*~beatsPerBar;,
	\curva,\lin,
	\bus,Pseq(~tutti.scramble,inf),
	\dur,1/8,
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\scramble).stop;

(
Pbindef(\scramble).stop;
 Pbindef(\scramble,
\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,1*(60/~bpm)*~beatsPerBar;,
	\atk,0*(60/~bpm)*~beatsPerBar;,
	\rel,0*(60/~bpm)*~beatsPerBar;,
	\curva,\lin,
	\bus,Pseq([Pseq(~tutti.scramble,1)++Pseq(~tutti,1)],inf),
	\dur,Pseq(
		(1/8!6)++
		(1/32!6))
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\scramble).stop;



/*
Realizzazione di FRASI ispirate dal lavoro di:
"Takami Nakamoto - Opacity EP Teaser Medley" https://www.youtube.com/watch?v=1e-ZrxPgnR4

Frase 1: Crescendo su metà delle luci con inviluppo esponenziale
la prima metà A e poi B già al massimo(255) stabile.
fai che A e B sia intercambiabili.
Frase 2: alternato, con crescendo 3DX/3SX.
Frase 3: fai gruppi di 2-3 e sposta l'offset sulla circonferenza(avanza).


Frase 4:

Frase 5: stesso punto di partenza temporale dur, ma con diversi tempi di inviluppo

*/
(
~playMetroBase.stop;
~forkSendDati.stop;  // come pause
)


(
~playMetroBase.play(~metroBase,quant:~metroBase.beatsPerBar);
~forkSendDati.reset.play;
)

(
Pbindef(\frase1).stop;
 Pbindef(\frase1,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\envdur,Pseq([1.0*(60/~bpm)*~beatsPerBar,1/4*(60/~bpm)*~beatsPerBar],inf),
	\atk,Pseq([1.0*(60/~bpm)*~beatsPerBar,0.0001*(60/~bpm)*~beatsPerBar],inf),
	\rel,Pseq([0.0001*(60/~bpm)*~beatsPerBar,1/4*(60/~bpm)*~beatsPerBar],inf),
	\curva,\exp,
	\bus,Pseq([~bus++(0..2),~bus++(3..5)],inf),
	\dur,Pseq([1,1/4],inf),
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\frase1).stop;


(
Pbindef(\frase2).stop;
 Pbindef(\frase2,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,1/4,
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,Pseq([
		~bus++(0..2),
		~bus++(3..5)
	],inf),
	\dur,Pseq([1/4],inf)
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\frase2).stop;


(
Pbindef(\frase3).stop;
 Pbindef(\frase3,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,1/12,
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,
	Ptuple([
    ~bus++Pseq([0,1,2,3,4,5],inf),
	~bus++Pseq([1,2,3,4,5,0],inf),
	~bus++Pseq([2,3,4,5,0,1],inf)
    ],inf),
	\dur,Pseq([1/12],inf)
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\frase3).stop;



// Stesso inviluppo punto di partenza temporale diverso


(
~playMetroBase.play(~metroBase,quant:~metroBase.beatsPerBar);
~forkSendDati.reset.play;
)

(
~refreshME =({| times, dur|
~comp4_DUR = dur;
~comp4_fakeTime = times;

~comp4_0 = Pbindef(\comp4_0,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[0],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus0,
	\dur,~comp4_DUR
);

~comp4_1 = Pbindef(\comp4_1,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[1],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus1,
	\dur,~comp4_DUR
	);

~comp4_2 = Pbindef(\comp4_2,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[2],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus2,
	\dur,~comp4_DUR
	);

~comp4_3 = Pbindef(\comp4_3,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[3],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus3,
	\dur,~comp4_DUR
	);

~comp4_4 = Pbindef(\comp4_4,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[4],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus4,
	\dur,~comp4_DUR
	);

~comp4_5 = Pbindef(\comp4_5,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,~comp4_fakeTime[5],
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,~bus5,
	\dur,~comp4_DUR
	);

});
)

~refreshME.value(1*[1, 2, 1.5, 3, 2.5, 1.75].scramble,3).postln;
Ppar([~comp4_0,~comp4_1,~comp4_2,~comp4_3,~comp4_4,~comp4_5],1).play(~metroBase, quant:~metroBase.beatsPerBar);
Ppar([~comp4_0,~comp4_1,~comp4_2,~comp4_3,~comp4_4,~comp4_5]).stop;



// stesso punto di partenza temporale dur, ma con diversi tempi di inviluppo
(
Pbindef(\frase5).stop;
 Pbindef(\frase5,
	\instrument, \DcOuts,
	\stretch,4,
	\ampSig,1,
	\fakeTime,Pxrand([1,2,3,4],inf),
	\fakeBpm,(60/~bpm)*~beatsPerBar,
	\envdur,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\atk,Pseq([Pkey(\fakeTime)*Pkey(\fakeBpm),0.0001*Pkey(\fakeBpm)],inf),
	\rel,Pseq([0.0001*Pkey(\fakeBpm),Pkey(\fakeTime)*Pkey(\fakeBpm)],inf),
	\curva,\exp,
	\bus,Pfunc({~bus++6.rand}),
	\dur,1,
	).play(~metroBase, quant:~metroBase.beatsPerBar);
)
Pbindef(\frase5).stop;


(
Pbindef(\fraseTest).stop;
 Pbindef(\fraseTest,
	\instrument, \DcOuts,
	\bus,Pseq([
		Pseq(~tutti.mirror1,1)++
		Pseq(~tutti.reverse,1)++
		Pseq(~tutti.reverse,1)++
		Pseq(~tutti.reverse,1)++
		Pseq(~tutti,1)++
		Pseq(~tutti.scramble,1)
	],inf),
	\stretch,4,
	\dur,Pseq(
		(1/8!8)++
		(1/8!6)++
		(1/12!6)++
		(1/16!5)++
		(1/8!6)++
		(1/16!24)
,inf)
	).play(~metroBase ,quant:~metroBase.beatsPerBar);
)
Pbindef(\frase1).stop;


/*

// sequenze predeterminate No Suono Sync

// VELOCITA' REGOLARE
- mettere il num repetitions e la direzione
- con sramble è random starting point
// OscSender~
~n1 = NetAddr("127.0.0.1", 12000);

(
~uno = (
//~myArr = [255,0];
~offsetN = 0;
~offsetVAl = 0;
~preAddMe = Array.fill(~offsetN,~offsetVAl);
//~myArr2val = [255,60,0,0,0,60];

~myArr = [255,0,0,0,0,0];
r = Routine({


	var ciclo = 6;// numero di lampadine che verranno accese
	var nTimes = 2; // n ripetizioni
	var metro = 4; // 4/4 è lo stretch
	var dur = (60/180)*metro*1/8;
	var c;

	(ciclo*nTimes).do({|i|

		c = ~myArr.rotate(i%ciclo);
		c = ~preAddMe++c;

		~n1.sendMsg('/test',c[0],c[1],c[2],c[3],c[4],c[5]);
		dur.yield;
		~n1.sendMsg('/test',0,0,0,0,0,0); // turn all OFF
	})

})
))

~uno.reset.play(~metroBase,quant:[~metroBase.timeToNextBeat,0]);



// LOOP FUNCTION

// due elementi cambiano Offset
// Il cerchio nn si chiude trova il modo di far tornare come primo elemento dell array
(60/180)*4*1/8

24* 0.16666666666667

// Frase
(

/*
~myArr = [255,0];
~offsetN = 4.rand;
~offsetVAl = 0;
~preAddMe = Array.fill(~offsetN,~offsetVAl);*/
//~myArr2val = [255,60,0,0,0,60];

//~myArr = [255,0,0,0,0,0];

r = Routine({
var myArr = [255,0];
var offsetN = 0;
var offsetVAl = 0;
var preAddMe = Array.fill(offsetN,offsetVAl);

	var ciclo = 6;// numero di lampadine che verranno accese
	var nTimes = 4; // n ripetizioni
	var metro = 4; // 4/4 è lo stretch
	var dur = (60/180)*metro*1/8;
	var c;

	(ciclo*nTimes).do({
		|i|

		c = ~myArr.rotate(i%ciclo);
		c = preAddMe++c;

		~n1.sendMsg('/test',c[0],c[1],c[2],c[3],c[4],c[5]);
		dur.yield;
		~n1.sendMsg('/test',0,0,0,0,0,0); // turn all OFF

	})

}).reset.play(~metroBase,quant:[~metroBase.timeToNextBeat,0]);
)

r.stop;




f = { arg x = 1; x };
f.value(12);  // prints 2

f.value;   // prints 1

f.value(nil);  // prints nil
