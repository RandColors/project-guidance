m = SimpleMIDIFile.read("C:/Users/ET/Desktop/cartella condivisa/Drums/scores/tuplets/tuplets_Ableton.mid" );

// x.postcs;
// x.reverse.debug("reverse: ");

// first variation on ...
(
x = m.generatePatternSeqs.flatten(1).debug("midifile: ");
~a = (0..x.size);
x.size.do({ |i|
// m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5)
	~a.put(i,m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5));
});
~a.asArray.postcs;

)

 (
  Ndef(\monitor){
      var trigs = InBus.kr(~lightsBus, 3, 0);
  	Mix(Compander.ar( Pan2.ar( SinOsc.ar(72.midicps)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1),
  		1-trigs
  	),[-1,1])/40);
  }.play;
(
  Ndef(\monitora){
      var trigs =  InBus.kr(~lightsBus,6);
  	Mix(Compander.ar( Pan2.ar( BPF.ar(WhiteNoise.ar(),1500)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/40);
  }.play;
)
(
var	rest = Rest(0);

~amp = [ 127, 56, 56, 56, 76, 76, 126, 76, 76, 127, 76, 76, 76, 127, 127, 118, 108, 98, 84, 76, 72, 58, 127, 76, 76, 76, 56, 76, 96, 110, 77, 76, 127, 77, 77, 127, 77, 127, 81, 56, 66, 89, 103, 112, 115, 119, 124, 127, 127, 127, 127, 80, 77, 127, 76, 127, 76, 127, 76, 127, 127, 56, 56, 63 ]/127.0;

~md = [[ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 0.32291666666667 ], [ 72, 0.33333333333333 ], [ 72, 0.34375 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.25 ], [ 72, 0.15625 ], [ 72, 0.16666666666667 ], [ 72, 0.17708333333333 ], [ 72, 0.15625 ], [ 72, 0.16666666666667 ], [ 72, 0.17708333333333 ], [ 72, 0.32291666666667 ], [ rest, 0.33333333333333 ], [ 72, 0.34375 ], [ 72, 0.32291666666667 ], [ 72, 0.33333333333333 ], [ 72, 0.34375 ], [ 72, 0.125 ], [ 72, 0.125 ], [ 72, 0.125 ], [ 72, 0.125 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 1 ], [ 72, 0.15625 ], [ 72, 0.16666666666667 ], [ 72, 0.17708333333333 ], [ 72, 0.15625 ], [ 72, 0.16666666666667 ], [ 72, 0.17708333333333 ], [ 72, 0.13541666666667 ], [ 72, 0.14583333333333 ], [ 72, 0.13541666666667 ], [ 72, 0.14583333333333 ], [ 72, 0.14583333333333 ], [ 72, 0.14583333333333 ], [ 72, 0.14583333333333 ], [ 72, 0.21875 ], [ 72, 0.21875 ], [ 72, 0.21875 ], [ 72, 0.22916666666667 ], [ 72, 0.21875 ], [ 72, 0.21875 ], [ 72, 0.22916666666667 ], [ 72, 0.21875 ], [ 72, 0.22916666666667 ]];

/*
		~amp.size;
~md.size;
		*/
 // Pbinop('==', Pfunc({ [0, 1].choose }), 0), // works
		/* Pif(
				Pbinop('==', Pkey(\midinote), 72),Pseq((3..5),inf),0)
				+ ~lightsBus.index*/
)

(
c = Pbindef(\forward,
    \instrument, \DcOuts,
	\stretch,1,
	\legato,1,
	\amp, Pseq(~amp,1),
	[\midinote, \dur], Pseq(~md,inf).poll,
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),

    \finish, ~beatsToSeconds,
			\bus, Pfunc({ if(Pkey(\midinote) == 72),{0.postln},{1.postln}})
).play(~metro.base);
)

	 Pif( Pfunc({( Pkey(\midinote) == 7)}, 880, \rest ),


		\controlBus, Pfunc({|ev|                              //Choose controlBus basd on freq
		var out=0;
		pitchlist2.do({|item, i|
			if ((ev[\freq].first == (item*base2)), {out = controlBusArray2[i]})
		});
		out;
	}),

(
p = Pbind(
	\amp, 127.0/Pseq(~a,1).poll,
	[\midinote, \dur], Pseq(x,inf),
);


m = SimpleMIDIFile( "C:/Users/ET/Desktop/cartella condivisa/Drums/scores/tuplets/tuplets_Ableton_reverseAll.mid" );
//m.init1( 0, 120, "4/4" );
m.fromPattern( p );
)

m.plot;

m.p.play; // note numbers are not rounded
p.play; // compare
p.stop;

m.write; // when writing to file note numbers are rounded (MIDI file format doesn't allow floats)m 