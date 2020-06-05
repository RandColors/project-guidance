m = SimpleMIDIFile.read( "C:/Users/ET/Desktop/cartella condivisa/Drums/scores/RoutingFills/Routing_fills.mid");

// a sound
(
  Ndef(\monitora){
      var trigs =  InBus.kr(~lightsBus,6);
  	Mix(Compander.ar( Pan2.ar( BPF.ar(WhiteNoise.ar(),1500)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/40);
  }.play;
)

(
// generate the pattern from the midi file
x = m.generatePatternSeqs.flatten(1);

// Init the arrays
~durs = (0..x.size-1);
~midinotes = (0..x.size-1);
~a = (0..x.size-1);

// split the values inside the proper patterns
x.size.do({ |i|
	~a.put(i,m.noteSustainEvents(channel:0, track:1).wrapAt(i).wrapAt(5));
	~midinotes.put(i,m.noteSustainEvents(channel:0, track:1).wrapAt(i).wrapAt(4));
	~durs.put(i,x.wrapAt(i).wrapAt(1));
});
~a.asArray.postcs.debug("amp: ");
~midinotes.asArray.postcs.debug("midinote: ");
~durs.asArray.postcs.debug("dur: ");
)


// change the rest with Rest(0)
(
var	rest = Rest(0);
~midinotes = [ 62, 62, 62, 62, 62, 62, 62, 62, 65, 65, 65, 65, 65, 65, 65, 65, 69, 69, 69, 69, 69, 69, 69, 69, 72, 72, 72, 72, 72, 72, 72, 72, 76, 76, 76, 76, 76, 76, 76, 76, 79, 79, 79, 79, 79, 79, 79, 79, 62, 65, 69, 72, 76, 79, 76, 72, 69, 65];

~a = (~a/127.0);
)

// modify the arrays use List Patterns to do so
(
~a.size;
~midinotes.size;
~durs.size;
)


(
Pbindef(\pureScore,
    \instrument, \DcOuts,
	\stretch,1,
	\legato,1,
	\amp, Pseq(~a,1),
	\midinote, Pseq(~midinotes,1),
	\dur, Pseq(~durs,1),
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	\bus, Pfunc { |d| switch(d[\midinote])
			{62}{ 0 }
			{65}{ 1 }
			{69}{ 2 }
			{72}{ 3 }
			{76}{ 4 }
			{79}{ 5 }} + ~lightsBus.index,
	 \finish, ~beatsToSeconds
  ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)


(
 Pbindef(\ampAnalysis,
    \instrument, \DcOuts,
   	\stretch,1,
  	\legato,1,
	\amp, Pseq(~a,inf),
	\midinote, Pseq(~midinotes,inf),
	\dur, Pseq(~durs,inf),
	\env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
    \counter, Pclutch(Pseq((0..5),inf),Pkey(\amp) < 0.5),
    \bus, Pfunc {  |d|
        case
        { d[\amp] > 0.9 }{ (0..5) }
        { d[\amp] < 0.5 }{ d[\counter] }
        { d[\amp] > 0.5 &&   d[\amp] < 0.9 }{ Prand([0,1,2,3,4,5],inf).asStream.next; }
	}	+ ~lightsBus.index,
    \finish, ~beatsToSeconds
  ).play(~metro.base ,quant:~metro.base.beatsPerBar);
)






