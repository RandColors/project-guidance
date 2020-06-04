m = SimpleMIDIFile.read( "C:/Users/ET/Desktop/cartella condivisa/Drums/scores/RoutingFills/Routing_fills.mid");

// x.postcs;
// x.reverse.debug("reverse: ");

// first variation on ...
(
x = m.generatePatternSeqs.flatten(1).debug("midifile: ");
~a = (0..x.size);

x.size.do({ |i|

	~a.put(i,m.noteSustainEvents(channel:0, track:1).wrapAt(i).wrapAt(5));
});
~a.asArray.postcs;

)




(
  Ndef(\monitora){
      var trigs =  InBus.kr(~lightsBus,6);
  	Mix(Compander.ar( Pan2.ar( BPF.ar(WhiteNoise.ar(),1500)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/40);
  }.play;
)
(
var	rest = Rest(0);

~amp = [ 22, 22, 46, 42, 58, 66, 70, 70, 66, 82, 74, 90, 90, 106, 118, 127, 127, 54, 54, 54, 127, 54, 54, 54, 127, 54, 54, 54, 126, 54, 54, 54, 54, 127, 54, 127, 54, 54, 126, 54, 54, 126, 54, 126, 54, 127, 54, 54, 127, 126, 127, 122, 126, 127, 118, 82, 58, 26, 58 ]/127.0;


~md = [ [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 62, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 65, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 69, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 76, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 79, 0.25 ], [ 62, 1 ], [ 65, 0.33177083333333 ], [ 69, 0.3359375 ], [ 72, 0.33229166666667 ], [ 76, 0.33177083333333 ], [ 79, 0.3359375 ], [ 76, 0.5 ], [ 72, 0.5 ], [ 69, 0.5 ], [ 65, 0.5 ]];


/*~amp.size;
~md.size;*/

)

~md.pyramid(1).postcs;
~amp.scramble
pyramid(1).postcs;



(
c = Pbindef(\forward,
    \instrument, \DcOuts,
	\stretch,1,
	\legato,1,
	\amp, Prand([Pseq(~amp.reverse,1),Pseq(~amp,1)],inf),
	[\midinote, \dur], Pseq(~md,inf),
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
			\bus,
		Pfunc { |d| switch(d[\midinote])
			{62}{ 0 }
			{65}{ 1 }
			{69}{ 2 }
			{72}{ 3 }
			{76}{ 4 }
			{79}{ 5 }}
			+ ~lightsBus.index,
	 \finish, ~beatsToSeconds
  ).play(~metro.base ,quant:~metro.base.beatsPerBar);

)

  Ndef(\monitor){
      var trigs = InBus.kr(~lightsBus, 6);
  	Mix(Compander.ar( Pan2.ar( SinOsc.ar(72.midicps)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1),
  		1-trigs
  	),[-1,1])/40);
  }.play;








Pseq([0,1,2,3,4,5],inf).asStream.nextN(5);


(
 Pbindef(\ampAnalysis,
      \instrument, \DcOuts,
  	\stretch,1,
  	\legato,1,
	\amp, Pseq(~amp,inf),
	[\midinote, \dur], Pseq(~md,inf),
	 \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
		\bus,
		Pfunc { |d|
	case
		{ d[\amp] > 0.9 }{ (0..5) }
		{ d[\amp] < 0.5 }{ [(0..5), (0..5)].allTuples;,inf).asStream.next; }
		{ d[\amp] > 0.5 &&   d[\amp] < 0.9 }{ Prand([0,1,2,3,4,5],inf).asStream.next; }
	}


			+ ~lightsBus.index,
      \finish, ~beatsToSeconds
  ).play(~metro.nomes[1] ,quant:~metro.base.beatsPerBar);
)

(

var i, x, z;

z = [0, 1, 1.1, 1.3, 1.5, 2];

i = z.choose;

x = case

	{ i == 1 }   { \no }

	{ i == 1.1 } { \wrong }

	{ i == 1.3 } { \wrong }

	{ i == 1.5 } { \wrong }

	{ i == 2 }   { \wrong }

	{ i == 0 }   { \true };

x.postln;

)