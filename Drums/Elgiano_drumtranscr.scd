La frazione ha come numeratore il numero
di note del gruppo irregolare e come denominatore il numero di note che normalmente occupa
Capitolo 2: Notazione comunemente utilizzata 27
la stessa durata. Per le terzine ci sono tre note invece di due, quindi una terzina ha 3/2 come
frazione:
\relative {
\tuplet 3/2 { f''8 g a }
\tuplet 3/2 { c8 r c }
\tuplet 3/2 { f,8 g16[ a g a] }
\tuplet 3/2 { d4 a8 }
}


// you should consider to use panola
// the problem of using panola is that you can't use your way to work with metros.

~ex = Panola.new("(c4_16\\tempo[120] c c c c4_16. c c c c4_16.. c c c )*1"); // 16th  16.th 16..th
~ex = Panola.new("c4_16\\tempo[120] c c c  c_4/3 c c ");


(
Pdef(\a, Pbind(\instrument, \DcOuts,
	\midinote, ~ex.midinotePattern,
	\dur, ~ex.durationPattern,
	\amp, ~ex.volumePattern,
	\tempo, ~ex.tempoPattern,
	\lag, ~ex.lagPattern,
	\legato, 1,
	\bus,Pseq([(0..2)],inf) + ~lightsBus.index,
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	\finish, ~beatsToSeconds
)
).play;
)


~ex = Panola.new(
	"(c4_4@vol[0.0])*3 c4@vol[1.0]"
	"c_4/3@vol[1.0] (c_4/6@vol[0.4])*2 c_4/3"

);


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

(
~getDurAmpPairs = {|spec|

    spec.asArray.collect{|hit|  // you can specify a hit as (dur:amp)
        try{ hit.asKeyValuePairs }

		{ [hit,0.4] }.debug("~getDurAmpPairs"); // or just dur. then it uses a default amp of 0.1
    }
}
)

(
~barsTest = [
	[((1/16:1)!12),1/16!7].flat,
	[(1/16:1),1/16!7].flat.reverse,
	[(1/11:1),1/11!5, (5/11:0.0)].flat,
	[(1/5:1),1/5!4].flat // [(1/5:1),1/5!4].flat.powerset.flat,
].collect(~getDurAmpPairs.(_)).flatten.scramble;
)

// find a way to extract only the first number of every array and sum it to see if the resutl is the same lenght of the bar (eg: 4 if you are in 4/4)
~bars.size.debug("N_elements");


// set tempo
~metro.setBpm(120);
~metro.playClick;
~metro.stopClick;
~metro.print;

(
Ndef(\monitor){
    var trigs = InBus.kr(~lightsBus, 3, 0);
	Mix(Compander.ar( Pan2.ar( SinOsc.ar(72.midicps)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1),
		1-trigs
	),[-1,1])/40);
}.play;
)

(
Ndef(\monitora){
    var trigs =  InBus.kr(~lightsBus, 2, 3);
	Mix(Compander.ar( Pan2.ar( BPF.ar(WhiteNoise.ar(),1500)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/40);
}.play;
)

(
~full =	~bars13_14++~bars15_17++~bars18_19++~bars20_21++~bars22_23++~bars24_26++~bars27_34++
~bars35_38++~bars39_41++~bars42_43++~bars44_46++~bars47_49++~bars50_52++~bars53_55;
)

(
Pbindef(\drumtranscript,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
	\bus,Pseq([(0..2)],inf) + ~lightsBus.index,
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	[\dur,\amp],Pseq(~full,1),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);


Pbindef(\d,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
	\bus,Pseq((3..5),inf) + ~lightsBus.index,
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	[\dur,\amp],Pseq(~full,),
    \finish, ~beatsToSeconds
).play(~metro.nomes[4] ,quant:~metro.base.beatsPerBar);
)




Pbindef(\d).stop;
Pbindef(\d).play(~metro.nomes[3] ,quant:~metro.nomes[0].beatsPerBar);
Pbindef(\d).play(~metro.nomes[3] ,quant:~metro.nomes[0].beatsPerBar);

Pbind(\dur,Pseq([1],inf)).play(~metro.nomes[3] ,quant:~metro.nomes[0].beatsPerBar);

~metro.base.tempo;
~metro.nomes[2].tempo;

// ~bars13_14++~bars15_17++~bars18_19++~bars20_21++~bars22_23++~bars24_26++~bars27_34++~bars35_37
// add  a general control for amplitude, multiply all the amp value from the array with the value of the bus

Pbindef(\drumtranscript).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
Pbindef(\drumtranscript).stop;
Pbindef(\drumtranscript).clear.play;//restart it from scretch


// test 2 metronomi
(
~playMetroBase = Pbind(
	\instrrument, \default,
	\freq, Pseq((72!1)++(60!(~metro.base.beatsPerBar.asFloat-1)),inf).midicps,
	\sustain, 1,
	\dur, 1).play(~metro.base ,quant:~metro.base.beatsPerBar);

~playMetro1 = Pbind(
\instrrument, \default,
	\freq, Pseq((75!1)++(63!(~metro.base.beatsPerBar.asFloat-1)),inf).midicps,
	\sustain, 1,
\dur, 1).play(~metro.nomes[4] ,quant:~metro.nomes[4].beatsPerBar);
)

(
~playMetro1.stop;
~playMetroBase.stop;
)




(
// abbellimenti flam or drag
// tutte le suddivisioni di una nota
// tutte le pause
// accenti, note intensità normale, ghost
// possibilità di scalare i valori di una sezione rispetto ad un inviluppo d'ampiezza generale
// scrivibile da pmono ?
// dictionary di simboli per le diverse variabili
// possibilità di applicare ripetizioni di accenti ogni n elements

|----------------|

var flam,
t, t_acc, t_accflam, t_flam, t_rest,
ss, ss_acc, ss_accflam, ss_flam, ss_rest,
n, n_acc, n_flam, n_accflam, n_rest,
np_acc, np_inner, np_acc_inner,
c, c_flam, c_accflam, c_acc,c_ss, c_ss_acc,
si, si_acc, si_accflam, si_flam, si_rest,
z, z_acc,
o, o_acc, o_accflam, o_flam, o_rest,
q, q_acc, q_accflam, q_flam,
qt, qt_acc, qt_accflam, qt_flam
;

flam  = 1/128;
t_accflam = (((1/12 - flam):1)!1);
t_flam = ((1/12 - flam)!1);
ss_accflam = (((1/24 - flam):1)!1);
ss_flam = ((1/24 - flam)!1);

t = (1/12!1);
t_acc = ((1/12:1)!1);
t_rest =  ((1/12:0)!1);

ss = (1/24!1);
ss_acc = ((1/24:1)!1);

// ninetuplet == 2 quarters
n = (1/18!1);
n_acc = ((1/18:1)!1);
n_flam =  ((1/18 - flam)!1);
n_accflam = (((1/18 - flam):1)!1);
np_acc = ((3/18:1)!1);


// nintuplet .dot
np_inner = (1/36!3);
np_acc_inner = (3/36:1);

// quintuplet == 2 quarters
c = (1/10!1);
c_acc = ((1/10 :1)!1);
c_flam = ((1/10 - flam)!1);
c_accflam = (((1/10 - flam):1)!1);
c_ss = (1/20!1);
c_ss_acc = ((1/20 :1)!1);

// 16th
si = (1/16!1);
si_acc = ((1/16 :1)!1);
si_flam = ((1/16 - flam)!1);
si_accflam = (((1/16 - flam):1)!1);
si_rest =  ((1/16 :1)!1);

// 8th
o = (1/8!1);
o_acc = ((1/8 :1)!1);
o_flam = ((1/8 - flam)!1);
o_accflam = (((1/8 - flam):1)!1);
o_rest =  ((1/8 :1)!1);


//Z z!32 = o
z = (1/256!1);
z_acc = ((1/256 :1)!1);

// q
q = (1/4!1);
q_acc = ((1/4 : 1)!1);
q_flam = ((1/4 - flam)!1);
q_accflam = (((1/4 - flam):1)!1);

// quarter note triplets
qt = (1/3!1);
qt_acc =  ((1/3 : 1)!1);
qt_flam = ((1/3 - flam)!1);
qt_accflam = (((1/3 - flam):1)!1);

~bars13_14 = [

	[(3/4:0),(1/4:1)],
	[(1/12:1),(1/24!2),(1/12!1)].flat,
	[((flam : 1)!1),(((1/12 - flam):1)!1),((1/12:1)!1),(1/12!1)].flat,
	[((flam )!1),(((1/12 - flam):1)!1),(1/12!1),((flam)!1),(((1/12 - flam):1)!1)].flat,
	[(1/12!1),(1/12:1),(1/12!1)].flat
].collect(~getDurAmpPairs.(_)).flatten;

~bars15_17 = [
	[ss!2,t!2].flat,
	[t!9].flat,

	[t_acc,ss,ss_acc,t].flat,
	[t_acc,ss_acc,ss,t].flat,
	[ss_acc,ss,t,flam,t_flam].flat,
	[t!2,t_acc].flat,

	[t_acc,ss!4,t_acc!2,ss!4].flat,
	[t!3].flat

].collect(~getDurAmpPairs.(_)).flatten;

~bars18_19 = [
	[t_acc,ss!4].flat,
	[ss!6].flat,
	[c_acc,c_ss_acc,c_ss,c_ss_acc,c_ss,c_ss_acc,c_ss,c_ss_acc,c_ss].flat,

	[np_acc,n_acc,n!2,n_acc,n!2].flat,
	[n_acc,n!2,n_acc,n!2,np_acc_inner!2].flat

].collect(~getDurAmpPairs.(_)).flatten;


~bars20_21 = [
	[n!6,n_acc!2,n].flat,
	[n!3,n_acc!2,n!4].flat,

	[n_acc,n!2,n_acc,n!2,n_acc,n!2].flat,
	[n_acc,n!2,n_acc,n!2,np_acc_inner,np_inner].flat,

].collect(~getDurAmpPairs.(_)).flatten;

~bars22_23 = [
	[n_acc!3,n!6].flat,
	[n!9].flat,

	[n_acc,n!5,n_acc!2,n].flat,
	[n!3,n_acc!2,n!4].flat,

].collect(~getDurAmpPairs.(_)).flatten;


~bars24_26 = [
	[ss_acc,ss,ss_acc,ss!21].flat,
	[ss!24].flat,

	[si!4,si_acc,si!3,o!2,z!256].flat,

].collect(~getDurAmpPairs.(_)).flatten;


~bars27_34 =[
	[1/4,(3/4 :0)],
	[(2 :0)],
	[(24/4 :0)]
	].collect(~getDurAmpPairs.(_)).flatten;

~bars35_38 =[
	[z_acc,z!63,o,o_acc,o,z_acc,z!64,o,o_acc,o].flat, //5/8 *2
	[si_acc,si!3,si_acc,si!3,si_acc,si!3, o_acc,o].flat, // 4/4
	[z_acc,z!63,o,si_acc,si!3].flat // 5/8
	].collect(~getDurAmpPairs.(_)).flatten;

~bars39_41 =[
	[si_acc,si!5,si_acc,si!3].flat, //5/8 *2
	[si_acc,si!3,ss!12,t!3].flat, // 4/4
	[n_acc!6,np_acc_inner!2].flat,
	[n_acc!3,np_acc,n_acc!3].flat
	].collect(~getDurAmpPairs.(_)).flatten;



~bars42_43 =[
	[np_acc,n_acc!3,np_acc].flat,
	[n_acc!3,np_acc,n_acc!3].flat,

	[np_acc,n_acc!6].flat,
	[q_acc,flam,q_accflam].flat,

	].collect(~getDurAmpPairs.(_)).flatten;


~bars44_46 =[
	[t_acc,t!2,t_acc,ss!4,t_acc,ss!4,t_acc,ss!4].flat,
	[t_acc!2, si_acc, si!6, si_acc, si, ss!6, t_acc, t].flat,
	[si_acc, si,si_acc, si, t, si!2, t, t_acc].flat,

	].collect(~getDurAmpPairs.(_)).flatten;



~bars47_49 =[
	[o_acc,ss!4].flat,
	[o_acc,o].flat,
	[n_acc,n!5,n_acc,n!2].flat,

	[o_acc,o,o_acc,ss!4,o,si_acc!2,si!4,ss_acc,ss!5].flat, // 5/4
	[o_acc,o,o_acc,si!2,qt_acc!3].flat,

	].collect(~getDurAmpPairs.(_)).flatten;

~bars50_52 =[
	[o_acc,o!2,o_acc,o,flam,o_accflam,o!2,flam,ss_acc!2,o].flat,
	[flam,o_accflam,o!2,flam,si_accflam,si_acc,o,si_acc,si,o!2,o_acc,z!32].flat,
	[o,flam,o_accflam,o,flam,o_accflam,flam,o_accflam,flam,o_accflam,o_rest,flam,o_accflam,z!32].flat,
	].collect(~getDurAmpPairs.(_)).flatten;


~bars53_55 = [
	[o,o_acc,o_rest,o_acc,o_rest,o_acc!2,o].flat,
	[t_acc,ss!4,t_acc,ss!4,t_acc,ss!4,t_acc,ss!4].flat,
	[o_acc!2,(3/4:0)].flat,
	[o_acc!2,(5/4:0)].flat,

].collect(~getDurAmpPairs.(_)).flatten;



)






(
~bars = (
	\13000014: [
		[(3/4:0),(1/4:1)],
		[(1/12:1),(1/24!2),(1/12!1)].flat,
		[((1/12:1)!2),(1/12!1)].flat,
		[(1/12!3)].flat,
		[(1/12!1),(1/12:1),(1/12!1)].flat

	].collect(~getDurAmpPairs.(_)).flatten,

	// \15000017 : [
	//
	// ].collect(~getDurAmpPairs.(_)).flatten,
	//
	// \18000019 : [
	//
	// ].collect(~getDurAmpPairs.(_)).flatten,
));

// ~bars[\15000017],~bars[\18000019]
~scorefull = [~bars[\13000014].flat];
~bars[\13000014].flat.postln

.collect(function)
function evaluated for each item in the collection. The function is passed two arguments, the item and an integer index.

List[1, 2, 3, 4].collect({ arg item, i; item + 100 });



Exception Handling
For the following two methods a return ^ inside of the receiver itself cannot be caught. Returns in methods called by the receiver are OK.

.try(handler)
Executes the receiver. If an exception is thrown the catch function handler is executed with the error as an argument. handler itself can rethrow the error if desired.


d = (a: 5, b: 7, c: 1, d: 0);
d.asPairs;

(
// doesn't work
var myarr = [0,10,3,100];
myarr.asKeyValuePairs;
)


.flatten(numLevels: 1)
Returns a collection from which numLevels of nesting has been flattened.

(1..10).collect( _.squared ); // receiver syntax


instead of writing:							you can write:
IdentityDictionary['a'->1,'b'->2]		(a: 1, b: 2)

(
~getDurAmpPairs = {|spec|

    spec.asArray.collect{|hit|  // you can specify a hit as (dur:amp)
        try{ hit.asKeyValuePairs }

		{ [hit,0.1] }.debug("~getDurAmpPairs"); // or just dur. then it uses a default amp of 0.1
    }
}
)

~getDurAmpPairs.value( [(0..9):(0.1..1.0)].flatten);

(
~bars = [
	[(1/8:1),1/8!7].flat,
	[(1/8:1),1/8!7].flat.reverse,
	[(1/11:1),1/11!5, (5/11:0.0)].flat,
	[(1/5:1),1/5!4].flat // [(1/5:1),1/5!4].flat.powerset.flat,
].collect(~getDurAmpPairs.(_)).flatten;
)
~bars.size.debug("N_elements");


(
~bars = [
	 (1/3):[(1/8:1),1/8!7].flat,
	(1/5):[(1/8:1),1/8!7].flat.reverse,
	[(1/11:1),1/11!5, (5/11:0.0)].flat,
	[(1/5:1),1/5!4].flat.powerset.flat,
].collect(~getDurAmpPairs.(_)).flatten;
)
~bars.size.debug("N_elements");

(
Pbind(
	\instrument,\default,
    [\dur,\amp],Pseq(~bars,4)
).play;
)



/*
.respondsTo(aSymbol)
Answer a Boolean whether the receiver understands the message selector.
5.respondsTo('+'); // true
5.respondsTo('indexOf'); // false
Arguments:
aSymbol
A selector name. Must be a Symbol.

shorthand for Symbols
instead of writing:					you can write:
'mySymbol'							\mySymbol
*/



// polyrhytmic
(
~getDurAmpPairs = {|input|
    var seq, durScale;
	if(input.respondsTo('key')){
        seq = input.value;
        durScale = input.key;
    }{
        seq = input;
        durScale = 1;
    };
    seq.asArray.collect{|hit|
        // you can specify a hit as (dur:amp)
        if(hit.repondsTo(\asKeyValuePairs)){
            hit.asKeyValuePairs * [durScale, 1]
        }{
        // or just dur. then it uses a default amp of 0.1
        [hit*durScale,0.1]
        }
    }
}
)

(
~bars = [
    (1/3)->[(1/8:1),1/8,1/8,1/8,1/8,1/8,1/8,1/8],  // on the triplet
    (1/5)->[(1/8:1),1/8,1/8,1/8,1/8,1/8,1/8,1/8], // on the quintuplet
    (1/4)->[(1/8:1),1/8,1/8,1/8,1/8,1/8,1/8,1/8], // on the sixteenth
[(1/8:1),1/8,1/8,1/8,1/8,1/8,1/8,1/8]// on the quarter notes
];
)



~getDurAmpPairs = {|input|
    var seq, durScale;
    if(input.respondsTo(\key)){
        seq = input.value;
        durScale = input.key;
    }{
        seq = input;
        durScale = 1;
    };
    seq.asArray.collect{|hit|
        // you can specify a hit as (dur:amp)
        if(hit.repondsTo(\asKeyValuePairs)){
            hit.asKeyValuePairs * [durScale, 1]
        }{
        // or just dur. then it uses a default amp of 0.1
        [hit*durScale,0.1]
        }
    }
}

~bars = [
    (1/3)->[3, (2:1), 2],  // on the triplet
    (1/5)->[1,(1:0.5),(2:0.2),3], // on the quintuplet
    (1/4)->[(2:1),3], // on the sixteenth
    [2,(3:1),4], // on the quarter notes
];