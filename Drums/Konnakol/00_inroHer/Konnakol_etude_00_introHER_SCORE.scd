// Write a pattern to .mid

(
/*~pmidi = Pbind(
    \dur, Prand( [0.25,0.5,1], inf ),
    \freq, Pwhite( 440, 880 ),
    \db, Pwhite( -40,-10 ),
    \legato, Pwhite( 0.25, 4 ) );*/

~midiout = SimpleMIDIFile( "~/Desktop/testPat.mid" );
~midiout.init1(0, 178, "7/4" );
~midiout.fromPattern( p );
)

~midiout.plot;

~midiout.~pmidi.play; // note numbers are not rounded
~pmidi.play; // compare

~midiout.write; // when writing to file note numbers are rounded (MIDI file format doesn't allow floats)

// (
// ~pmidi =Pbind(
// 	\t,Pswitch1([~zero,~one,~two,~three,~four,~five,~forward,~reverse,~palindrome,~rand,~allparall],
// 	Pseq(~bar01_02bus)),
// 	\midinote, (Pseq(~midinotes,1)+Pkey(\t)).trace
// );
//
 ~pmidi.asStream.nextN(63, ()).debug("p");
// )


[ 62, 63, 64, 65, 66, 67 ].collect({|in| case{in == 62}{100} }).postln;


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