(
Pbindef(\forward,\bus,Pseq((0..5).pyramid(1),1) + ~lightsBus.index).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// elements
(0..5).pyramid(1);
[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5 ].size;

// elements
(0..5).pyramid(2);
[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5 ].size

// elements
(0..5).pyramid(3);
[ 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ].size

// elements
(0..5).pyramid(4);
[ 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ].size

// elements
(0..5).pyramid(5);
[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0 ].size

// elements
(0..5).pyramid(6);
[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ].size

// 41 elements
(0..5).pyramid(7);
[ 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5 ].size

// 41 elements
(0..5).pyramid(8);
[ 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5 ].size;

// 36 elements
(0..5).pyramid(9);
[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 3, 4, 5, 3, 4, 5, 4, 5, 5 ].size;


// 36 elements
(0..5).pyramid(10);
[ 5, 4, 5, 3, 4, 5, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 0, 1, 2, 3, 0, 1, 2, 0, 1, 0 ].size;

/*
powerset
Returns all possible combinations of the array's elements.
*/

(0..5).powerset.postln;
(0..5).powerset.sort({ |a, b| a.size > b.size }); // sort by size, big first
(0..5).powerset.sort({ |a, b| a.size > b.size }).reverse; // by size, small first


/*Slide*/
(0..5).slide(2, 1).asCompileString.postln;
[ 0, 1, 1, 2, 2, 3, 3, 4, 4, 5 ]


(0..5).slide(3, 1).asCompileString.postln;
[ 0, 1, 2, 1, 2, 3, 2, 3, 4, 3, 4, 5 ]

(0..5).slide(4, 1).asCompileString.postln;
[ 0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5 ]

(0..5).slide(5, 1).asCompileString.postln;
[ 0, 1, 2, 3, 4, 1, 2, 3, 4, 5 ]


(0..5).slide(1, 2).asCompileString.postln;
[ 0, 2, 4 ]


(0..5).slide(3, 2).asCompileString.postln;
[ 0, 1, 2, 2, 3, 4 ]

(0..5).slide(4, 2).asCompileString.postln;
[ 0, 1, 2, 3, 2, 3, 4, 5 ]

(0..5).slide(5, 2).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]


(0..5).slide(1, 3).asCompileString.postln;
[ 0, 3 ]

(0..5).slide(2, 3).asCompileString.postln;
[ 0, 1, 3, 4 ]


(0..5).slide(4, 3).asCompileString.postln;
[ 0, 1, 2, 3 ]

(0..5).slide(5, 3).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]

(0..5).slide(6, 3).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]



(0..5).slide(1, 4).asCompileString.postln;
[ 0, 4 ]

(0..5).slide(2, 4).asCompileString.postln;
[ 0, 1, 4, 5 ]

(0..5).slide(3, 4).asCompileString.postln;
[ 0, 1, 2 ]

(0..5).slide(4, 4).asCompileString.postln;
[ 0, 1, 2, 3 ]

(0..5).slide(5, 4).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]

(0..5).slide(6, 4).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]


(0..5).slide(1, 5).asCompileString.postln;
[ 0, 5 ]
(0..5).slide(2, 5).asCompileString.postln;
[ 0, 1 ]
(0..5).slide(3, 5).asCompileString.postln;
[ 0, 1, 2 ]
(0..5).slide(4, 5).asCompileString.postln;
[ 0, 1, 2, 3 ]
(0..5).slide(5, 5).asCompileString.postln;
[ 0, 1, 2, 3, 4 ]
(0..5).slide(6, 5).asCompileString.postln;
[ 0, 1, 2, 3, 4, 5 ]


(0..5).slide(5, 1).asCompileString.postln;
(0..5).slide(4, 1).asCompileString.postln;



.slide(2, 1)


https://github.com/DarienBrito/Self_Similar/blob/master/1.Counting_123.scd


https://composerprogrammer.com/teaching/supercollider/sctutorial/9.1%20Algorithmic%20Strategies.html
http://www.musicaecodice.it/SC_Controllo/SC_Controllo.php


// Start/
(
var lightsAddr = ~lightsAddr;

p = Pbindef(\forward,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Pseq((0..5).slide(2, 1),1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq([1/8],inf),
    \finish, ~beatsToSeconds
);

Pfset(
	func:{lightsAddr.sendMsg('/startrec',"startrec".postln)},
	pattern:p ,
	cleanupFunc:{lightsAddr.sendMsg('/stoprec',"stoprec".postln)}
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

