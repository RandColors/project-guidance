Same general BPM and multiple patterns with different subdivisions
eg: 4/4 2tuplet groove == bar / 2
eg: 4/4 3tuplet groove == bar / 3
eg: 4/4 4tuplet groove == bar / 4
eg: 4/4 5tuplet groove == bar / 5
eg: 4/4 6tuplet groove == bar / 6
eg: 4/4 7tuplet groove == bar / 7
eg: 4/4 8tuplet groove == bar / 8
eg: 4/4 9tuplet groove == bar / 9
eg: 4/4 10tuplet groove == bar / 10
eg: 4/4 11tuplet groove == bar / 11
eg: 4/4 12tuplet groove == bar / 12
eg: 4/4 13tuplet groove == bar / 13
eg: 4/4 14tuplet groove == bar / 14
eg: 4/4 15tuplet groove == bar / 15
eg: 4/4 16tuplet groove == bar / 16 ??

da sedicesimi 4 sedicesimi per quarto ad undicimine
(4..11).do({ arg item; var result = 4*item;  result.postln}); // iterates

E le terzine ?
E le terzine di qurti?
Ragionatela un attimo ....

(
~bpm = 120;
~beatsPerBar = 4;
~secondPerBar= (60/~bpm)*~beatsPerBar;
"Bar Duration: ".post;~secondPerBar.postln;

// Init metronomes

// Metronomo base
~metroBase = TempoClock.new;
~metroBase.tempo = ~bpm/60;
~metroBase.permanent_(true);
~metroBase.schedAbs(~metroBase.nextBar,{~metroBase.beatsPerBar_(~beatsPerBar)});

{
// make new metronomes relative to the first one.
	~metro = Array.fill(10,{arg i; TempoClock.new(~metroBase.tempo)});
	~metro.put(0,TempoClock.new(~metroBase.tempo * 2.0));
	~metro.put(1,TempoClock.new(~metroBase.tempo * 3.0));
	~metro.put(2,TempoClock.new(~metroBase.tempo * 4.0));
	~metro.put(3,TempoClock.new(~metroBase.tempo / 2.0));
	~metro.put(4,TempoClock.new(~metroBase.tempo / 3.0));
	~metro.put(5,TempoClock.new(~metroBase.tempo / 4.0));
	~metro.put(6,TempoClock.new(~metroBase.tempo * 1.25));
	~metro.put(7,TempoClock.new(~metroBase.tempo / 1.25));
	~metro.put(8,TempoClock.new(~metroBase.tempo * 1.5));
	~metro.put(9,TempoClock.new(~metroBase.tempo / 1.5));

	~metro.do({arg item,i; item.schedAbs(item.nextBar,{item.beatsPerBar_(~metroBase.beatsPerBar  * (~metro[i].tempo/~metroBase.tempo))})});
}.value;



// Attivare e Disattivare Metronomo di Base e Metronomo1



SynthDef(\bleep,{ arg out=0, note=60, amp=1.0;
	var freq, env;
	freq = note.midicps;
	env = EnvGen.ar(Env([0,1,1,0],[0.01, 0.1, 0.2]),levelScale:amp, doneAction:2);
	Out.ar(out,SinOsc.ar(freq) * env);
}).add;



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
(
p = Pxrand([
	Pseq([~playMetroBase],1),
	Pseq([~playMetro1],1)
	], inf).play(~metroBase,quant:~metroBase.beatsPerBar);
)


(
~seqMEtronomes = Routine({
	loop{
	~playMetro1.stop;
	~playMetroBase.play(~metroBase,quant:~metroBase.beatsPerBar);

~metroBase.beatsPerBar.wait;

	~playMetroBase.stop;
	~playMetro1.play(~metro[1],quant:~metro[1].beatsPerBar);

~playMetro1.beatsPerBar.wait;

	}
});
)
~seqMEtronomes.play(~metroBase,quant:~metroBase.beatsPerBar);


// Test metro_N
(
"Beats per bar,
~metroBase".postln;~metroBase.beatsPerBar.postln;
"Beat next Bar, ~metroBase ".postln;~metroBase.nextBar.postln;

"Beats per bar,
~metro[0]".postln;~metro[0].beatsPerBar.postln;
"Beat next Bar, ~metro[0] ".postln;~metro[0].nextBar.postln;

"Beats per bar,
~metro[1]".postln;~metro[1].beatsPerBar.postln;
"Beat next Bar, ~metro[1] ".postln;~metro[1].nextBar.postln;
)

/*
Realizzazione di FRASI ispirate dal lavoro di:
"Takami Nakamoto - Opacity EP Teaser Medley" https://www.youtube.com/watch?v=1e-ZrxPgnR4



~noise = Buffer.readChannel(s,"C:/Program Files (x86)/Rob Papen/Punch/Samples/1 Loops/RP PinkNoise.wav", 0, -1, 0);
SynthDef(\constQ, { |out=0, bufnum=0, amp=0.5, pan, centerPos=0.5, sustain=0.1,
	rate=1, freq=400, rq=0.3|

	var ringtime = (2.4 / (freq * rq) * 0.66).min(0.5); // estimated
	var ampcomp = (rq ** -1) * (400 / freq ** 0.5);
	var envSig = EnvGen.ar(Env([0, amp, 0], [0.5, 0.5] * sustain, \welch));
	var cutoffEnv = EnvGen.kr(Env([1, 1, 0], [sustain+ringtime,0.01]), doneAction: 2);
	var grain = PlayBuf.ar(1, bufnum, rate, 0,
		centerPos - (sustain * rate * 0.5) * BufSampleRate.ir(bufnum),
		1) * envSig;
	var filtered = BPF.ar( grain, freq, rq, ampcomp );
	OffsetOut.ar(out, Pan2.ar(filtered, pan, cutoffEnv))
}, \ir.dup(8)).add;
// Synth(\constQ, [\bufnum, ~noise, \amp, 0.8,\freq, exprand(700, 5000), \rq, exprand(0.01, 0.1), \sustain, 0.01]);


// per fare Modulazioni, cambiare il metronomo di riferimento
es: 8 giri completi delle lampadine, poi cambia rrand(2,6) con un'altro metro di riferimeto..


 // slow drift
Pbindef(\grillini,
	\out,0,
	\bufnum, ~noise,
	\amp,0.4,
	\freq, 115.midicps ,
	\rq, 2,
	\sustain, 0.0001,
	\dur, 1/16 * Pbrown(0.6, 2.4, 0.2,inf)
).play(~metroBase,quant:[0,0]);

// brown acc/dec
Pbindef(\grillini,
		\out,0,
		\bufnum, ~noise,
		\amp,0.4,
		\freq, 115.midicps ,
		\rq, 2,
		\sustain, 0.0001,
\dur, Pstutter(Pwhite(2, 15),Pfunc({ exprand(0.01, 0.3) }),inf)
).play(~metroBase,quant:[0,0]);

Pbindef(\grilliniLoop,
	    \instrument,\constQ,
		\out,0,
		\bufnum, ~noise,
		\amp,106,
		\freq, 115.midicps ,
		\rq,  Pbrown(1.0, 2.0, 0.7),
		\sustain, 0.0001,
	\dur, 1/16 * Pbrown(0.6, 2.4, 0.2)).play(~metro[3],quant:[0,0]);
Pbindef(\grilliniLoop).stop


~grillini2 = {arg amp;
d = Routine{
	Pbindef(\grillini).stop;

	Pbindef(\grillini,
	\out, 0,
	\bufnum, ~noise,
	\amp,0.1,
	\freq, 115.midicps ,
	\rq, 2,
	\sustain, 0.0001,
		\dur, Pstutter(17, Pfunc({ exprand(0.005, 0.03)}))).play(~metroBase,quant:[0,0]);
(~metro[6].tempo).wait; // durata della frase
Pbindef(\grillini).stop;
	};

/////////// Singolini accumuli leggermente caotici
Pbindef(\singolini,
		\instrument,\constQ,
		\out,0,
		\freq, exprand(70, 80).midicps,
		\dur, 1/16  * Pwhite(0.8, 14.2),
		\rq, Pexprand(0.0001, 0.001),
		\sustain, 0.0001 * Pwhite(0.1, 1),
		\amp, Pwhite(3, 15.60)
).play(~metroBase,quant:[0,0]);
Pbindef(\singolini).stop;


// slowing down
Pbindef(\rallentini,
	\instrument,\constQ,
	\out,0,
	\bufnum, ~noise,
	\amp, 1,
	\freq, [57.midicps,62.midicps],
	\rq, 0.1,
	\sustain, Pgeom(0.001, 0.75, 1+8.rand),
	\dur, Pgeom(0.2, 1.3, 9)
).play;
Pbindef(\rallentini).stop;


// è da usare assieme a rimbalzini
Pbindef(\cassini1,
		\instrument,\constQ,
		\bufnum, ~noise,
		\out,0,
		\freq, [35.midicps,27.midicps],
		\dur, 1/16 *Pwhite(0.8, 14.2),
		\rq,0.01,
		\sustain, 0.0001 * Pwhite(0.1, 1),
		\amp, Pwhite(1, 12)
).play(~metroBase,quant:[0,0]);
//(~metro[5].tempo).wait; // durata della frase

Pbindef(\rimbalzini,
		\instrument,\constQ,
		\out,0,
		\freq, exprand(700, 5000),
		\dur, 1/16  * Pwhite(0.8, 14.2),
		\rq, 0.02 * Pwhite(0.2, 6.0),
		\sustain, 0.0001 * Pwhite(0.1, 4),
		\amp, Pwhite(1, 5.60)
).play(~metroBase,quant:[0,0]);

Pbindef(\rimbalzini1,
		\instrument,\constQ,
		\out,0,
		\freq, exprand(700, 5000),
		\dur, 1/16  * Pwhite(0.8, 14.2),
		\rq, 0.02 * Pwhite(0.2, 6.0),
		\sustain, 0.0001 * Pwhite(0.1, 4),
		\amp, Pwhite(1, 12)
).play(~metroBase,quant:[0,0]);


///////////////////RimbalziniComp
// perchè non va ???


Pbindef(\rimbalziniComp,
		\instrument,\constQ,
\bufnum, ~noise,
		\out,0,
		\freq, exprand(700, 5000),
		\dur, 1/16  * Pwhite(0.8, 14.2),
		\rq, 0.02 * Pwhite(0.2, 6.0),
		\sustain, 0.0001 * Pwhite(0.1, 4),
		\amp, Pwhite(1, 5.60)
).play(~metroBase,quant:[0,0]);
Pbindef(\rimbalziniComp).stop;

Pbindef(\rimbalzni2Comp,
	\instrument,\constQ,
	\out,0,
	\bufnum, ~noise,
	\freq, [57.midicps,62.midicps],
	\dur, 1/16  * Pwhite(0.8, 24.2),
	\rq, 0.2 * Pwhite(0.2, 1.0),
	\sustain, 0.0001 * Pwhite(0.1, 2),
	\amp, Pwhite(0.1, 4.0)
).play(~metroBase,quant:[0,0]);
Pbindef(\rimbalzni2Comp).stop;

Pbindef(\rimbalzni3Comp,
	\instrument,\constQ,
	\out,0,
	\bufnum, ~noise,
	\freq, [50.midicps,62.midicps],
	\dur, 1/16  * Pwhite(0.8, 24.2),
	\rq, 0.2 * Pwhite(0.2, 1.0),
	\sustain, 0.0001 * Pwhite(0.1, 2),
	\amp, Pwhite(0.1, 4.0)
).play(~metroBase,quant:[0,0]);
Pbindef(\rimbalzni3Comp).stop;

Pbindef(\singoliniComp,
		\instrument,\constQ,
		\out,0,
		\freq, exprand(50, 80).midicps,
		\dur, 1/16  * Pwhite(0.8, 14.2),
		\rq, Pexprand(0.0001, 0.1),
		\sustain, 0.0001 * Pwhite(0.1, 1),
		\amp, Pwhite(1, 15.60)
).play(~metroBase,quant:[0,0]);
Pbindef(\singoliniComp).stop;

~composito = [Pbindef(\rimbalziniComp),Pbindef(\rimbalzni2Comp),Pbindef(\rimbalzni3Comp),Pbindef(\singoliniComp)];
*/




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

- metti la possibilità di ripetere le frasi n_times,
- introduci una variazione alle frasi, per ogni ripetizione etc..

*/


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

f.value(nil);  // prints nil*/
