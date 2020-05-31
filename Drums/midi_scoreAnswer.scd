
m = SimpleMIDIFile.read( "~/Desktop/abletonMidi.mid" );
m
// to have the [\dur, \midinote]
x = m.generatePatternSeqs.flatten(1).postln



(
x.size.do{|i|

	var z,a,b;
	m.generatePatternSeqs.flatten(1).wrapAt(i).doAdjacentPairs({
		arg item,item1, i; [
			a = if(item == 'rest',{  item = "Rest(0)," + item1 },{ item +","+ item1  });

	].post
});
}
)
// now we have the n arrays
x.size;
// we want to replace rest

m.midiEvents.dopostln;

(m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5));

m.noteSustainEvents(channel:0, track:0).postln;
 [ [ 0, 0, noteOn, 0, 72, 127, 24, 64 ],
	[ 0, 48, noteOn, 0, 72, 100, 24, 64 ],
	[ 0, 96, noteOn, 0, 72, 100, 24, 64 ],
	[ 0, 120, noteOn, 0, 72, 38, 24, 64 ],
	[ 0, 144, noteOn, 0, 72, 38, 24, 64 ],
	[ 0, 168, noteOn, 0, 72, 38, 24, 64 ],
	[ 0, 216, noteOn, 0, 72, 100, 24, 64 ],
	[ 0, 264, noteOn, 0, 72, 100, 24, 64 ],
	[ 0, 288, noteOn, 0, 72, 6, 12, 64 ],
	[ 0, 300, noteOn, 0, 72, 14, 12, 64 ],
	[ 0, 312, noteOn, 0, 72, 25, 12, 64 ],


	I need to filter the 5th parameter and add it to the couple [\midinote, \dur, \amp ]
(
var f,rest;
x.size.do({ |i|

			f =m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5);
f.postln;
});
)

(
var f,rest;
a = [ rest, 0.25, 100, 0.25, 100, 0.25, rest, 0.5, 100, 0.25 ];
/*
rest = "Rest(0)";
a.do{|i| if(i == nil){i = "Rest(0)"}*/

};

a.replace("rest", "ciao").postln;
)

[ 0, 0, noteOn, 0, 72, 127 ]
[ 0, 24, noteOff, 0, 72, 64 ]

[ 0, 48, noteOn, 0, 72, 100 ]
[ 0, 72, noteOff, 0, 72, 64 ]

[ 0, 96, noteOn, 0, 72, 100 ]
[ 0, 120, noteOff, 0, 72, 64 ]

[ 0, 120, noteOn, 0, 72, 38 ]
[ 0, 144, noteOff, 0, 72, 64 ]

[ 0, 144, noteOn, 0, 72, 38 ]
[ 0, 168, noteOff, 0, 72, 64 ]

[ 0, 168, noteOn, 0, 72, 38 ]
[ 0, 192, noteOff, 0, 72, 64 ]

[ 0, 216, noteOn, 0, 72, 100 ]
[ 0, 240, noteOff, 0, 72, 64 ]

[ 0, 264, noteOn, 0, 72, 100 ]
[ 0, 288, noteOff, 0, 72, 64 ]

[ 0, 288, noteOn, 0, 72, 6 ]
[ 0, 300, noteOff, 0, 72, 64 ]

[ 0, 300, noteOn, 0, 72, 14 ]
[ 0, 312, noteOff, 0, 72, 64 ]

[ 0, 312, noteOn, 0, 72, 25 ]
[ 0, 324, noteOff, 0, 72, 64 ]

[ 0, 324, noteOn, 0, 72, 44 ]
[ 0, 336, noteOff, 0, 72, 64 ]

[ 0, 336, noteOn, 0, 72, 55 ]
[ 0, 348, noteOff, 0, 72, 64 ]

[ 0, 348, noteOn, 0, 72, 69 ]
[ 0, 360, noteOff, 0, 72, 64 ]

[ 0, 360, noteOn, 0, 72, 93 ]
[ 0, 372, noteOff, 0, 72, 64 ]

[ 0, 372, noteOn, 0, 72, 127 ]
[ 0, 384, noteOff, 0, 72, 64 ]