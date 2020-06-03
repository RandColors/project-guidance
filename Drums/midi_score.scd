Quarks.gui
//wslib


// ====== MIDI FILES ======

// You can use the [SimpleMIDIFile] Class from the wslib quark to read or write MIDI files in and from SC. Here is an example from Wouter Snoei (the wslib creator):



// download a fugue

"curl http://www.bachcentral.com/BachCentral/AOF/dou1.mid -o ~/Desktop/dou1.mid".unixCmd;

// read it

m = SimpleMIDIFile.read( "~/Desktop/roll.mid" );

// plot it:

m.plot;

// play it (an undocumented 'experimental' method), only plays one voice

m.p.play;

/ play it with another instrument
(
SynthDef( "organ", { |freq = 440, sustain = 1, amp = 0.1|
        var sig;
        sig = LFPar.ar( freq * [1,2,3,5], 0, amp/[2,4,5,7] );
        Out.ar( 0, Env([0,1,1,0], [0.025,sustain,0.025]).kr(2) * sig.dup )
}).add;
);

x = m.p( \organ ).play();
x.stop;

x = m.generatePatternSeqs.flatten.debug("midifile: ");

-> [ [ [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ rest, 0.5 ], [ 72, 0.25 ] ] ]

[ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ 72, 0.5 ], [ 72, 0.5 ], [ 72, 0.25 ], [ rest, 0.25 ], [ 72, 0.25 ], [ 72, 0.25 ], [ rest, 0.5 ], [ 72, 0.25 ]
m.trackName;
m.length;
m.removeTempo(time: 0, doIt: true)

m.analyzeTypes
m.analyzeChannels()
m.info
m.analyzeCCTracks
m.volumeEvents(channel: 0, track:0)
m.noteEvents(channel:0, track:0)

m.midiEvents

.midiEvents = value
an array containing all MIDI events as arrays. Format:
[ trackNumber, absTime, type, channel, val1, val2 ]

val 2 è velocity


m.noteSustainEvents(channel:0, track:0)

x[0].postcs;
x[0].add(100).postcs;
x.size;

(
var a,f;
x = m.generatePatternSeqs.flatten.debug("midifile: ");
x.size.do({ |i|

	a = m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5);
	f = x[i].add(a).debug("midinote, dur, velocity: ");

});
)


});


x = [ 1, 2, 3, "foo", 'bar' ];
y = x.wrapExtend(9);
x.postln;
y.postln;
y = [ 1, 2, 3 ];
y.clipAt(1).postln;

x.size;
// velocity
(
var f;
x.size.do({ |i|

	f =m.generatePatternSeqs.flatten(2).replace([72],m.noteSustainEvents(channel:0, track:0).wrapAt(i).wrapAt(5));

});

// f.doAdjacentPairs {
// 	| el1, el2, idx |
// 	("pair (" + el1 + "," + el2 + ") visited at index" + idx).postln;
// };

)
x.size.do({ |i| i.debug("conta")});

x = [ [1, 2, 3], 6, List["foo", 'bar']];
y = x.lace(4);
x.postln;
y.postln;

(
var rest, a, myarr;
a = [ 100, 0.25, 100, 0.25, 100, 0.25, 100, 0.25, 100, 0.5, 100, 0.5, 100, 0.25, rest, 0.25, 100, 0.25, 100, 0.25, rest, 0.5, 100, 0.25 ];
a.size/2;


a.doAdjacentPairs {
	| el1, el2, idx |
	if(idx.even){

	myarr = ("[" + el1 + "," + el2 + "],").asString;
		myarr.postln;
}}
)
)

100/127
[[ 100 , 0.25 ] ,
[ 100 , 0.25 ] ,
[ 100 , 0.25 ] ,
[ 100 , 0.25 ] ,
[ 100 , 0.5 ] ,
[ 100 , 0.5 ] ,
[ 100 , 0.25 ] ,
[ nil , 0.25 ] ,
[ 100 , 0.25 ] ,
[ 100 , 0.25 ] ,
[ nil , 0.5 ] ,
[ 100 , 0.25 ] ]