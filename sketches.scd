// sketches.scd
// this file can be used to write sketches,
// before they become scenes or other parts of the codebase


// patterns:
// specify sequences with as few conversions as possile
// - bus: lightsBus.index is added at the end
// - env:
//   - every single envelope needs to be inside an array
//   - every envelope should last a total of 1
// - dur: expressed in beats, converted later
// - finish: here we call our conversion function
(
Pbindef(\frase,
    \instrument, \DcOuts,
    \bus,Pseq([(0..2),(3..5)],inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
        [Env.perc],
        [Env.perc(0.999,0.001,1,4)]
    ],inf),
    \dur, Pseq([1,0.5,0.5,0.25,0.25],inf),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

Pbindef(\frase).stop
Pbindef(\frase).clear

// if you want to quickly sonify it, for testing
Ndef(\monitor){
    var trigs = In.kr(~lightsBus,6);
    Mix(Pan2.ar(SinOsc.ar(100*Scale.partch_o2.ratios)*trigs, [-1,1])/10)
}.play
