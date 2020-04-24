// global vars for tempos

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



