/////////////////////////////////////////////////////////////////////////////////////////////////
//
// functions: wrap up functionality in a neat name
//

(
var f = {
	| a, b |
	a + b; // last thing in function is what is returned
};
var sum = f.value(4,5).debug("sum");
var sum2 = f.value([4,5,6,7], 10).debug("sum2");
var sum3 = f.value([4,5,6,7], [1,2,3,4]).debug("sum3");
)

// alternative notation: use arg instead of | |
(
var f = {
	arg a, b;
	a + b; // last thing in function is what is returned
};
var sum = f.value(4,5).debug("sum");
var sum2 = f.value([4,5,6,7], 10).debug("sum2");
var sum3 = f.value([4,5,6,7], [1,2,3,4]).debug("sum3");
)

// functions syntax shortcut: leave out value
(
var f = {
	| a, b |
	a + b; // last thing in function is what is returned
};
var sum = f.(4,5).debug("sum");
)

(
// a list
var lst = [10, 20, 30, 40, 50];

// address elements in a list
lst[0].debug("lst[0]");            // access element at index 0
lst[3].debug("lst[3]");            // access element at index 3
lst.first.debug("lst.first");      // access first element
lst.last.debug("lst.last");        // access last element
lst.reverse.debug("lst.reverse");  // reverse list
lst = lst.add(10000).debug("add"); // add element at end of list
lst = (lst ++ 20000).debug("++");  // alternative syntax for adding something at end of list
lst.pop.debug("pop");            // remove element at end of list (return value is popped value)
lst.debug("after pop");
(5.dup(3)).debug("5.dup(3)");      // dup turns something into a list of something
(5!3).debug("5!3");                // shortcut syntax
)

//
// iteration = go over elements of collection, usually one by one
//

// do -> do something to each element
// using a list
(
[5, 8, 9].do({
	| el, idx |
	("element" + el + "at index" + idx + "was visited.").postln;
});
)



// syntax shortcut
(
[5, 8, 9].do{
	| el, idx |
	("element" + el + "at index" + idx + "was visited.").postln;
};
)

// using a number
(
5.do {
	| el, idx |
	("element" + el + "at index" + idx + "was visited.").postln;
};
)

// collect -> make a new list where each element is some transformed version of the original
(
[5, 6, 7].collect {
	| el, idx |
	el + 1;
};
)

// arithmetic on lists can be written without collect
(
[5, 6, 7] + 1
)

// other forms exist, e.g. doAdjacentPairs
(
[1,2,3].doAdjacentPairs {
	| el1, el2, idx |
	("pair (" + el1 + "," + el2 + ") visited at index" + idx).postln;
}
)

// multiline strings
(
var f = "a"
"b"
"c";
var g;

f.postln;

g = "abc";
g.postln;
)

//
// VERY dangerous pitfall: order of operations in arithmetic
//
(
(1 + 2*3).debug("1 + 2*3");
(1 + (2*3)).debug("(1 + (2*3))");
)


//
// using events to store data and functions
//

(
var thing = (\data : 123);
thing[\mysum] = {
	| self, a, b |
	("printing self from the function" + self).postln;
	self[\data].debug("self.data");
	self.data.debug("self.data alternative");
	a + b;
};

//
// DANGEROUS PITFALL: given that we abuse an "event", some functions already
// have a meaning and can produce disturbing results, e.g.
//

thing[\sum] = {
	| self, a, b |
	("printing self from the function" + self).postln;
	a + b;
};
thing.sum(4, 5).debug("sum 3");
)

// to avoid getting in to trouble, you can use this safeguard way of adding members to events
(
var thing = (
	\safeReg : {
		| self, name, implementation, verbose=0 |
		var symbolicname = name.asSymbol;
		if (self.respondsTo(symbolicname)) {
			("Error! Registering" + "\\" ++ symbolicname + "would overwrite a member that exists already.").postln;
		} {
			if (self.keys.includes(symbolicname)) {
				("Error! Cannot register" + "\\" ++ symbolicname + "twice.").postln;
			} {
				if (verbose != 0) {
					("Registered" + "\\" ++ symbolicname ++ ".").postln;
				};
				self[symbolicname] = implementation;
			};
		};
	};
);

thing.safeReg(\sum, { |self, a, b| a + b; }); // will fail because sum has a predefined meaning
thing.safeReg(\myownsum, { |self, a, b| a + b; }); // should not fail
thing.safeReg(\myownsum, { |self, a, b| a * b; }); // should fail
thing.myownsum(4,5).debug("myownsum");
)

////////////////////////////////////////////////////////////////////////////////////////////////
//
// Specifying music fragments
//

// traditional approach -> using midinotes or scale degrees = DISASTER for maintenance
(
var lhs = Pbind(
	\instrument, \default,
	\midinote, Pseq([
		41, 41, 41, 43, 43, 43, 43, 43, 43, 45, 45, 45, % meas 1
		41, 41, 41, 43, 43, 43, 43, 43, 43, 45, 45, 45, % meas 2
		41, 41, 41, 43, 43, 43, 43, 43, 43, 45, 45, 45,
		41, 41, 41, 43, 43, 43, 43, 43, 43, 45, 45, 45], 1),
	\dur, Pseq([
		1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0,
		1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0,
		1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0,
		1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0, 1.5, 1.5, 1.0], 1),
	\amp, 0.8,
	\legato, 0.9
);
var rhs = Pbind(
	\instrument, \default,
	\midinote, Pseq([
		69, 69, 76, 74, 72, 71, 71, 71, 74, 72, 71, // measure 1
		69, 69, 84, 83, 84, 83, 84, 69, 69, 84, 83, // measure 2
		84, 83, 84, 69, 69, 76, 74, 72, 71, 71, 71, // etc
		74, 72, 71, 69, 69, 84, 83, 84, 83, 84, 69,
		69, 84, 83, 84, 83, 84, 72, 72, 72, 72, 72,
		72, 72, 76, 74, 74, 74, 74, 72, 72, 71, 71,
		69, 69, 84, 83, 84, 83, 84, 69, 69, 84, 83,
		84, 83, 84, 72, 72, 72, 72, 72, 72, 72, 76,
		74, 74, 74, 74, 72, 72, 71, 71, 69, 69, 84,
		83, 84, 83, 84, 69, 69, 84, 83, 84, 83, 84], 1),
	\dur, Pseq([
		1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5, 1.0, 0.5, 0.5,
		1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5,
		0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5,
		1.0, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
		0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5,
		0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5,
		0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], 1),
);
)

Quarks.install("https://github.com/shimpe/panola");


(
p = Panola.new("c d e f g a b");
p.asPbind.play;
)

http://sccode.org/1-5aq


(
// alternative: Panola (pattern notation language)
// much easier to maintain your score, and just as flexible!
var	rhs_pan = Panola(
	"(a4_4 a_8 e5_8 d5_4 c5 "
	"b4_4 b_8 b d5_4 c_8 b4 "
	"a4_4 a_8 c6_8 b5 c6 b5 c6 "
	"a4_4 a_8 c6 b5 c6 b5 c6)*2 "
	"(c5_8 c c c c c c e "
	"d d d d c c b4 b a4_4 a_8 c6_8 b5 c6 b5 c6 "
	"a4_4 a_8 c6 b5 c6 b5 c6)*2");

var	lhs_pan = Panola(
	"(f2_8*3 f2_8*3 f2_8*2 "
	"g2_8*3 g2_8*3 g2_8*2 "
	"g2_8*3 g2_8*3 g2_8*2 "
	"a2_8*3 a2_8*3 a2_8*2)*4");

// can still access all of the note numbers, durations, and many other properties
// for calculations
var notes = rhs_pan.midinotePattern.asStream.all.debug("notes");
var durations = (rhs_pan.durationPattern.asStream.all*4).debug("durations");
)

// making transformers: functions that take a list of notes/durations and transform
// into a new list of notes/durations
//
// important: allow for transformers to be combined by ensuring input and output are in
// a compatible format
//
// in particular, in this tutorial, each transformer will take
// at least one argument note_durs, that is, a list of lists:
// [ notenumbers, durations ]
// so the notenumbers are given by note_durs[0] and the durations by note_durs[1]
//

(
var transformers = (
	\safeReg : {
		| self, name, implementation, verbose=0 |
		var symbolicname = name.asSymbol;
		if (self.respondsTo(symbolicname)) {
			("Error! Registering" + "\\" ++ symbolicname + "would overwrite a member that exists already.").postln;
		} {
			if (self.keys.includes(symbolicname)) {
				("Error! Cannot register" + "\\" ++ symbolicname + "twice.").postln;
			} {
				if (verbose != 0) {
					("Registered" + "\\" ++ symbolicname ++ ".").postln;
				};
				self[symbolicname] = implementation;
			};
		};
	};
);
// simplest transformer: do nothing
transformers.safeReg(\nop, {
	| self, notes_durs |
	notes_durs;
});

transformers.safeReg(\retrograde, {
	// only retrograde melody, keep original rhythm
	| self, notes_durs |
	[ notes_durs[0].reverse, note_durs[1] ];
});

transformers.safeReg(\retrograde_all, {
	// only retrograde melody, keep original rhythm
	| self, notes_durs |
	[ notes_durs[0].reverse, note_durs[1].reverse ];
});

transformers.safeReg(\inv, { // DON'T USE \invert because it has a predefined meaning
	| self, notes_durs, around |
	var oldnotes = notes_durs[0];
	var olddurs = notes_durs[1];
	var newnotes = (around*2) - oldnotes;
	[newnotes, olddurs];
});

transformers.safeReg(\invert_retrograde, {
	| self, notes_durs, around |
	self.retrograde(self.inv(notes_durs, around));
});

transformers.safeReg(\arp, {
	| self, notes_durs, octaves=#[0,1] |
	var oldnotes = notes_durs[0];
	var olddurs = notes_durs[1];
	var newnotes = [], newdurs = [];
	oldnotes.doAdjacentPairs {
		| el1, el2, idx |
		octaves.do {
			| octave, i |
			newnotes = newnotes ++ (el1 + (octave*12)) ++ (el2 + (octave*12));
			newdurs = newdurs ++ ((olddurs[idx]/(2*octaves.size))!2);
		};
	};
	newnotes = newnotes ++ oldnotes.last;
	newdurs = newdurs ++ olddurs.last;
	[newnotes, newdurs];
});

transformers.safeReg(\spray, {
	| self, notes_durs, allowed_embellishments=nil |
	var newnotes = [], newdurs = [];
	var oldnotes = notes_durs[0];
	var olddurs = notes_durs[1];
	if (allowed_embellishments.isNil) {
		allowed_embellishments = [-12,0,12];
	};
	oldnotes.do {
		| note, idx |
		var no_of_new_notes = 7.rrand(1);
		no_of_new_notes.do {
			var helper = allowed_embellishments;
			var extendedhelper = helper;
			newnotes = newnotes ++ (note + extendedhelper.choose);
			newdurs = newdurs ++ (olddurs[idx] / no_of_new_notes);
		};
	};
	[newnotes, newdurs];
});

transformers.safeReg(\interpolate, {
	| self, notes_durs |
	var newnotes = [], newdurs = [];
	var oldnotes = notes_durs[0];
	var olddurs = notes_durs[1];
	oldnotes.doAdjacentPairs{
		| el1, el2, idx |
		var no_of_new_notes = 5.rrand(1);
		var interpolnotes = [];
		no_of_new_notes.do({
			|idx|
			var helper = idx.linlin(0, no_of_new_notes, el1, el2).asInteger;
			interpolnotes = interpolnotes ++ helper;
		});
		newnotes = newnotes ++ el1 ++ interpolnotes;
		newdurs = newdurs ++ ((olddurs[idx]/(interpolnotes.size+1))!(interpolnotes.size+1));
	};
	newnotes = newnotes ++ oldnotes.last;
	newdurs = newdurs ++ olddurs.last;
	[newnotes, newdurs];
});

// utility to transform note name into midi note number
note = {
	|notename|
	Panola(notename).midinotePattern.asStream.first;
};

// utility to transform list [ notenumbers, notedurations ] into
// full-fledged pattern, ready for playing
aspat = {
	| notes_durations, midi=0, midichan=0, volume=0.8 |
	if (midi!=0) {
		Pbind(
			\type, \midi,
			\midicmd, \noteOn,
			\midiout, ~midiout,
			\chan, midichan,
			\midinote, Pseq(notes_durations[0], 1),
			\dur, Pseq(notes_durations[1], 1),
			\amp, Pseq([volume], inf),
			\legato, Pseq([0.9], inf)
		);
	} {
		Pbind(
			\instrument, \default,
			\midinote, Pseq(notes_durations[0], 1),
			\dur, Pseq(notes_durations[1], 1),
			\amp, Pseq([volume], inf),
			\legato, Pseq([0.9], inf)
		);
	};
};

)
////////////////////////////////////////////////////////////////////////////////////////////////
(
s.waitForBoot{
	var extmidi = 0; // if set to 1, external synth will be used instead of internal synth
	var lhs_pan, rhs_pan, lhs_notes, lhs_durations, rhs_notes, rhs_durations, l, r;
	var transformers = (
		\safeReg : {
			| self, name, implementation, verbose=0 |
			var symbolicname = name.asSymbol;
			if (self.respondsTo(symbolicname)) {
				("Error! Registering" + "\\" ++ symbolicname + "would overwrite a member that exists already.").postln;
			} {
				if (self.keys.includes(symbolicname)) {
					("Error! Cannot register" + "\\" ++ symbolicname + "twice.").postln;
				} {
					if (verbose != 0) {
						("Registered" + "\\" ++ symbolicname ++ ".").postln;
					};
					self[symbolicname] = implementation;
				};
			};
	};);
	var variations = ();
	var note, aspat, lhs, rhs, kick;
	var tc = TempoClock(126.0/60.0);
	var rvol = 0.4, lvol = 0.5;

	if (extmidi == 1) {
		if (MIDIClient.initialized.not) { MIDIClient.init; };
		~midiout = MIDIOut.newByName("INTEGRA-7", "INTEGRA-7 MIDI 1");
	};

	// change the melody and bass line to avoid copyright issues
	// rhs_pan = Panola("(a4_4 a_8 e5_8 d5_4 c5 b4_4 b_8 b d5_4 c_8 b4 a4_4 a_8 c6_8 b5 c6 b5 c6 a4_4 a_8 c6 b5 c6 b5 c6)*2 (c5_8 c c c c c c e d d d d c c b4 b a4_4 a_8 c6_8 b5 c6 b5 c6 a4_4 a_8 c6 b5 c6 b5 c6)*2");
	// lhs_pan = Panola("(f2_8*3 f2_8*3 f2_8*2 g2_8*3 g2_8*3 g2_8*2 a2_8*3 a2_8*3 a2_8*2 a2_8*3 a2_8*3 a2_8*2)*4");

	rhs_pan = Panola("(a4_4 a_8 e5_8 f5_4 e5 b4_4 b_8 c5 d5_4 e_8 b4 a4_4 a_8 c6_8 d6 c6 d6 c6 a4_4 a_8 c6 d6 c6 d6 c6)*2 (c5_8 c c c c c c a4 d5 d d d c c e5 e a4_4 a_8 c6_8 d6 c6 d6 c6 a4_4 a_8 c6 d6 c6 d6 e6)*2");
	lhs_pan = Panola("(f2_8*3 f2_8*3 f2_8*2 g2_8*3 g2_8*3 e2_8 g2_8 a2_8*3 a2_8*3 a2_8*2 a2_8*2 a2_8 a2_8*2 a2_8 b2_8 c3_8)*4");
	lhs_notes = lhs_pan.midinotePattern.asStream.all;
	lhs_durations = (lhs_pan.durationPattern.asStream.all*4);
	rhs_notes = rhs_pan.midinotePattern.asStream.all;
	rhs_durations = (rhs_pan.durationPattern.asStream.all*4);
	l = [lhs_notes, lhs_durations];
	r = [rhs_notes, rhs_durations];

	transformers.safeReg(\nop, {
		// transformers replace list of notes and durations with a new list of notes and durations
		| self, notes_durs |
		notes_durs;
	});
	transformers.safeReg(\spray, {
		| self, notes_durs, allowed_embellishments=nil |
		var newnotes = [], newdurs = [];
		var oldnotes = notes_durs[0];
		var olddurs = notes_durs[1];
		if (allowed_embellishments.isNil) {
			allowed_embellishments = [-12,0,12];
		};
		oldnotes.do {
			| note, idx |
			var no_of_new_notes = 7.rrand(1);
			no_of_new_notes.do {
				var helper = allowed_embellishments;
				var extendedhelper = helper;
				newnotes = newnotes ++ (note + extendedhelper.choose);
				newdurs = newdurs ++ (olddurs[idx] / no_of_new_notes);
			};
		};
		[newnotes, newdurs];
	});
	transformers.safeReg(\interpolate, {
		| self, notes_durs |
		var newnotes = [], newdurs = [];
		var oldnotes = notes_durs[0];
		var olddurs = notes_durs[1];
		oldnotes.doAdjacentPairs{
			| el1, el2, idx |
			var no_of_new_notes = 5.rrand(1);
			var interpolnotes = [];
			no_of_new_notes.do({
				|idx|
				var helper = idx.linlin(0, no_of_new_notes, el1, el2).asInteger;
				interpolnotes = interpolnotes ++ helper;
			});
			newnotes = newnotes ++ el1 ++ interpolnotes;
			newdurs = newdurs ++ ((olddurs[idx]/(interpolnotes.size+1))!(interpolnotes.size+1));
		};
		newnotes = newnotes ++ oldnotes.last;
		newdurs = newdurs ++ olddurs.last;
		[newnotes, newdurs];
	});
	transformers.safeReg(\inv, { // !! don't use \invert
		| self, notes_durs, around |
		var oldnotes;
		var olddurs;
		var newnotes;
		oldnotes = notes_durs[0];
		olddurs = notes_durs[1];
		newnotes = (oldnotes - around).neg + around;
		[newnotes, olddurs];
	});
	transformers.safeReg(\retrograde, {
		| self, notes_durs |
		[notes_durs[0].reverse, notes_durs[1]];
	});
	transformers.safeReg(\retrograde_all, {
		| self, notes_durs |
		[notes_durs[0].reverse, notes_durs[1].reverse];
	});
	transformers.safeReg(\invert_retrograde, {
		| self, notes_durs, around |
		self.retrograde(self.inv(notes_durs, around));
	});
	transformers.safeReg(\arp, {
		| self, notes_durs, octaves=#[0,1] |
		var newnotes = [], newdurs = [];
		var oldnotes = notes_durs[0];
		var olddurs = notes_durs[1];
		oldnotes.doAdjacentPairs {
			| el1, el2, idx |
			octaves.do {
				| octave, i |
				newnotes = newnotes ++ (el1 + (octave*12)) ++ (el2 + (octave*12));
				newdurs = newdurs ++ ((olddurs[idx]/(2*octaves.size))!2);
			};
		};
		newnotes = newnotes ++ oldnotes.last;
		newdurs = newdurs ++ olddurs.last;
		[newnotes, newdurs];
	});
	note = {
		|notename|
		Panola(notename).midinotePattern.asStream.first;
	};
	aspat = {
		| notes_durations, midi=0, midichan=0, volume=0.8 |
		if (midi!=0) {
			Pbind(
				\type, \midi,
				\midicmd, \noteOn,
				\midiout, ~midiout,
				\chan, midichan,
				\midinote, Pseq(notes_durations[0], 1),
				\dur, Pseq(notes_durations[1], 1),
				\amp, Pseq([volume], inf),
				\legato, Pseq([0.9], inf)
			);
		} {
			Pbind(
				\instrument, \default,
				\midinote, Pseq(notes_durations[0], 1),
				\dur, Pseq(notes_durations[1], 1),
				\amp, Pseq([volume], inf),
				\legato, Pseq([0.9], inf)
			);
		};
	};

	lhs = aspat.(l, extmidi, 0, lvol);
	rhs = aspat.(r, extmidi, 1, rvol);
	if (extmidi == 1) {
		kick = Pn(aspat.([[41], [1]], extmidi, 9, 1), inf);
	} {
		kick = Pbind(\instrument, \default, \midinote, Pseq([Rest()], inf), \dur, 1);
	};

	variations = ();
	variations[\1] = Ppar([
		lhs,
		rhs]);
	variations[\2] = Ppar([
		lhs,
		aspat.(transformers.spray(r), extmidi, 1, lvol)]);
	variations[\3] = Ppar([
		lhs,
		aspat.(transformers.interpolate(r), extmidi, 1, rvol),
		aspat.(transformers.retrograde_all(transformers.interpolate(r)), extmidi, 1, rvol)
	]);
	variations[\4] = Ppar([
		lhs,
		aspat.(transformers.spray(l, [0,12,24]), extmidi, 0, lvol),
		aspat.(transformers.interpolate(transformers.inv(r, note.("a-5"))), extmidi, 1, rvol),
		rhs
	]);
	variations[\5] = Ppar([
		aspat.(transformers.arp(l, [-1,0,1]), extmidi, 0, lvol),
		aspat.(transformers.retrograde_all(r), extmidi, 1, rvol),
		rhs]);
	variations[\6] = Ppar([
		lhs,
		aspat.(transformers.arp(l, [-1,0,1]), extmidi, 0, lvol),
		rhs,
		aspat.(transformers.retrograde(r), extmidi, 1, rvol),
		aspat.(transformers.inv(r, note.("a-5")), extmidi, 1, rvol),
		aspat.(transformers.invert_retrograde(r, note.("a-5")), extmidi, 1, rvol)
	]);
	variations[\7] = Ppar([
		lhs,
		aspat.(transformers.arp(l, [0,1,2]), extmidi, 0, lvol),
		aspat.(transformers.arp(transformers.retrograde(r), [-1,0,1]), extmidi, 1, rvol),
	]);
	variations[\8] = Ppar([
		lhs,
		aspat.(transformers.arp(l, [0,1,2]), extmidi, 0, lvol),
		aspat.(transformers.arp(transformers.spray(transformers.retrograde_all(r), [-1,0,1])), extmidi, 1, rvol),
		aspat.(transformers.arp(transformers.retrograde(transformers.interpolate(r)), [1,12/7,1]), extmidi, 1, rvol),
	]);
	~player = Pspawner{
		|sp|
		sp.wait(1.0); // bug? first beat's timing is WAY off if I don't wait here.
		sp.par(
			Pseq([
				Pseq([variations[\1], variations[\4], variations[\5], variations[\6], variations[\2], variations[\7], variations[\8], variations[\3], variations[\1]], 1),
				Pfunc { sp.suspendAll; }
		], 1));
		sp.par(kick);
	}.play(tc);

	CmdPeriod.doOnce {
		if (~player.notNil) { ~player.stop; };
		16.do {
			| chan |
			if (~midiout.notNil) {
				~midiout.allNotesOff(chan);
			};
		};
	};
};
)