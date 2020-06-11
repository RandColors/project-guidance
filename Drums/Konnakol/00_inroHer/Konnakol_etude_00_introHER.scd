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

m.noteSustainEvents(channel:0, track:0)
// a sound
(
  Ndef(\monitora){
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
~a.asArray.postcs.debug("amp: ");
~midinotes.asArray.postcs.debug("midinote: ");
~durs.asArray.postcs.debug("dur: ");
)

// COPY AND PASTE the debug??
midinote: : 62, 62, rest, 62, rest, 62, rest, 62, 62, rest, 62, rest, 62, rest, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62

// change the rest with Rest(0)
(
var	rest = Rest(0);

~midinotes =[ 62, 62, rest, 62, rest, 62, rest, 62, 62, rest, 62, rest, 62, rest, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62];

~a = (~a/127.0);
)

// modify the arrays use List Patterns to do so
(
~a.size;
~midinotes.size;
~durs.size;
)


/*
The Main Idea for the arrangment are:
- use the transcription like 1 note and choose the light arrangment
- define and apply different Envelopes
- apply velocities to the phrases and accents too.
- switch from the lights to the 6 loudspeakers(use 1 loudspeakers for the accents put inside something clearly different)
- use the lights or the loudspeakers to keep the tempo "Instrument claps" -> define a behaviour for it.

- derive new material like a sort of brunch solos where you use different methods see also the extreme ones like:
		- alltuplets or pyramid(n)
		- change the tempoon the same phrase
		- clapping music process

2 + 2 + 2 + 2(legatura) + 16*6 + 2 + 2 + 8
*/

// this are the 5 behaviours choosen
//Behaviour Basics bb
(
~zero  = 0;
~one   = 1;
~two   = 2;
~three = 3;
~four  = 4;
~five  = 5;
~forward = Pseq((0..5)); 			//6
~reverse = Pseq((0..5).reverse);    //7
~palindrome = Pseq((0..5).mirror1);	//8
~rand = Prand((0..5));				//9
~allparall = Pseq([(0..5)]);		//10

// bars behaviours
~bar01_02 = ((8!4)++(7!6)++(10!1)++(9!2));
//	~bar01_02 = ((9!62));

Pbindef(\scoretolights,
    \instrument, \DcOuts,
	\stretch,1,
	\legato,1,
	\amp, Pseq(~a,inf),
	\midinote, Pseq(~midinotes,inf),
	\dur, Pseq(~durs,inf),
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	\bus, Pn(Pswitch1([~zero,~one,~two,~three,~four,~five,
		~forward, ~reverse, ~palindrome, ~rand, ~allparall],
	Pseq(~bar01_02,inf)))
	+ ~lightsBus.index,
	 \finish, ~beatsToSeconds
  ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

~metro.setBpm(178,7);


