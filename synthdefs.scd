// for metronomes
SynthDef(\bleep,{ arg out=0, freq=440, amp=1.0;
    var env = EnvGen.ar(
        Env.asr(releaseTime:0.1), \gate.kr(1), levelScale:amp, doneAction:2
    );
    Out.ar(out, SinOsc.ar(freq) * env);
}).add;

// for lights
SynthDef(\DcOuts){|durSeconds=1, amp=1, bus=0|
    var env = \env.kr(Env.newClear(8).asArray);
    var sig = EnvGen.kr(env, timeScale:durSeconds.poll, doneAction:2) * amp;
    Out.kr(bus, sig);
}.add;
