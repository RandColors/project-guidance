Pbind(
    \midinote, Pwhite(60, 62),
    \dur, 0.2,
    \amp, Pif(Pbinop('==', Pkey(\midinote), 61), 0.5, 0.05)
).play


Pbind(
    \midinote, Pwhite(60, 62),
    \dur, 0.2,
    \amp, Pfunc { |e| (e[\midinote] == 61).if { 0.5 }{ 0.05 } }
).play
