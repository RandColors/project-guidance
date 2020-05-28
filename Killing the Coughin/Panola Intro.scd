// Panola is a way to extract Pbind keys from a concise specification.
// This makes it easier to compose "traditional" music with Pbind, with a lot less
// headache trying to keep the different keys in sync
// It's the type of system I've missed since my day one with supercollider.

// First things first. To install Panola:

Quarks.install("https://github.com/shimpe/panola");

// Now you can get the help document by typing ctrl+D with the cursor on the word
// Panola in the next line

Panola.new("a4");

// Let's start with the "Hello world" of Panola: a simple scale.
// The numbers indicate octaves.
// You don't need to repeat octave numbers if they don't change between notes.
(
~ex = Panola.new("c4 d e f g a b c5");
~player = ~ex.asPbind.play;
)

// asPbind takes a synth name as parameter (which defaults to \default).
// So the above is equivalent to
(
~ex = Panola.new("c4 d e f g a b c5");
~player = ~ex.asPbind(\default).play;
)

// instead of calling a single "asPbind" you can also extract all information separately
// like this you have optimal flexibility in what you want to use from Panola
(
~ex = Panola.new("c4 d e f g a b c5");
~pat = Pbind(\instrument, \default,
	\midinote, ~ex.midinotePattern,
	\dur, ~ex.durationPattern,
	\amp, ~ex.volumePattern,
	\tempo, ~ex.tempoPattern,
	\lag, ~ex.lagPattern,
	\legato, ~ex.pdurPattern);
~player = ~pat.play;
)

// You can make chords using angular brackets. Only note properties of the first
// note in the chord (other than octave number and note modifier (see later)) are
// taken into account.
(
~ex = Panola.new("<c4 e> <e g> <c e g c5>");
~player = ~ex.asPbind.play;
)

// You can use modifiers on the notes:
// # for sharp, x for double sharp, - for flat, -- for double flat
(
~ex = Panola.new("c4 d- e f# gx a# b-- c5");
~player = ~ex.asPbind.play;
)


// With underscores you can indicate rhythm.
// The last used rhythm value is reused until a new one is specified:
// Here's four quarter notes (_4) followed by four eighth notes (_8).
(
~ex = Panola.new("(c4_5\\pdur[0.1] d e_7 f g_11 a b c5 c5_8. b4 a g f_16 e d_ c4)*10");
//~player = ~ex.asPbind.play;
)




~player = ~pat.play;
// You can use one or more dots to extend the length of the rhythm, as in traditional notation.
(
~ex = Panola.new("c4_4. d_8 e_4 f g_16 a_4.. b_4 c5");
~player = ~ex.asPbind.play;
)

// You can also use multipliers and/or dividers to change the length.
// E.g. here we use it to create a note that lasts for three eighths
// (c4_8*3) and to create tuplets (e_8*2/3 f g). Remember that last
// duration/rhythm indication is reused until a new one is specified.
(
~ex = Panola.new("c4_8*3 d_8 e_8*2/3 f g f_16 e f e g_4 b_4 c5");
~player = ~ex.asPbind.play;
)

// You can repeat certain phrases by putting them in brackets and multiply
// them with a number (corresponding to the number of repeats)( )*3
// repeats can be nested
(
~ex = Panola.new("((c4_16 d)*3 (e f)*3)*2 (g a)*3 c5_4");
~player = ~ex.asPbind.play;
)

// Now we come to the animated property system. We can attach properties to the notes and animate them over time.
// For now two types of animation are supported: linear interpolation and fixed value.
// To indicate linear interpolation, use curly brackets {}. E.g. here we let the tempo gradually increase from 80 bpm to 160 bpm:
(
~ex = Panola.new("c4\\tempo{80} d e f g a b c5\\tempo{160}");
~player = ~ex.asPbind.play;
)

// Different properties can be combined. Here we let the volume go up until the middle of the phrase, then let it go down again,
// while tempo is rising from 80 bpm to 160 bpm.

(
~ex = Panola.new("c4\\tempo{80}\\vol{0.2} d e f g\\vol{0.9} a b c5\\tempo{160}\\vol{0.2}");
~player = ~ex.asPbind.play;
)

// If you want to use the fixed values, use square brackets instead. You can switch between fixed and animated everytime
// you specify a new property value. In the next example, tempo remains at 80 bpm until we come to note a. At that point,
// it jumps to value 100 bpm and gradually increases to 200.
(
~ex = Panola.new("c4\\tempo[80] d e f g a\\tempo{100} b c5 d e f g a b c6\\tempo{200}");
~player = ~ex.asPbind.play;
)

// Using pdur (think: played duration), we can indicate the difference between staccato and legato.
// Here we slowly evolve from very staccato to very legato:
(
~ex = Panola.new("c4_8\\pdur{0.1} d e f g a b c5 d e f g a b c6\\pdur{1}");
~player = ~ex.asPbind.play;
)

// Using lag we can modulate lag. This can be a way of creating a rubato feeling.
// Linear interpolation is not ideal for this purpose, but it's better than nothing at the moment.

(
~ex = Panola.new("a5_8\\tempo[120]\\lag{0} b c6 a5 e d c5 d e c a4 g#4\\lag{0.5} "
	"a4_8 b c5 a4 e d c4 d e c a3 g#3 a b c4 d e g# a_2\\lag{0}");
~player = ~ex.asPbind.play;
)

// In addition to using predefined properties like tempo and lag, you can also use user
// defined properties, e.g. here we animate a property called "myprop".
(
~phrase = Panola.new("c d\\myprop{0.1} e f g a\\myprop{0.6}");
~pattern = ~phrase.customPropertyPattern("myprop"); // extract only myprop values as a pattern
~stream = ~pattern.asStream;
10.do({
	| i |
	~stream.next.postln;
});
)
// make a pbind in which the myprop appears as one of the keys, with a default value of 0 for myprop
(
~phrase = Panola.new("c d\\myprop{0.1} e f g a\\myprop{0.6}");
~pbind = ~phrase.asPbind(\default);
~stream = ~pbind.patternpairs[13].asStream;
10.do({
	| i |
	~stream.next.postln;
});
)
// make a pbind in which the myprop appears as one of the keys, with a customized default value of 0.4 for myprop
// (such default values are used if no values for myprop are specified yet, e.g. in the beginning of a Panola string,
//  before any myprop is defined).
(
~phrase = Panola.new("c d\\myprop{0.1} e f g a\\myprop{0.6}");
~pbind = ~phrase.asPbind(\default, custom_property_defaults:Dictionary.newFrom(["myprop", 0.4]));
~stream = ~pbind.patternpairs[13].asStream;
10.do({
	| i |
	~stream.next.postln;
});
)
// make pbind in which only the standard panola keys are included
(
~phrase = Panola.new("c d\\myprop{0.1} e f g a\\myprop{0.6}");
~pbind = ~phrase.asPbind(\default, include_custom_properties:false);
~pbind.patternpairs.postln;
)

// These custom properties can be e.g. used to drive synth arguments
// The 303 synth used below is reused from https://sccode.org/1-4Wy
// which in turn is based on code from Lance J. Putnam
(
s.waitForBoot({
	var line;

	SynthDef (\sc303 , {  arg  out=0, freq=440, wave=0, ctf=100, res=0.2,
		sus=0, dec=1.0, env=1000, gate=1, vol=0.1;
		var  filEnv, volEnv, waves;
		volEnv =  EnvGen .ar( Env .new([10e-10, 1, 1, 10e-10], [0.01, sus, dec],  'exp' ), gate, doneAction:2);
		filEnv =  EnvGen .ar( Env .new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate);
		waves = [ Saw .ar(freq, volEnv),  Pulse .ar(freq, 0.5, volEnv)];
		Out .ar(out,  RLPF .ar(  Select .ar(wave, waves), ctf + (filEnv * env), res).dup * vol);
	}).add;

	s.sync;

	line = Panola.new(
		"a2_16\\wave[0]\\vol{0.05}\\tempo{120}\\res{0.2}\\sus{0}\\env{1000}\\ctf{100} a a a1 a2 a a3 a2 a a a1 a2 a3 a2 b- g\\res{0.05} "
		"a2_16\\wave[0] a a a1 a2 a a3\\sus{0.2} a2 a\\ctf{3000} a a1 a2 a3 a2 b- g\\res{0.2} "
		"a2_16\\wave[0] a a a1 a2 a a3 a2 a a a1 a2 a3 a2 b- g\\res{0.01}\\sus{0}\\env{10000}\\ctf{10} "
	);
	~player = line.asPbind(\sc303).play;
});
)