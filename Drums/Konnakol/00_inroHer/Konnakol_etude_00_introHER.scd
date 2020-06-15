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
// I'm the original
(
{
~a.debug("~a: ");
	0.1.wait;
~midinotes.debug("~midinotes: ");
	0.1.wait;
~durs.debug("~durs: ");
}.fork;
)

// \retrograde  only retrograde melody, keep original rhythm and velocity
(
{
~a.debug("~a: ");
	0.1.wait;
~midinotes_retrograde = ~midinotes.reverse.debug("~midinotes_retrograde: ");
	0.1.wait;
~durs.debug("~durs: ");
}.fork;
)

// \retrograde_all retrograde melody, rhythm and velocity
(
{
~a_retrograde_all = ~a.reverse.debug("~a_retrograde_all: ");
	0.1.wait;
~midinotes_retrograde_all = ~midinotes.reverse.debug("~midinotes_retrograde_all: ");
	0.1.wait;
~durs_retrograde_all = ~durs.reverse.debug("~durs_retrograde_all: ");
}.fork;
)

// inside rest there is a problem ..

(
var a,invertFunc;
 invertFunc = ({| midinotes, around |
	var oldnotes = midinotes;
	var newnotes = (around*2) - oldnotes;
	newnotes;
});

~midinotes_invert = invertFunc.value(~midinotes,7 ).debug("invert");

)

(
~midinotes.do{
	| el, idx |
	("element" + el + "at index" + idx + "was visited.").postln;
};
)







~a: : 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63, 1, 0.63, 0.63, 0.63, 1, 0.63, 0.63, 0.63, 0.63, 0.63, 1, 0.63, 0.63, 0.63, 0.63, 0.63, 1, 0.63, 0.63, 0.63, 0.63, 0.63, 1, 0.63, 0.63, 0.63, 0.63, 0.63, 0.63
~midinotes: : 62, 62, Rest(0), 62, Rest(0), 62, Rest(0), 62, 62, Rest(0), 62, Rest(0), 62, Rest(0), 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62
~durs: : 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 2, 2, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 2, 2, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1.5

/*
The Main Ideas for the arrangment are:
- use the transcription for 1 voice and apply the light arrangment in form of patterns behaviour
- define and apply different Envelopes
- apply velocities to the phrases and accents too.
- switch from the lights to the 6 loudspeakers(use 1 loudspeakers for the accents put inside something clearly different)
- use the lights or the loudspeakers to keep the tempo "Instrument claps" -> define a behaviour for it.

- derive new material like a sort of brunch solos where you use different methods see also the extreme ones like:
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

//Behaviour Basics bb
(
// make a dictionary
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


~bar01_02bus = ((10!18)++(6!6)++(9!4)++(8!13)++(9!3)++(10!1)++(7!5)++(10!1)++(7!5)++(10!1)++(7!5)++(10!1));
~bar01_02env = ((1!18)++(0!6)++(1!4)++(0!13)++(0!3)++(0!19));


Pbindef(\scoretolights,
\instrument, \DcOuts,
\stretch,1,
 	\legato,1,
 	\amp, Pseq(~a,1),
 	\midinote, Pseq(~midinotes,1),
 	\dur, Pseq(~durs,1),
 	\env, Pn(
 		Pswitch1([~p, ~prev],
 		Pseq(~bar01_02env))
 	),
 	\bus,Pn(
		Pswitch1([~zero,~one,~two,~three,~four,~five,~forward,~reverse,~palindrome,~rand,~allparall],
 		Pseq(~bar01_02bus))
 	)+ ~lightsBus.index,
 	\finish, ~beatsToSeconds
 ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)



(
p =Pbind(
	\stretch,1/4,
	\dur, Pseq(~durs,1),
	\legato,1,
	\t,Pswitch1([~zero,~one,~two,~three,~four,~five,~forward,~reverse,~palindrome,~rand,~allparall],
		Pseq(~bar01_02bus)),
	\midi, (Pseq(~midinotes,1)+Pkey(\t)),
	\midinote,Pfunc { |d| switch(d[\midi])
			{62}{ 0 }
			{65}{ 1 }
			{69}{ 2 }
			{72}{ 3 }
			{76}{ 4 }
			{79}{ 5 }})
);

p.asStream.nextN(63, ()).debug("p");
)

	\bus, Pfunc {  switch( (Pseq(~midinotes,1)+Pkey(\t)))
			{62}{ 62 }
			{63}{ 65 }
			{64}{ 69 }
			{65}{ 72 }
			{66}{ 76 }
			{67}{ 79 }}
[ 62, 63, 64, 65, 66, 67 ]
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
Rest([ 0, 1, 2, 3, 4, 5 ])
[ 62, 63, 64, 65, 66, 67 ]
[ 62, 63, 64, 65, 66, 67 ]
[ 62, 63, 64, 65, 66, 67 ]
[ 62, 63, 64, 65, 66, 67 ]
62
63
64
65
66
67
66
64
63
67
62
63
64
65
66
67
66
65
64
63
62
63
64
66
63
64
[ 62, 63, 64, 65, 66, 67 ]
67
66
65
64
63
[ 62, 63, 64, 65, 66, 67 ]
62
67
66
65
64
[ 62, 63, 64, 65, 66, 67 ]
63
62
67
66
65
[ 62, 63, 64, 65, 66, 67 ]


