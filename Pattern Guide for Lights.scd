
## Streams ##
A stream represents a lazy sequence of values.
A stream can be any object that responds to the next and reset messages.

There is a default streams implemented by Object.

- next value in the sequence  = message .next to the stream object


7.next.postln;    // 7 responds to next by returning itself

(
var a = (0..10);
(a.next.postln);
)

(
var a = Pseq((1..10),1).asStream;
(a.next.postln); // the first value
)

-  when a finite length stream has  reached the end, it returns nil.
(
var a = Pseq((1..10),1).asStream;
11.do({a.next.postln}) // the entire stream + nil
)

- Seq restarted from the beginning message reset

(
a = Pseries(1,1.1,10).asStream;
b = fork { loop { a.next.postln; 0.5.wait } };
a.reset; // with .reset restart from the first element of the stream
)
b.stop;


-  finite or infinite length.
(
var x, c;
x = Pseries(1,1.1,inf).asStream; // infinite stream
c = fork { loop { x.next.postln; 0.5.wait } };
c.stop; // stop it
c.reset.play; // restart it from where it was
)



Also there is http://doc.sccode.org/Classes/Stream.html

A generally useful subclass of Stream is the class FuncStream which allows the user to provide functions to execute in response to next and reset.
FuncStream is one of the most basic ways to describe a stream: it has a function that is called for each next stream value.

(
var a;
a = FuncStream.new({ [1, 2, 3, 4].choose });
5.do({ a.next.postln; }); // print 5 values from the stream
)



Another useful subclass of Stream is Routine
http://doc.sccode.org/Classes/Routine.html

(
var a;
a = Routine({ 20.do({ 33.rand.yield }) });
21.do({a.next.postln});
)


The yield message returns a value from the Routine
http://www.musicaecodice.it/SC_Controllo/SC_Sequencing/SC_Sequencing.php

(
var a;
a = Routine.new({
        3.do({ arg i; i.yield; })
    });
4.do({ a.next.postln; });    // print 4 values from stream
)

Math operations are possible on a streams to produce other streams.
- unary operator
- binary oeprator
- messages collect, select, and reject for filtering operations



Patterns are just a way to make multiple Streams from a single specification, like a cookie cutter.
There is a class named Pattern that provides more functionality for the concept of a pattern.

A Pfunc is a Pattern that returns a FuncStream.
(
var a, b;
a = Pfunc({ #[1, 2, 3, 4].choose });
b = a.asStream;            // make a stream from the pattern
5.do({ b.next.postln; });    // print 5 values from the stream
)


A Prout is a Pattern that returns a Routine

(
var a, b, c;
a = Prout({
        3.do({ arg i; 3.rand.yield; })
    });
// make two streams from the pattern
b = a.asStream;
c = a.asStream;
4.do({ b.next.postln; });    // print 4 values from first stream
4.do({ c.next.postln; });    // print 4 values from second stream
)

Patterns also respond to math operators by returning patterns that respond to asStream with appropriately modified streams.
- unary operator
- binary oeprator
- messages collect, select, and reject for filtering operations


## ListPatterns ##
http://doc.sccode.org/Tutorials/Streams-Patterns-Events3.html
ListPatterns are Patterns that iterate over arrays of objects in some fashion

## Pseq ##


(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset:0);    // repeat twice
b = a.asStream;
13.do({ b.next.postln; });
)

(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset:5.rand);    // random offset
b = a.asStream;
13.do({ b.next.postln; });
)


(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset: rrand(1, 3)   );    // random offset
b = a.asStream;
13.do({ b.next.postln; });
)


(
var a, b;
a = Pseq(list:(0..5),repeats: 1,offset:(0..5));    // kind of rotate
b = a.asStream;
6.do({ b.next.postln; });
)

6.do({|i|(0..5).rotate(6-i).postln});


## Pser ##
the repeats variable gives the number of items returned
(
var a, b;
a = Pser(list:(0..5),repeats: 12,offset:0);
b = a.asStream;
12.do({ b.next.postln; });
)

## Prand & Pxrand ##
Pxrand, like Prand, returns one item from the list at random for each repeat, but Pxrand never repeats the same element twice in a row.

(
var a, b;
a = Prand((0..5),repeats:2); // return 2 items
b = a.asStream;
3.do({ b.next.postln; });
)

(
var a, b;
a = Pxrand((0..5),repeats:2); // return 2 items
b = a.asStream;
3.do({ b.next.postln; });
)


(
var a, b;
a = Pshuf((0..5),repeats:2);
b = a.asStream;
13.do({ b.next.postln; }); // return 12 items + nil
)

## Nesting Patterns is possible ##

(
var a, b;

a = Pxrand([

	Pseq((0..5).reverse,1),
	Pseq((0..5),1),
	Pshuf((0..5),1)

],3);
b = a.asStream;
19.do({ b.next.postln; });
)

Math on pattern is  posible..
(
var a;
a = Pseq([60], 6) + Pseq([0, 0, -12], 2);
b = a.asStream;
7.do({ b.next.postln; });
)




/*
Rewrite it for your light system
// a nice percussive
(
SynthDef( \help_SPE3_Mridangam, { |out, t_amp|
    var sound;

    sound = Resonz.ar(
        WhiteNoise.ar(70) * Decay2.kr( t_amp, 0.002, 0.1 ),
        60.midicps,
        0.02,
        4
    ).distort * 0.4;

    Out.ar(out, sound);
    DetectSilence.ar(sound, doneAction: Done.freeSelf);
}).add;

SynthDef( \help_SPE3_Drone, { |out|
    var sound;
    sound = LPF.ar(
        Saw.ar([60, 60.04].midicps)
        +
        Saw.ar([67, 67.04].midicps),
        108.midicps,
        0.007
    );
    Out.ar(out, sound);
}).add;
)

(
// percussion solo in 10/8

var stream, pat, amp;

pat = Pseq([
    Pseq(#[0.0], 10),

    // intro
    Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.2, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2], 2),

    // solo
    Prand([
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]),
        Pseq(#[0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    ], 30),

    // tehai : 7 beat motif 3 times sharing 1st beat with next 7x3
    // and again the third time:
    //   123456712345671234567                   123456712345671234567
    //                       123456712345671234567
    //   !                   !                   !                   !
    //   1234567890123456789012345678901234567890123456789012345678901
    Pseq(#[2.0, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2], 3),
    Pseq(#[5], 1),    // sam

    Pseq(#[0.0], inf)
]);

stream = pat.asStream;

Task({
    Synth(\help_SPE3_Drone);
    loop({
        if( ( amp = stream.next ) > 0,
            { Synth(\help_SPE3_Mridangam, [ \t_amp, amp ]) }
        );
        (1/16).wait;
    })
}).play
)
*/


http://doc.sccode.org/Tutorials/Streams-Patterns-Events4.html
## Streams and Patterns to generate complex sequences of values for a single parameter at a time.
Environments and Events,
 to control all aspects of a composition using patterns.
##
http://doc.sccode.org/Classes/Environment.html
http://doc.sccode.org/Classes/IdentityDictionary.html


~myvariable = 888; //
currentEnvironment.at(\myvariable).postln;
~myvariable.postln;

//////////////////////////////////////////
Biblio

/*_____________________________________
CuePlayer
https://github.com/dathinaios/CuePlayer
Quarks.install("CuePlayer");
________________________________________*/

Quarks.gui;



s.boot;
s.scope;
s.meter;
s.plotTree;

(
SynthDef(\sperc,
               {arg freq=440, amp=0.5, dur=0.5;
                var env, osc;
                    env = Env.perc(0.01, dur-0.01).kr(2,1);        // Inviluppo percussivo
                    osc = SinOsc.ar(freq, 0, amp.lag(0.02));
                Out.ar(0, env*osc)}
        ).add;

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // Audio file

SynthDef(\samp,
               {arg pos=0, dur=1, amp=0.5;
                var rata,inizio,fine,env,osc;
                    rata   = SampleRate.ir;                         // Sample rate
                    inizio = pos*rata;                              // punto iniziale in frame
                    fine   = dur*rata+inizio;                       // punto finale in frame
                    env    = Env.linen(0.01,dur-0.02,0.01).kr(2,1); // Inviluppo trapezoidale
                    osc    = BufRd.ar(1, b.bufnum, Line.ar(inizio,fine,dur),0);
                Out.ar(0, env*osc*amp.lag(0.02))}
        ).add;
)



Infinite - Pbind() is mainly used to dynamically send values over time to specific labels or addresses previously defined.

Finite - Pn()

Randomic - Pwite()

(
Pbind(
      \sudd,  Pwhite(1, 18, 10).trace,   // 10 pulsazioni non beats
      \delta, Pstutter(Pkey(\sudd), 1/Pkey(\sudd))
      ).play
)

(
b = 92;
t = TempoClock(b/60);

m = Pbind(\freq,  1480,        // metronomo Synth di default
          \amp,   0.3,
          \delta, Pn(1,inf)
          ).play(t);

p = Pbind(\instrument, \sperc, // pulsazioni Synth \sperc
          \freq,  80,
          \amp,   64,
          \sudd,  Pwhite(1,8,inf),
          \delta, Pstutter(Pkey(\sudd), 1/Pkey(\sudd))
          ).play(t)
)

m.stop;p.stop;t.clear;



Pattern Guide 01: Introduction


// Same, using a dictionary of patterns, changing dur rhythm also
(
var    patternChoices = (
    up: { Pbind(\degree, Pseries(rrand(-4, 5), 1, rrand(4, 10)), \dur, 0.125) },
    down: { Pbind(\degree, Pseries(rrand(4, 11), -1, rrand(4, 10)), \dur, 0.125 * 4/3) }
);

p = Pspawn(Pbind(
    \pattern, Prand([\up, \down], inf),
    \delta, Pwhite(1, 5, inf) * 0.125,
    \method, \par
), (dict: patternChoices)).play;
)

p.stop;


Pclutch(Pseq([1, 2, 3, 4, 5], 3), Pseq([0, 0, 1, 0, 0, 0, 1, 1])).asStream.nextN(10);