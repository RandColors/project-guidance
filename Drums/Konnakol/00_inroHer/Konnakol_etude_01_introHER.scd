::::::::::::::::::::::::::::::::::::::::::::
Konnakkol & Quads
Amir Oosman

https://www.youtube.com/watch?v=jA_3g8zgMf0
// Transcription here
https://www.soundslice.com/slices/PzDcc/
::::::::::::::::::::::::::::::::::::::::::::

/*
BPM  1/4 == 178
7/4 meter
Instrument Claps
voice
percussion "6 toms"
136 BARS
*/
// prepare the midifiles
m = SimpleMIDIFile.read("C:/Users/ET/Desktop/cartella condivisa/Drums/Konnakol/00_inroHer/00_IntroHER.mid");

"C:/Users/ET/Desktop/cartella condivisa/Drums/Konnakol/00_inroHer/00_IntroHERArranged.mid"

m.noteSustainEvents(channel:0, track:0)
// a sound
(
~sound =  Ndef(\monitora){
      var trigs =  InBus.kr(~lightsBus,6);
  	Mix(Compander.ar( Pan2.ar( BPF.ar(WhiteNoise.ar(),1500)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/40);
  }.play;
)

(
// generate the pattern from the midi file
x = m.generatePatternSeqs.flatten(1).postcs;
x.size;
// Init the arrays
~durs = (0..x.size-1);
~midinotes = (0..x.size-1);
~a = (0..x.size-1);

// split the values inside the proper patterns
x.size.do({ |i|
	~a.put(i,m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5));
	~midinotes.put(i,x.wrapAt(i).wrapAt(0));
	~durs.put(i,x.wrapAt(i).wrapAt(1));
});
~a.asArray.debug("amp: ");
~midinotes.asArray.debug("midinote: ");
~durs.asArray.debug("dur: ");
)

// COPY AND PASTE midinote debug()
midinote: : 62, 62, rest, 62, rest, 62, rest, 62, 62, rest, 62, rest, 62, rest, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62



// PASTE and change the rests with Rest(0) and scale Velocity to amp
(
var	rest = Rest(0);

~midinotes =[ 62, 62, rest, 62, rest, 62, rest, 62, 62, rest, 62, rest, 62, rest, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62];

~a = (~a /127);
~a = ~a.round(0.01);
)

//check if the arrays have all the same size
(
{
~a.size.debug("~a.size: ");
	0.1.wait;
~midinotes.size.debug("~midinotes.size: ");
	0.1.wait;
~durs.size.debug("~durs.size: ");
}.fork;
)


// Now that you have everything splitted you can transform the different data

(
// put on top the lights arrangment
// make a dictionary of envs
~p = [Env.perc(0.001,0.999,1,4)];
~prev = [Env.perc(0.999,0.001,1,4)];

~zero  = Pseq([0],inf);
~one   = Pseq([1],inf);
~two   = Pseq([2],inf);
~three = Pseq([3],inf);
~four  = Pseq([4],inf);
~five  = Pseq([5],inf);
~forward = Pseq((0..5),inf); 			//6
~reverse = Pseq((0..5).reverse,inf);    //7
~palindrome = Pseq((0..5).mirror1,inf);	//8
~rand = Prand((0..5),inf);				//9
~allparall = Pseq([(0..5)],inf);		//10


// check the size of the arrays they have to be == to eachothers and correct respect to the score
~bar01_02bus = ((10!18)++(6!6)++(9!4)++(8!13)++(9!3)++(10!1)++(7!5)++(10!1)++(7!5)++(10!1)++(7!5)++(10!1));
~bar01_02env = ((1!18)++(0!6)++(1!4)++(0!13)++(0!3)++(0!19));


~bar01_02Arrang = Pswitch1([~zero,~one,~two,~three,~four,~five,~forward,~reverse,~palindrome,~rand,~allparall],
	Pseq(~bar01_02bus));


~bar01_02lightsbehave = ~bar01_02Arrang.asStream.nextN(~bar01_02bus.size, ()).debug("~bar01_02Arrang: " );
~bar01_02lightsbehave;
({
	~bar01_02bus.size.debug("~bar01_02bus.size: ");
	0.01.wait;
	~bar01_02env.size.debug("~bar01_02env.size: ");

}.fork;
)

)



/*
The Main Ideas for the arrangment are:
- use the transcription for 1 voice and apply the light arrangment in form of patterns behaviour
- define and apply different Envelopes
- apply velocities to the phrases and accents too.
- switch from the lights to the 6 loudspeakers(use 1 loudspeakers for the accents put inside something clearly different)
- use the lights or the loudspeakers to keep the tempo "Instrument claps" -> define a behaviour for it.

- derive new material like a sort of branch solos where you use different methods see also the extreme ones like:
		- alltuplets or pyramid(n)
		- change the tempo on the same phrase (metric modulations)
		- clapping music process
		- polyrhithmic generator https://mynoise.net/NoiseMachines/polyrhythmBeatGenerator.php
				Light arrangment  half lights vs half lights
											3-against-2
											4-against-3
											6-against-4
											8-against-6


2 + 2 + 2 + 2(legatura) + 16*6 + 2 + 2 + 8
*/

// set the BPM
~metro.setBpm(178,7);

// ndef
~sound.play;
~sound.stop;

//Behaviour Basics bb

(
 Pbindef(\scoretolights,
 	\instrument, \DcOuts,
 	\stretch,1,
 	\legato,1,
 	\amp, Pseq(~a,1),
 	\midinote, Pseq(~midinotes,1),
 	\dur, Pseq(~durs,1),
 	\env, Pn(Pswitch1([~p, ~prev], Pseq(~bar01_02env))),
 	\bus,Pseq(~bar01_02lightsbehave,1) + ~lightsBus.index,
 	\finish, ~beatsToSeconds
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


// retrograde
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.reverse,1),
 	\midinote, Pseq(~midinotes.reverse,1),
 	\dur, Pseq(~durs,1),
 	\bus,Pseq(~bar01_02lightsbehave.reverse,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


//retrograde  all
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.reverse,1),
 	\midinote, Pseq(~midinotes.reverse,1),
 	\dur, Pseq(~durs.reverse,1),
 	\bus,Pseq(~bar01_02lightsbehave.reverse,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// mirror
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.mirror,1),
 	\midinote, Pseq(~midinotes.mirror,1),
 	\dur, Pseq(~durs.mirror,1),
 	\bus,Pseq(~bar01_02lightsbehave.mirror,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

//  mirror1
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.mirror1,1),
 	\midinote, Pseq(~midinotes.mirror1,1),
 	\dur, Pseq(~durs.mirror1,1),
 	\bus,Pseq(~bar01_02lightsbehave.mirror1,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

//  mirror2
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.mirror2,1),
 	\midinote, Pseq(~midinotes.mirror2,1),
 	\dur, Pseq(~durs.mirror2,1),
 	\bus,Pseq(~bar01_02lightsbehave.mirror2,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// scramble
(
 Pbindef(\scoretolights,
 	\amp, Pseq(~a.scramble,1),
 	\midinote, Pseq(~midinotes.scramble,1),
 	\dur, Pseq(~durs.scramble,1),
 	\bus,Pseq(~bar01_02lightsbehave.scramble,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// powerset, there are too many elements


/*
.pyramid(patternType: 1)
Return a new Array whose elements have been reordered via one of 10 “counting” algorithms. Run the examples to see the algorithms.
*/

(
// ~a.pyramid(algo): SIZE .... 3969
// 2 e 4 e 5
var algo = 5;
~a.pyramid(algo).debug("~a.pyramid(algo)"  );
~midinotes.pyramid(algo).debug("~midinotes.pyramid(algo) " );
~durs.pyramid(algo).debug("~durs.pyramid(algo) " );
~bar01_02lightsbehave.pyramid(algo).debug("~bar01_02lightsbehave.pyramid(algo) " );

 Pbindef(\scoretolights,
	\amp, Pseq(~a.pyramid(algo),1),
 	\midinote, Pseq(~midinotes.pyramid(algo),1),
 	\dur, Pseq(~durs.pyramid(algo),1),
 	\bus,Pseq(~bar01_02lightsbehave.pyramid(algo),1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


(
// SLIDE 6:2 bello
var  a,b;
a = 6;
b = 2;
~a.slide(a, b).debug("~a.slide(a, b)"  );
~midinotes.slide(a, b).debug("~midinotes.slide(a, b) " );
~durs.slide(a, b).debug("~durs.slide(a, b) " );
~bar01_02lightsbehave.slide(a, b).debug("~bar01_02lightsbehave.slide(a, b) " );


 Pbindef(\scoretolights,
	\amp, Pseq(~a.slide(a, b),1),
 	\midinote, Pseq(~midinotes.slide(a, b),1),
 	\dur, Pseq(~durs.slide(a, b),1),
 	\bus,Pseq(~bar01_02lightsbehave.slide(a, b),1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)



(
// Stutter bello
var  a,b;
a = 6;

~a.stutter(a).debug("~a.stutter(a)"  );
~midinotes.stutter(a).debug("~midinotes.stutter(a) " );
~durs.stutter(a).debug("~durs.stutter(a) " );
~bar01_02lightsbehave.stutter(a).debug("~bar01_02lightsbehave.stutter(a) " );


 Pbindef(\scoretolights,
	\amp, Pseq(~a.stutter(a),1),
 	\midinote, Pseq(~midinotes.stutter(a),1),
 	\dur, Pseq(~durs.stutter(a),1),
 	\bus,Pseq(~bar01_02lightsbehave.stutter(a),1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// sputter  decidi la posizione dove andrà ad agire

(
// Stutter bello
var  a,b;
a = 0.9;
b = 100;

~a.sputter(a, b).debug("~a.stutter(a)"  );
~midinotes.sputter(a, b).debug("~midinotes.stutter(a) " );
~durs.sputter(a, b).debug("~durs.stutter(a) " );
~bar01_02lightsbehave.sputter(a, b).debug("~bar01_02lightsbehave.stutter(a) " );

 Pbindef(\scoretolights,
	\amp, Pseq(~a.sputter(a, b),1),
 	\midinote, Pseq(~midinotes.sputter(a, b),1),
 	\dur, Pseq(~durs.sputter(a, b),1),
 	\bus,Pseq(~bar01_02lightsbehave.sputter(a, b),1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


// all tuplets
(


~a.size;
[~a,~a.reverse].allTuples.flat.size.postln;//.size;
[~midinotes,~midinotes.reverse].allTuples.flat;
[~durs,1/64].allTuples.flat;
[~bar01_02lightsbehave,~bar01_02lightsbehave.reverse].allTuples.flat
/*//debug("~a.allTup(a)"  );
~midinotes.sputter(a, b).debug("~midinotes.stutter(a) " );
~durs.sputter(a, b).debug("~durs.stutter(a) " );
~bar01_02lightsbehave.sputter(a, b).debug("~bar01_02lightsbehave.stutter(a) " );*/

 Pbindef(\scoretolights,
	\amp, Pseq([~a,~a.reverse].allTuples.flat,1),
 	\midinote, Pseq([~midinotes,~midinotes.reverse].allTuples.flat,1),
 	\dur, Pseq([~durs,1/64].allTuples.flat,1),
 	\bus,Pseq([~bar01_02lightsbehave,~bar01_02lightsbehave.reverse].allTuples.flat,1) + ~lightsBus.index,
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)






// dividi e rendi midi file
// (
// Pbindef(\router,
// 	\instrument, \DcOuts,
// 	\stretch,1,
// 	\legato,1,
// 	\amp, Pseq(~a),
// 	\midinote, Pseq(~midinotes),
// 	\dur, Pseq(~dur),
// 	\env, Pn(Pswitch1([~p, ~prev], Pseq(~bar01_02env))),
// 	\bus,	\bus, Pfunc { |d| switch(d[\midinote])
// 		{62}{ 0 }
// 		{65}{ 1 }
// 		{69}{ 2 }
// 		{72}{ 3 }
// 		{76}{ 4 }
// 	{79}{ 5 }} + ~lightsBus.index,
//
// 	\finish, ~beatsToSeconds
// ).play(~metro.base ,quant:~metro.base.beatsPerBar);
//
// )
//
//
//
// //0.3374
//
// // needs manual quantization in 16th in ableton..
// (
// p = Pbind(
// 	\stretch,0.337073,
// 	\legato,1,
// 	\dur, Pseq(~durs,1),
// 	\amp, Pseq(~a,1),
// 	\midinote, Pseq(~midinotes,1);
// );
// p.asStream.nextN(1, ()).debug("p");
//
// ~midiout = SimpleMIDIFile( "~/Desktop/testPatArranged.mid" );
// ~midiout.init1(0, 178, "7/4" );
// ~midiout.fromPattern( p );
// ~midiout.write;
// )
//
// ~midiout.plot;
//
// ~midiout.p.play; // note numbers are not rounded
// p.play; // compare
//
// // when writing to file note numbers are rounded (MIDI file format doesn't allow floats)
//
