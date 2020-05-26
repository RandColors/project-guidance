/* I'm very pleasant to find this example, beacouse it's based on
a rhythm taken from classical Hindustani Music.
https://en.wikipedia.org/wiki/Tihai

Things to keep in mind:
- 6 light on 10/8
so the phrases are long 10 , how to visualize 10 on 6?
- every phrase change light following an array.method that became macrostructural
- the goal is to disattend a bit what will happen, and then give plasure when the macrostructure become clear, like .. ( ..mmm.. ahh it works like that so!)

 // tehai : 7 beat motif 3 times sharing 1st beat with next 7x3
    // and again the third time:
    //   123456712345671234567                   123456712345671234567
    //                       123456712345671234567
    //   !                   !                   !                   !
    //   1234567890123456789012345678901234567890123456789012345678901
	// 20 / 8 *3 times

// Rewrite it for your light system
// a nice percussive
*/


(
SynthDef(\mridangam, { |amp= 0.5|
    var sound,env;
    sound = Resonz.ar(
        WhiteNoise.ar(70),
        60.midicps,
        0.02,
        4
    ).distort * 0.4;

	env = EnvGen.ar(Env.perc(0.002,0.1),levelScale:amp,doneAction:2);
    Out.ar(0, sound*env);

}).add;
)

Synth(\mridangam);

(
// percussion solo in 10/8
// 10 notes
~restBar =  Pseq([0.0], 10);

//80 notes
~intro8bars =  Pseq([0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 2)++
    Pseq([0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0], 2)++
    Pseq([0.9, 0.0, 0.0, 0.2, 0.0, 0.2, 0.0, 0.2, 0.0, 0.0], 2)++
    Pseq([0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2], 2);

// 300 notes
~solo30Bars = Prand(list:[
        Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]),
        Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]),
        Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]),
        Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]),
        Pseq([0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]),
        Pseq([0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]),
        Pseq([0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    ],repeats: 30);

// 60 notes
// I splitted because I wa looking for phrases of 10/8 each
~tehai6Bars =Pn(
	Pseq([2.0, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,1.5, 0.0, 0.2],1)++
	Pseq([0.5, 0.0, 0.2, 0.9,1.5, 0.0, 0.2, 0.5, 0.0, 0.2],1)
	,3);

// 1 note
// really can't understand sam it was [5]
~sam =  Pseq([1], 1);

// // probably Not needed
// end =  Pseq([0.0], inf); //end of the phrase

~pat = Pseq([
	~restBar, // rest 1 bar
	~intro8bars, // intro 8 bars
	~solo30Bars, // solo
	~tehai6Bars, // tehai
    ~sam // sam
],1);
)

(
~player = Pbind(
	\instrument,\mridangam,
	\amp,~pat,
	\dur,Pseq([1/8],451)
)
)

s.plotTree;

~player.stop;
~player.reset;
~player.play;

/*
Pbindef(\forward,
	\instrument,\DcOuts,
	\stretch,4,
	\legato,1,
   \bus,Pseq((0..5),451) + ~lightsBus.index,
	\amp,(~pat+0.3).clip(0.3,1.0),
    \env, Pseq([
		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq([1/16],451),
    \finish, ~beatsToSeconds
).play(~metro.base);

Pbindef(\forward).reset.stop;
Pbindef(\forward).reset.play;
*/


Pbindef(\forward,
	\instrument,\DcOuts,
	\stretch,4,
	\legato,1,
	\bus,Pseq((0..5).powerset,451) + ~lightsBus.index,
	\amp,(~pat+0.3).clip(0.3,1.0),
    \env, Pseq([
		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq([1/32],451),
    \finish, ~beatsToSeconds
).play(~metro.base);


Pbindef(\forward).reset.stop;
Pbindef(\forward).reset.play;

// if you want to quickly sonify it, for testing
(
Ndef(\monitor){
    var trigs = In.kr(~lightsBus,6);
	Mix(Compander.ar( Pan2.ar( LFPar.ar(27.midicps*Decay2.kr(trigs*60.midicps,0.01,0.05
	),mul:190)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/20)
}.play;
)



// // x visualizzare aggiungi un offset e clippa ad 1 per evitare di avere problemi,
// guarda come si tirano fuori glia rray dagli array .. subarray stuff..

(
var a, b;
a = Pfindur(5, Pbind(\dur, Prand([1, 2, 0.5, 0.1], inf)));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)


//Pfindur used as a sequence of pitches

(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)

(
var c;
c = Pbind(
    \dur, Prand([1, 0.02, 0.2], inf),
    \instrument, \help_sinegrain,
    \degree, Pseries(0, 1, inf),
    \octave, 6
);

Pn(
    Pfindur(1, c)
).play;
)



//
//
// // Random integers, 1-5
// Pwhite(1, 5, inf).asStream.nextN(10);
//
// (
// var z, pseq1,pseq2,pseq3,pseq4,pseq5,pseq6,pseq7,pseq8,pseq9,pseq10,pseq11,pseq12,pseq13,pseq14;
//
// // 14teen phrases
// pseq1 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq2 = Pseq([0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq3 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]);
// pseq4 = Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq5 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]);
// pseq6 = Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]);
// pseq7 = Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]);
// pseq8 = Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]);
// pseq9 = Pseq([0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]);
// pseq10 = Pseq([0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]);
// pseq11 = Pseq([0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq12 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]);
// pseq13 = Pseq([0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]);
// pseq14 = Pseq([0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
//
// z = Prand(list:[pseq1,pseq2,pseq3,pseq4,pseq5,pseq6,pseq7,pseq8,pseq9,pseq10,pseq11,pseq12,pseq13,pseq14],repeats: 10).nextN(10);
//
// Pswitch1(
// 	z,
// Pwhite(0,Pseq)).trace
// ).trace.play
// )
//
//
// (
// a  = [0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].plot(bounds: Rect(left: 0, top: 400, width:800 /*Window.screenBounds.width*/, height:600 /*Window.screenBounds.height*/),discrete: false, separately: false,numChannels:1);
//
// a.setProperties(
// 	\fontColor, Color.red,
// 	\plotColor, Color.white,
// 	\backgroundColor, Color.black,
// 	\gridColorX, Color.gray,
// 	\labelX, "time"
// );
//
// a.plotMode =\plines; a.refresh;
// /*
// a.plotMode = \points; a.refresh;
// a.plotMode = \levels; a.refresh;
// a.plotMode = \steps; a.refresh;
// a.plotMode = \linear; a.refresh;
// a.plotMode = \bars; a.refresh;
// */
// a.refresh;
// )
//
// // this is a nice example of nested pattern
//
//
// var a, b;
//
// a = Pxrand([
//
// 	Pseq((0..5).reverse,1),
// 	Pseq((100..105),1),
// 	Pshuf((1000..1005),1)
//
// ],3);
//
// a.;
// //b = a.asStream;
// //19.do({ b.next.postln; });
// )
//
// (
// var z, pseq1,pseq2,pseq3,pseq4,pseq5,pseq6,pseq7,pseq8,pseq9,pseq10,pseq11,pseq12,pseq13,pseq14;
//
// // 14teen phrases
// pseq1 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq2 = Pseq([0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq3 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]);
// pseq4 = Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq5 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]);
// pseq6 = Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]);
// pseq7 = Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]);
// pseq8 = Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]);
// pseq9 = Pseq([0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]);
// pseq10 = Pseq([0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]);
// pseq11 = Pseq([0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]);
// pseq12 = Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]);
// pseq13 = Pseq([0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]);
// pseq14 = Pseq([0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);
//
// z = Prand(list:[pseq1,pseq2,pseq3,pseq4,pseq5,pseq6,pseq7,pseq8,pseq9,pseq10,pseq11,pseq12,pseq13,pseq14],repeats: 10).nextN(10);
//
//
// )
//
//
//
//
// //.nextN(10);
//
//
//
// //10.do({ a.next.postln; });
// /*a.asArray;
// a.plot(bounds: Rect(left: 0, top: 400, width:Window.screenBounds.width, height:600 /*Window.screenBounds.height*/),discrete: true, separately: false,numChannels:3);
// */
// /*
// b = a.asStream;
//
// 301.do({ b.next.postln; });*/
//
// )
//
// a = (0..20).scramble.plot;
// a.plotMode = \points; a.refresh;
// a.plotMode = \plines; a.refresh;
// a.plotMode = \levels; a.refresh;
// a.plotMode = \steps; a.refresh;
// a.plotMode = \linear; a.refresh;
// a.plotMode = \bars; a.refresh;
//
//
// //
//
// (
// // HOLY WALL OF NUMBERS
// var sequences = [
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2],
// 	[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0],
// 	[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2],
// 	[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0],
// 	[0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2],
// 	[0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
// ].collect{|list| Pseq(list)};
//
//
//
// Pswitch1(
// 	sequences,
// 	//Prand((0..13),1).trace
// 	Prand((0..sequences.size),10).trace
// ).play
// )
//
// // Dmayer solution
//
// (
// ~sequences = [
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2],
// 	[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0],
// 	[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2],
// 	[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0],
// 	[0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2],
// 	[0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0],
// 	[0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0],
// 	[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
// ].collect { |list| Pseq(list) };
//
//
// ~rseq = Pswitch(~sequences, Prand((0..~sequences.size), 10));
//
// /*Pbind(
// \dur, 0.2,
// \midinote, Pswitch(~sequences, Prand((0..~sequences.size), inf).trace) * 5 + 60
// ).play*/
//
// )
//
// /*
// Pbind(
// \dur, 0.2,
// \midinote, Pn(Plazy {
// var i = (0..~sequences.size).choose.postln;
// var x = case
// { i == 0 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 1 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 2 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 3 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 4 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 5 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;} }
// { i == 6 }{Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 7 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 8 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 9 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 10 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 11 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 12 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}}
// { i == 13 }{ Pfunc{[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0].postln;}};
//
// x.postln;
// Pswitch1(~sequences, i)
//
// } * 5 + 60)
// ).play
// )*/
//
//
// ~seqdict = (seqAlpha: Pseq([1, 2, 3]), seqBeta: Pseq([5, 4, 3]), seqGamma: Pseq([6, 7, 6]));
//
// // quick example, seq size assumed constant across the dict
//
// (
// p = Pbind(
// 	\seqname, Pstutter(1, Prand(~seqdict.keys(Array), 14)),
// 	\degree, Plazy { Pdict(~seqdict, Pkey(\seqname)) },
// 	\dur, 0.2
// ))
//
//
// 14 do: { p.asStream.nextN(1, ()).postln }
//
// p.trace(\seqname).play
//
//
//
// ~seqdict = (
//
// 	pseq1: Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
// 	pseq2: Pseq([0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
// 	pseq3:  Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]),
// 	pseq4:  Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]),
// 	pseq5:  Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]),
// 	pseq6:  Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]),
// 	pseq7:  Pseq([0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
// 	pseq8:  Pseq([0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
// 	pseq9:  Pseq([0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]),
// 	pseq10: Pseq([0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]),
// 	pseq11: Pseq([0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
// 	pseq12: Pseq([0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]),
// 	pseq13: Pseq([0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]),
// 	pseq14: Pseq([0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
// );
//
//
// // solo part for randomization ...
//
// (
// ~pseq1 = [0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0];
// ~pseq2 = [0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0];
// ~pseq3 = [0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2];
// ~pseq4 = [0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0];
// ~pseq5 = [0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0];
// ~pseq6 = [0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2];
// ~pseq7 = [0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0];
// ~pseq8 = [0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0];
// ~pseq9 = [0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0];
// ~pseq10 = [0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2];
// ~pseq11 = [0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0];
// ~pseq12 = [0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0];
// ~pseq13 = [0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0];
// ~pseq14 = [0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
// )
//
// (
// ~aplot  = Array.fill(10,
// {[~pseq1,~pseq2,~pseq3,~pseq4,~pseq5,~pseq6,~pseq7,~pseq8,~pseq9,~pseq10,~pseq11,~pseq12,~pseq13,~pseq14].choose}).plot(bounds: Rect(left: 0, top: -50, width:1920*3/*Window.screenBounds.width.postln*/, height:1080*2 /*Window.screenBounds.height.postln*/));
//
// ~aplot.setProperties(
// 	\fontColor, Color.red,
// 	\plotColor, Color.black,
// 	\backgroundColor, Color(0.85458555221558, 0.86288015842438, 0.88959631919861),
// 	\gridColorX, Color.gray,
// 	\labelX, "time"
// );
//
// ~aplot.plotMode =\points;
// /*
// a.plotMode = \plines; a.refresh;
// a.plotMode = \points; a.refresh;
// a.plotMode = \levels; a.refresh;
// a.plotMode = \steps; a.refresh;
// a.plotMode = \linear; a.refresh;
// a.plotMode = \bars; a.refresh;
// */
// ~aplot.refresh;
// )
//
// // write to a .png
// (
//
//
// .plot(bounds: Rect(left: 0, top: 400, width:800 /*Window.screenBounds.width*/, height:600 /*Window.screenBounds.height*/),discrete: false, separately: false,numChannels:1);
// )
//
// i = Image.fromWindow(~aplot.parent, ~aplot.interactionView.bounds);
// i.write("~/desktop/indianrand).png".standardizePath);
// i.free;
//
// ~aplot.size;
// 10
//
//
// [ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]++[ 0.9, 0, 0.2, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0.2, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0.2, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0.2, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0.7, 0.7, 0, 0, 0.2, 0.2, 0.2, 0, 0 ]
//
//
//
// // fai 3 a plots
//
// // x visualizzare aggiungi un offset e clippa ad 1 per evitare di avere problemi,
// guarda come si tirano fuori glia rray dagli array .. subarray stuff..
//
// (
// Pbindef(\forward,
// 	\instrument, \DcOuts,
// 	\stretch,4,
// 	\legato,1,
// 	\bus,Pseq((0..4),inf) + ~lightsBus.index,
// 	\amp,Pseq([ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]++[ 0.9, 0, 0.2, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0 ]++[ 0.9, 0.2, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0, 0, 0.7, 0.2, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0.2, 0, 0.7, 0, 0.2, 0, 0.7, 0, 0 ]++[ 0.9, 0.7, 0.7, 0, 0, 0.2, 0.2, 0.2, 0, 0 ]+0.3 ,1),
// 	\env, Pseq([
// 		[Env.perc(0.001,0.999,1,4)]
// 	],inf),
// 	\dur, Pseq([1/16],inf),
// 	\finish, ~beatsToSeconds
// ).play(~metro.base);
// )
//
