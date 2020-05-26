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
~metro.setBpm(180);
~metro.playClick;
~metro.stopClick;
~metro.print;

(
Ndef(\monitor){
    var trigs = In.kr(~lightsBus,6);
	Mix(Compander.ar( Pan2.ar( SinOsc.ar(72.midicps)*Decay2.kr(trigs.linlin(0.3,1.0,0.0,1.0), 0.02,0.1)),[-1,1])/20);
}.play;
)

(
Pbindef(\drumtranscript,
    \instrument, \DcOuts,
	\stretch,4,
	\legato,1,
    \bus,Pseq((0..5),inf) + ~lightsBus.index,
    \env, Pseq([[Env.perc(0.001,0.999,1,4)]],inf),
	[\dur,\amp],Pseq(~bars13_14++~bars15_17++~bars18_19,1),
    \finish, ~beatsToSeconds
).play(~metro.base ,quant:~metro.base.beatsPerBar);
)

// add  a general control for amplitude, multiply all the amp value from the array with the value of the bus

Pbindef(\drumtranscript).play(~metro.base ,quant:[~metro.base.timeToNextBeat,0]);
Pbindef(\drumtranscript).stop;
Pbindef(\drumtranscript).clear.play;//restart it from scretch

(
var flam  = 1/128;
~bars13_14 = [

	[(3/4:0),(1/4:1)],
	[(1/12:1),(1/24!2),(1/12!1)].flat,
	[((flam : 1)!1),(((1/12 - flam):1)!1),((1/12:1)!1),(1/12!1)].flat,
	[((flam )!1),(((1/12 - flam):1)!1),(1/12!1),((flam)!1),(((1/12 - flam):1)!1)].flat,
	[(1/12!1),(1/12:1),(1/12!1)].flat
].collect(~getDurAmpPairs.(_)).flatten
)

(
var flam, t_accflam, t_flam, s_accflam, s_flam, t, t_acc, ss, ss_acc;
flam  = 1/128;
t_accflam = (((1/12 - flam):1)!1);
t_flam = ((1/12 - flam)!1);
s_accflam = (((1/24 - flam):1)!1);
s_flam = ((1/24 - flam)!1);
t = (1/12!1);
t_acc = ((1/12:1)!1);
ss = (1/24!1);
ss_acc = ((1/24:1)!1);


~bars15_17 = [
	[ss!2,t!2].flat,
	[t!9].flat,

	[t_acc,ss,ss_acc,t].flat,
	[t_acc,ss_acc,ss,t].flat,
	[ss_acc,ss,t,flam,t_flam].flat,
	[t!2,t_acc].flat,

	[t_acc,ss!4,t_acc!2,ss!4].flat,
	[t!3].flat

].collect(~getDurAmpPairs.(_)).flatten
)



(
var flam,
t, t_acc, t_accflam, t_flam,
ss, ss_acc, ss_accflam, ss_flam,
n, n_acc, n_flam, n_accflam,np_acc, np_inner, np_acc_inner,
c, c_flam, c_accflam, c_acc,c_ss, c_ss_acc ;

flam  = 1/128;
t_accflam = (((1/12 - flam):1)!1);
t_flam = ((1/12 - flam)!1);
ss_accflam = (((1/24 - flam):1)!1);
ss_flam = ((1/24 - flam)!1);

t = (1/12!1);
t_acc = ((1/12:1)!1);

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


~bars18_19 = [
	[t_acc,ss!4].flat,
	[ss!6].flat,
	[c_acc,c_ss_acc,c_ss,c_ss_acc,c_ss,c_ss_acc,c_ss,c_ss_acc,c_ss].flat,

	[np_acc,n_acc,n!2,n_acc,n!2].flat,
	[n_acc,n!2,n_acc,n!2,np_acc_inner!2].flat

].collect(~getDurAmpPairs.(_)).flatten
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