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