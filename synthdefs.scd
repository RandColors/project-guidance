// for metronomes
SynthDef(\bleep,{ arg out=0, freq=440, amp=1.0;
    var env = EnvGen.ar(
        Env.asr(releaseTime:0.1), \gate.kr(1), levelScale:amp, doneAction:2
    );
    Out.ar(out, SinOsc.ar(freq) * env);
}).add;


// add \amp arg to DcOuts
SynthDef(\DcOuts){|durSeconds=1, bus=0, amp =1 ,t|
    var env = \env.kr(Env.newClear(8).asArray);
    var sig = EnvGen.kr(env, timeScale:durSeconds, doneAction:2);
    Out.kr(bus, sig*amp);
}.add;

// straight forward amp-to-bus
SynthDef(\ampControl){|out=0, lag=0.1| Out.kr(out, \amp.kr(0,lag))}.add;

// allocate busses for dynamics
~dynamics = Bus.control(s, 10); // let's say 10 independent controls
~dynamics.setn(1!10);
~dynamics.scope;



