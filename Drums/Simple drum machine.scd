(
s.waitForBoot({
	var gen, swingify;
	var presets;
	var composite;

	// Basic drum kit

SynthDef("hihat", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));

//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

SynthDef("snare", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var env, snd1, snd2, sum;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq,
		mul: env
	);
	snd2 = SinOsc.ar(freq: sinfreq, mul: env);
	sum = snd1 + snd2;
	Out.ar(out, Pan2.ar(sum, pan));

//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

SynthDef("kick", {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var env, snd, ramp;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);

//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;





	gen = {
		| pattern="x.x.",
		instrument=\kickdrum,
		midiout=nil,
		repeat=1,
		division=8,
		midichannel=9,
		amplitudeerrors=0,
		timingerrors=0,
		percmap = nil|

		Pn(
			Pbind(
			\instrument, \snare,
				\midinote, Prout({
					pattern.do({
						| character |
						if (character != $.) {
							percmap[instrument].yield;
						} {
							Rest(0).yield;
						};
					});
				}),
				\amp, Prout({
					pattern.do({
						| character |
						if (character == $X) {
							(0.8 + (amplitudeerrors/2.0).rrand(amplitudeerrors/2.0.neg)).yield;
						} {
							if (character == $x) {
								(0.5 + (amplitudeerrors/2.0).rrand(amplitudeerrors/2.0.neg)).yield;
							} {
								0.yield;
							};
						};
					});
				}),
				\dur, Prout({
					var durations = pattern.collectAs({1.0/division}, Array);
					var totalduration = pattern.size * (1.0/division);
					var durations_with_errors = durations.collect({
						| dur |
						dur + (timingerrors/2.0).rrand(timingerrors/2.0.neg);
					}).normalizeSum * totalduration;
					durations_with_errors.do({ |el|
						el.yield;
					});
			})),
			repeat);
	};


	presets = (\billiejean : [["....X.......X...", \snaredrum, 8],],);


	composite = Pseq(presets[\billiejean].collect({|el|
		gen.(
			pattern: el[0],
			instrument: el[1],
			midiout: ~midiout,
			repeat: inf,
			division: el[2],
			midichannel: 9,
			amplitudeerrors:0.1,
			timingerrors: 0.02,
			percmap: ~percmap);
	}));
	~player = composite.play;

});
)