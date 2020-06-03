
m = SimpleMIDIFile.read( "C:/Users/ET/Desktop/cartella condivisa/Drums/scores/simple.mid" );
x = m.generatePatternSeqs.flatten(1);//.flatten(1).postln;

x.postcs;

[ [ 72, 1.0 ], [ 72, 1.0 ], [ 72, 1.0 ], [ 72, 1.0 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 1.0 ], [ 72, 0.33229166666667 ], [ 72, 0.33229166666667 ], [ 72, 0.33541666666667 ], [ 'rest', 0.5 ], [ 72, 0.5 ], [ 'rest', 0.5 ], [ 72, 0.5 ], [ 'rest', 0.25 ], [ 72, 0.25 ], [ 'rest', 0.25 ], [ 72, 0.25 ], [ 72, 1.0 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ] ]



x.reverse.debug("reverse: ");

reverse: : [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 1 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.5 ], [ rest, 0.5 ], [ 72, 0.5 ], [ rest, 0.5 ], [ 72, 0.33541666666667 ], [ 72, 0.33229166666667 ], [ 72, 0.33229166666667 ], [ 72, 1 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 1 ], [ 72, 1 ], [ 72, 1 ], [ 72, 1 ]





// first variation on ...
x.pyramid(1).postcs;



(
p = Pbind(
	[\midinote, \dur], Pseq(x.pyramid(1),1),
	//\amp, 1.00//Pkey(\amp) / 127
);


m = SimpleMIDIFile( "~/Desktop/simple_pyramid(1).mid" );
m.init1( 0, 60, "4/4" );
m.fromPattern( p );
)

m.plot;

m.p.play; // note numbers are not rounded
p.play; // compare

m.write; // when writing to file note numbers are rounded (MIDI file format doesn't allow floats)