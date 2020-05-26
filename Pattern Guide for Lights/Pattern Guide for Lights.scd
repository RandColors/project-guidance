
## Streams ##
A stream represents a lazy sequence of values.
A stream can be any object that responds to the .next and .reset messages.
A Stream is an object that responds and embedInStream,
The message embedInStream allows a stream definition to allow another stream to "take over control" of the stream.

There is a default streams implemented by Object.

- next value in the sequence  = message .next to the stream object


7.next.postln;    // 7 responds to next by returning itself

(
var a = (0..9);
a.next.postln;
)

(
var a = Pseq((1..10),1).asStream;
a.next.postln; // the first value
)

-  when a finite length stream has  reached the end, it returns nil.
(
var a = Pseq((1..10),1).asStream;
11.do({a.next.postln}) // the entire stream + nil
)

- Seq restarted from the beginning message .reset

(
var a;
a = Pseries(1,1.1,10).asStream;
~b = fork { loop { a.next.postln; 0.5.wait } };
a.reset; // with .reset restart from the first element of the stream
~b.stop;
)


-  finite or infinite length.
(
var x, c;
x = Pseries(1,1.1,inf).asStream; // infinite stream
c = fork { loop { x.next.postln; 0.5.wait } };
// c.stop; // stop it
//c.reset.play;
)



Also there is http://doc.sccode.org/Classes/Stream.html

Subclass of Stream is the class FuncStream : functions to execute in response to next and reset.
FuncStream is one of the most basic ways to describe a stream: it has a function that is called for each next stream value.

(
var a;
a = FuncStream.new({ [1, 2, 3, 4].choose });
5.do({ a.next.postln; }); // print 5 values from the stream
)



Another useful subclass of Stream is Routine
http://doc.sccode.org/Classes/Routine.html

(
var a;
a = Routine({ 20.do({ 33.rand.yield }) });
21.do({a.next.postln});
)


The yield message returns a value from the Routine
http://www.musicaecodice.it/SC_Controllo/SC_Sequencing/SC_Sequencing.php

(
var a;
a = Routine.new({
        3.do({ arg i; i.yield; })
    });
4.do({ a.next.postln; });    // print 4 values from stream
)

Math operations are possible on a streams to produce other streams.
- unary operator
- binary oeprator
- messages collect, select, and reject for filtering operations


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Patterns are just a way to make multiple Streams from a single specification, like a cookie cutter.
There is a class named Pattern that provides more functionality for the concept of a pattern.

A Pattern object  responds  .asStream  .embedInStream.
A Pattern defines the behavior of a Stream and creates such streams in response to the messages asStream.

The difference between a Pattern and a Stream is similar to the difference between a score and a performance of that score or a class and an instance of that class.

Patterns are defined in terms of other Patterns rather than in terms of specific values.
This allows a Pattern of arbitrary complexity to be substituted for a single value anywhere within a Pattern definition.

// common things to all Patterns, see the .methods you can use on them


http://doc.sccode.org/Overviews/Streams.html

 ## ListPatterns ##
ListPattern - abstract class that holds a list
Pdfsm - deterministic finite state machine
Pfpar - (Undocumented class)
Pfsm - Finite State Machine
Ppar - embed event streams in parallel
Pgpar - embed event streams in parallel and put each in its own group
Pgtpar - (Undocumented class)
Ptpar - embed event streams in parallel, with time offset
Prand - embed values randomly chosen from a list
Pseq - sequentially embed values in a list
Place - interlaced embedding of subarrays
Ppatlace - interlace streams
Pser - sequentially embed values in a list
Pshuf - sequentially embed values in a list in constant, but random order
Pslide - slide over a list of values and embed them
Ptuple - combine a list of streams to a stream of lists
Pwalk - A one-dimensional random walk over a list of values that are embedded
Pwrand - embed values randomly chosen from a list
Pxrand - embed values randomly chosen from a list


 ## FilterPatterns ##
FilterPattern - abstract class that holds a pattern to be modified
FuncFilterPattern - Abstract class that filters a pattern using a function
Pcollect - Apply a function to a pattern
Pfset - Insert an environment into the event prototype before evaluating the supplied pattern
Preject - Filters a source pattern by rejecting particular values.
Pselect - Filters values returned by a source pattern.
Pwhile - While a condition holds, repeatedly embed stream
PAbstractGroup - (Undocumented class)
Pgroup - Starts a new Group and plays the pattern in this group
PparGroup - Starts a new ParGroup and plays the pattern in this group
Pavaroh - applying ascending and descending scales to event stream
Pbindf - bind several value patterns to one existing event stream by binding keys to values
Pbus - isolate a pattern by restricting it to a bus
Pclump - A pattern that takes another pattern and groups its values into arrays.
Pflatten - (Undocumented class)
Pclutch - sample and hold a pattern
Pconst - constrain the sum of a value pattern
Pdiff - (Undocumented class)
Pdrop - (Undocumented class)
PfadeIn - (Undocumented class)
PfadeOut - (Undocumented class)
Pfin - limit number of events embedded in a stream
Pfinval - limit number of items embedded in a stream
PfinQuant - (Undocumented class)
Pfindur - limit total duration of events embedded in a stream
Pfx - add an effect synth to the synths of a given event stream
Pfxb - add an effect synth to the synths of a given event stream
Plag - (Undocumented class)
Plambda - create a scope (namespace) for enclosed streams
Pn - repeatedly embed a pattern
Pgate - A gated stream that only advances when a particular event key is true.
Pplayer - (Undocumented class)
Pprotect - evaluate a function when an error occured in the thread
Prewrite - rewriting system
Prorate - divide stream proportionally
Pseed - set the random seed in subpattern
Pset - event pattern that sets values of one key
Padd - add to value of a key in event stream
Pmul - multiply with value of a key in event stream
Psetp - event pattern that sets values of one key
Paddp - add each value of a pattern to the value at a key in event stream
Pmulp - multiply with each value of a pattern to value of a key in event stream
Psetpre - set values of one key in an event before it is passed up
Paddpre - event pattern that adds to existing value of one kPgaussey
Pmulpre - multiplies with value of a key in event stream, before it is passed up
Pspawn - Spawns sub-patterns based on parameters in an event pattern
Pstretch - (Undocumented class)
Pstretchp - (Undocumented class)
Pstutter - repeat input stream values
PdurStutter - partition a value into n equal subdivisions
Psym - use a pattern of symbols to embed Pdefs
Pnsym - use a pattern of symbols to embed Pdefns
Pnsym1 - (Undocumented class)
Psym1 - (Undocumented class)
Ptsym - (Undocumented class)
Psync - synchronise and limit pattern duration
Ptrace - (Undocumented class)
Pwrap - constrain the range of output values by wrapping
event stream specific filter patterns
Pset
Pfset
Pmul
Padd
Psetp
Pmulp
Paddp
Pfindur

 ## other Patterns ##
Pwhite
Pbrown
Ppatmod
Plazy
Pbind
PstepNadd
PstepNfunc


Pattern : AbstractFunction {


	// concatenate Patterns
	++ { arg aPattern;
		^Pseq.new([this, aPattern])
	}
	// compose Patterns
	<> { arg aPattern;
		^Pchain(this, aPattern)
	}

	play { arg clock, protoEvent, quant;
		^this.asEventStreamPlayer(protoEvent).play(clock, false, quant)
	}
	// phase causes pattern to start somewhere in the current measure rather than on a downbeat
	// offset allows pattern to compute ahead a bit to allow negative lags for strummed chords
	// and to ensure one pattern computes ahead of another

	asStream { ^Routine({ arg inval; this.embedInStream(inval) }) }
	iter { ^this.asStream }
	streamArg { ^this.asStream }

	asEventStreamPlayer { arg protoEvent;
		^EventStreamPlayer(this.asStream, protoEvent);
	}
	embedInStream { arg inval;
		^this.asStream.embedInStream(inval);
	}
	do { arg function;
		this.asStream.do(function)
	}

	// filtering operations
	collect { arg function;
		^Pcollect.new(function, this)
	}
	select { arg function;
		^Pselect.new(function, this)
	}
	reject { arg function;
		^Preject.new(function, this)
	}

	// function composition
	composeUnaryOp { arg operator;
		^Punop.new(operator, this)
	}
	composeBinaryOp { arg operator, pattern, adverb;
		^Pbinop.new(operator, this, pattern, adverb)
	}
	reverseComposeBinaryOp { arg operator, pattern, adverb;
		^Pbinop.new(operator, pattern, this, adverb)
	}
	composeNAryOp { arg selector, argList;
		^Pnaryop.new(selector, this, argList);
	}

	//////////////////////

	mtranspose { arg n; ^Paddp(\mtranspose, n, this) }
	ctranspose { arg n; ^Paddp(\ctranspose, n, this) }
	gtranspose { arg n; ^Paddp(\gtranspose, n, this) }
	detune { arg n; ^Paddp(\detune, n, this) }

	scaleDur { arg x; ^Pmulp(\dur, x, this) }
	addDur { arg x; ^Paddp(\dur, x, this) }
	stretch { arg x; ^Pmulp(\stretch, x, this) }
	lag { arg t; ^Plag(t, this) }

	legato { arg x; ^Pmulp(\legato, x, this) }

	db { arg db; ^Paddp(\db, db, this) }

	clump { arg n; ^Pclump(n, this) }
	flatten { arg n = 1; ^Pflatten(n, this) }
	repeat { arg n=inf; ^Pn(this, n) }
	keep { arg n; ^Pfin(n, this) }
	drop { arg n; ^Pdrop(n, this) }
	stutter { arg n; ^Pstutter(n, this) }
	finDur { arg dur, tolerance = 0.001; ^Pfindur(dur, this, tolerance) }
	fin { arg n = 1; ^Pfin(n, this) }

	trace { arg key, printStream, prefix=""; ^Ptrace(this, key, printStream, prefix) }
	differentiate { ^Pdiff(this) }
	integrate { ^Plazy { var sum = 0; this.collect { |x| sum = sum + x } } }


	// realtime recording
	// for NRT see Pattern:asScore

	// path: if nil, auto-generate path
	// dur: if nil, record until pattern stops or is stopped externally
	// fadeTime: allow extra time after last Event for nodes to become silent

	record { |path, headerFormat = "AIFF", sampleFormat = "float", numChannels = 2, dur = nil, fadeTime = 0.2, clock(TempoClock.default), protoEvent(Event.default), server(Server.default), out = 0, outNumChannels|

		var recorder = Recorder(server);
		var pattern = if(dur.notNil) { Pfindur(dur, this) } { this };

		server.waitForBoot {
			var group, bus, startTime, free, monitor;

			recorder.prepareForRecord(path, numChannels);
			fadeTime = (fadeTime ? 0).roundUp(recorder.numFrames / server.sampleRate);

			bus = Bus.audio(server, numChannels);
			group = Group(server);
			Monitor.new.play(bus.index, bus.numChannels, out, outNumChannels ? numChannels, group);
			server.sync;

			free = { recorder.stopRecording; bus.free; group.free };

			Pprotect(
				Pfset(nil,
					Pseq([
						Pfuncn {
							startTime = thisThread.beats;
							(type: \rest, delta: 0)
						},
						(play: { recorder.record(path, bus, numChannels, group) }, delta: 0),
						pattern <> (out: bus),
						(type: \rest, delta: fadeTime)
					], 1),
					free
				),
				free // on error
			).play(clock, protoEvent, quant: 0);

		}
	}
}


There are 3 types of patterns:

1) EVENT PATTERNS - patterns that generate or require event streams
2) GENERAL PATTERNS that work with both event and value streams
3) VALUE PATTERNS : these patterns define or act on streams of numbers

// post subclasses:
FilterPattern.dumpClassSubtree;
ListPattern.dumpClassSubtree;

A Pfunc is a Pattern that returns a FuncStream.

http://doc.sccode.org/Classes/Pfunc.html
// source code
Pfunc : Pattern {
	var <>nextFunc; // Func is evaluated for each next state
	var <>resetFunc; // Func is evaluated for each next state
	*new { arg nextFunc, resetFunc;
		^super.newCopyArgs(nextFunc, resetFunc)
	}
	storeArgs { ^[nextFunc] ++ resetFunc }
	asStream {
		^FuncStream.new(nextFunc, resetFunc)
	}
}


(
var a, b;
a = Pfunc({ [1, 2, 3, 4].choose });
b = a.asStream;            // make a stream from the pattern
5.do({ b.next.postln; });    // print 5 values from the stream
)


A Prout is a Pattern that returns a Routine

http://doc.sccode.org/Classes/Prout.html

// source
Prout : Pattern {
	var <>routineFunc;
	*new { arg routineFunc;
		^super.newCopyArgs(routineFunc)
	}
	storeArgs { ^[routineFunc] }
	asStream {
		^Routine.new(routineFunc)
	}
	embedInStream { arg inval; ^routineFunc.value(inval) }
}

// Prout can be written as p
(
// here u can use 1 p({}) that will generate 2 different streams, it seems really convenient
var a, b, c;
a = p({
        3.do({ arg i; 3.rand.yield; })
    });
// make two streams from the pattern
b = a.asStream;
c = a.asStream;
4.do({ b.next.postln; });    // print 4 values from first stream
4.do({ c.next.postln; });    // print 4 values from second stream
)

Patterns also respond to math operators by returning patterns that respond to asStream with appropriately modified streams.
- unary operator
- binary oeprator
- messages collect, select, and reject for filtering operations

// source extract

	// filtering operations
	collect { arg function;
		^Pcollect.new(function, this)
	}
	select { arg function;
		^Pselect.new(function, this)
	}
	reject { arg function;
		^Preject.new(function, this)
	}

	// function composition
	composeUnaryOp { arg operator;
		^Punop.new(operator, this)
	}
	composeBinaryOp { arg operator, pattern, adverb;
		^Pbinop.new(operator, this, pattern, adverb)
	}
	reverseComposeBinaryOp { arg operator, pattern, adverb;
		^Pbinop.new(operator, pattern, this, adverb)
	}
	composeNAryOp { arg selector, argList;
		^Pnaryop.new(selector, this, argList);
	}


## ListPatterns ##
http://doc.sccode.org/Tutorials/Streams-Patterns-Events3.html
ListPatterns are Patterns that iterate over arrays of objects in some fashion

(
SynthDef(\help_SPE3_SimpleSine, { |out, freq=440, sustain=1.0|
    var osc;
    osc = SinOsc.ar( [freq, freq+0.05.rand], 0.5pi )
    * EnvGen.ar(
        Env.perc, doneAction: Done.freeSelf, levelScale: 0.3, timeScale: sustain
    );
    Out.ar(out, osc);
}).add;
)

// post subclasses:

ListPattern.dumpClassSubtree;


ListPattern
[
  Pwalk : random walk over a list
  Ppar : embed event streams in parallel // https://doc.sccode.org/Reference/EventStream.html
  [
    Pgpar : embed event streams in parallel and put each in its own group
      [ Pgtpar ] : (Undocumented class)
    Ptpar : embed event streams in parallel, with time offset
  ]
  Pwrand : embed values randomly chosen from a list by a list of weights
  Pdfsm : deterministic finite state machine
  Pshuf : sequentially embed values in a list in constant, but random order
  Pshufn : Pshuf with continuing permutations
  Pseq : sequentially embed values in a list
  [
    Ppatlace : interlace streams
      [ PlaceAll ] : is integrating Ppatlace and Place (taking items as well as Patterns)
    Pser : sequentially embed values in a list the repeats variable gives the number of items
    Place : interlaced embedding of subarrays
  ]
  Pslide : slide over a list of values and embed them
  Ptuple : combine a list of streams to a stream of lists
  Prand : embed values randomly chosen from a list
  Pfpar : (Undocumented class)
  Pxrand : embed values randomly chosen from a list BUT never repeats the same element twice in a row.
  Pfsm : Non-deterministic finite state machine The initial state is chosen at random.
]


ListPattern : Pattern {
	var <>list, <>repeats=1;

	*new { arg list, repeats=1;
		if (list.size > 0) {
			^super.new.list_(list).repeats_(repeats)
		}{
			Error("ListPattern (" ++ this.name ++ ") requires a non-empty collection; received "
				++ list ++ ".").throw;
		}
	}
	copy {
		^super.copy.list_(list.copy)
	}
	storeArgs { ^[ list, repeats ] }
}

Pseq : ListPattern {
	var <>offset;
	*new { arg list, repeats=1, offset=0;
		^super.new(list, repeats).offset_(offset)
	}
	embedInStream {  arg inval;
		var item, offsetValue;
		offsetValue = offset.value(inval);
		if (inval.eventAt('reverse') == true, {
			repeats.value(inval).do({ arg j;
				list.size.reverseDo({ arg i;
					item = list.wrapAt(i + offsetValue);
					inval = item.embedInStream(inval);
				});
			});
		},{
			repeats.value(inval).do({ arg j;
				list.size.do({ arg i;
					item = list.wrapAt(i + offsetValue);
					inval = item.embedInStream(inval);
				});
			});
		});
		^inval;
	}
	storeArgs { ^[ list, repeats, offset ] }
}


// it's like a .. Pseq but..
Pser : Pseq {
	embedInStream { arg inval;
		var item;
		var offsetValue = offset.value(inval);
		if (inval.eventAt('reverse') == true, {
			repeats.value(inval).reverseDo({ arg i;
				item = list.wrapAt(i + offsetValue);
				inval = item.embedInStream(inval);
			});
		},{
			repeats.value(inval).do({ arg i;
				item = list.wrapAt(i + offsetValue);
				inval = item.embedInStream(inval);
			});
		});
		^inval;
	}
}

Pshuf : ListPattern {
	embedInStream { arg inval;
		var item, stream;
		var localList = list.copy.scramble;

		repeats.value(inval).do({ arg j;
			localList.size.do({ arg i;
				item = localList.wrapAt(i);
				inval = item.embedInStream(inval);
			});
		});
		^inval;
	}
}

Prand : ListPattern {
	embedInStream { arg inval;
		var item;

		repeats.value(inval).do({ arg i;
			item = list.at(list.size.rand);
			inval = item.embedInStream(inval);
		});
		^inval;
	}
}

Pxrand : ListPattern {
	embedInStream { arg inval;
		var item, size;
		var index = list.size.rand;
		repeats.value(inval).do({ arg i;
			size = list.size;
			index = (index + (size - 1).rand + 1) % size;
			item = list.at(index);
			inval = item.embedInStream(inval);
		});
		^inval;
	}
}

Pwrand : ListPattern {
	var <>weights;
	*new { arg list, weights, repeats=1;
		^super.new(list, repeats).weights_(weights)
	}
	embedInStream {  arg inval;
		var item, wVal;
		var wStr = weights.asStream;
		repeats.value(inval).do({ arg i;
			wVal = wStr.next(inval);
			if(wVal.isNil) { ^inval };
			item = list.at(wVal.windex);
			inval = item.embedInStream(inval);
		});
		^inval
	}
	storeArgs { ^[ list, weights, repeats ] }
}


Pfsm : ListPattern {
	embedInStream {  arg inval;
		var item, index=0;
		var maxState = ((list.size - 1) div: 2) - 1;
		repeats.value(inval).do({
			index = 0;
			while({
				index = list.at(index).choose.clip(0, maxState) * 2 + 2;
				item = list.at(index - 1);
				item.notNil
			},{
				inval = item.embedInStream(inval);
			});
		});
		^inval;
	}
}

Pdfsm : ListPattern {
	var <>startState;
	*new { arg list, startState=0, repeats=1;
		^super.new( list, repeats ).startState_(startState)
	}

	embedInStream { arg inval;
		var currState, sigStream;
		var sig, state, stream;
		var numStates = list.size - 1;
		repeats.value(inval).do({

			currState = startState;
			sigStream = list[0].asStream;

			while({
				sig = sigStream.next(inval);
				state = list[currState + 1];
				if( sig.isNil, { false }, {
					if( state.includesKey(sig), {
						#currState, stream = state[sig];
					}, {
						#currState, stream = state[\default];
					});
					currState.notNil and: {currState < numStates};
				})
			}, {
				inval = stream.embedInStream(inval);
			})
		});
		^inval;
	}
}

Pswitch : Pattern {
	var <>list, <>which=0;
	*new { arg list, which=0;
		^super.new.list_(list).which_(which)
	}
	embedInStream {  arg inval;
		var item, index;

		var indexStream = which.asStream;
		while ({
			(index = indexStream.next(inval)).notNil;
		},{
			inval = list.wrapAt(index.asInteger).embedInStream(inval);
		});
		^inval;
	}
	storeArgs { ^[ list, which ]  }
}

Pswitch1 : Pswitch {
	embedInStream { arg inval;
		var cleanup = EventStreamCleanup.new;
		var index, outval;
		var streamList = list.collect({ arg pattern; pattern.asStream; });
		var indexStream = which.asStream;

		loop {
			if ((index = indexStream.next(inval)).isNil) { ^cleanup.exit(inval) };
			outval = streamList.wrapAt(index.asInteger).next(inval);
			if (outval.isNil) { ^cleanup.exit(inval) };
			cleanup.update(outval);
			inval = outval.yield;
		};
	}
}

Ptuple : ListPattern {
	embedInStream {  arg inval;
		var item, streams, tuple, outval;

		repeats.value(inval).do({ arg j;
			var sawNil = false;
			streams = list.collect({ arg item; item.asStream });

			while ({
				tuple = Array.new(streams.size);
				streams.do({ arg stream;
					outval = stream.next(inval);
					if (outval.isNil, { sawNil = true; });
					tuple.add(outval);
				});
				sawNil.not
			},{
				inval = yield(tuple);
			});
		});
		^inval;
	}
}

Place : Pseq {
	embedInStream {  arg inval;
		var item;
		var offsetValue = offset.value(inval);

		if (inval.eventAt('reverse') == true, {
			repeats.value(inval).do({ arg j;
				list.size.reverseDo({ arg i;
					item = list.wrapAt(i + offsetValue);
					if (item.isSequenceableCollection, {
						item = item.wrapAt(j);
					});
					inval = item.embedInStream(inval);
				});
			});
		},{
			repeats.value(inval).do({ arg j;
				list.size.do({ arg i;
					item = list.wrapAt(i + offsetValue);
					if (item.isSequenceableCollection, {
						item = item.wrapAt(j);
					});
					inval = item.embedInStream(inval);
				});
			});
		});
		^inval;
	}
}

// similar to Place, but the list is an array of Patterns or Streams
Ppatlace : Pseq {
	embedInStream { |inval|
		var	consecutiveNils = 0, index, repeat, item;
		var streamList = list.collect({ |item| item.asStream });
		var offsetValue = offset.value(inval);
		var localRepeats = repeats.value(inval);

		index = repeat = 0;
		while { (repeat < localRepeats) and: { consecutiveNils < list.size } } {
			if(inval.eventAt(\reverse) == true) {
				item = streamList.wrapAt(offsetValue - index - 1);
			} {
				item = streamList.wrapAt(offsetValue + index);
			};
			if((item = item.next(inval)).notNil) {
				consecutiveNils = 0;
				inval = item.embedInStream(inval);
			} {
				consecutiveNils = consecutiveNils + 1;
			};
			if((index = index + 1) == list.size) {
				index = 0;
				repeat = repeat + 1;
			};
		};
		^inval;
	}
}

Pslide : ListPattern {
	// 'repeats' is the number of segments.
	// 'len' is the length of each segment.
	// 'step' is how far to step the start of each segment from previous.
	// 'start' is what index to start at.
	// indexing wraps around if goes past beginning or end.
	// step can be negative.

	var <>len, <>step, <>start, <>wrapAtEnd;
	*new { arg list, repeats = 1, len = 3, step = 1, start = 0, wrapAtEnd = true;
		^super.new(list, repeats).len_(len).step_(step).start_(start)
			.wrapAtEnd_(wrapAtEnd);
	}
	embedInStream { arg inval;
		var item;
		var pos = start;
		var stepStr = step.asStream, stepVal;
		var lengthStr = len.asStream, lengthVal;

		repeats.value(inval).do {
			lengthVal = lengthStr.next(inval);
				if(lengthVal.isNil) { ^inval };
			if(wrapAtEnd) {
				lengthVal.do { |j|
					item = list.wrapAt(pos + j);
					inval = item.embedInStream(inval);
				}

			} {
				lengthVal.do { |j|
					item = list.at(pos + j);
					if(item.notNil) {
						inval = item.embedInStream(inval);
					} {
						^inval
					};
				}
			};
			stepVal = stepStr.next(inval);
			if(stepVal.isNil) { ^inval };
			pos = pos + stepVal;
		};

		^inval;
	}
}



## Pwalk ##
http://doc.sccode.org/Classes/Pwalk.html


Pwalk : ListPattern {
		// random walk pattern - hjh - jamshark70@gmail.com

	var	<>startPos,	// starting index
		<>stepPattern,	// pattern for steps
		<>directionPattern;	// pattern should return a stream of:
							// 1 to move in direction of stepPattern
							// -1 to reverse the direction of stepPattern
							// a new direction will be chosen when the walker
							// reaches a boundary

	*new { arg list, stepPattern, directionPattern = 1, startPos = 0;
		^super.new(list).startPos_(startPos)
			.stepPattern_(stepPattern ?? { Prand([-1, 1], inf) })
			.directionPattern_(directionPattern ? 1);
	}

	storeArgs { ^[list, stepPattern, directionPattern, startPos] }


	embedInStream { arg inval;
		var	step;
		var index = startPos.value(inval);
		var stepStream = stepPattern.asStream;
		var directionStream = directionPattern.asStream;
		// 1 = use steps as is; -1 = reverse direction
		var direction = directionStream.next(inval) ? 1;		// start with first value

		while({
			// get step, stop when nil
			(step = stepStream.next(inval)).notNil
		},{
			inval = list[index].embedInStream(inval);  // get value/stream out
			step = step * direction;	// apply direction
				// if next thing will be out of bounds
			if(((index + step) < 0) or: { (index + step) >= list.size }, {
				direction = directionStream.next(inval) ? 1;  // next direction, or 1
				step = step.abs * direction.sign;  // apply to this step
			});
			index = (index + step) % list.size;
		});

		^inval;
	}
}

(
var a, x;
a = Pfunc({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, { \reset.postln });
x = a.asStream;
x.nextN(20).postln;
x.reset;
)

// b = Pfunc({100.rand}).asStream.collect{|arrayme| arrayme.asArray};
// b.postln;
b.nextN(10).postln;


// here  I would love to maka a list or array or whataver usinfg a pattern syntax like:
a = Pseries(0,1,5).asArray; //  it returns me 5 Pseries .. I would like an array of five elements int..
a =  Pseries(1,1,5).asStream.all;//.debug("Pseries 5 elements")
a.debug("a");

// instead of
 a = Array.series(5,0,1);

(
var a,b ;
b =  Pseries(1,1,5).asStream.all;//.debug("Pseries 5 elements")
// a = Array.series(5,0,1);


Pwalk(list:b,
	stepPattern:1,
	directionPattern: Pseq([1, -1], inf), // go forward first, then backward, then forward again.
	startPos: 0).trace.reset.play;
)


(
~walkMe= Pwalk(list:Pseries(61,1,5).asStream.all.midicps,
	stepPattern:1,
	directionPattern: Pseq([1, -1], inf), // go forward first, then backward, then forward again.
	startPos: 0);

~walkMe2 = Pwalk(list:Pwhite(73,84,11).asStream.all.midicps,
	stepPattern:1,
	directionPattern: Pseq([1, -1], inf), // go forward first, then backward, then forward again.
	startPos: 0);

Pdef(\walk, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,~walkMe,\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;

Pdef(\walk2, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,~walkMe2,\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;
)

(
Pdef(\walk).reset.play;
Pdef(\walk2).reset.play;
)

(
Pdef(\walk).reset.stop;
Pdef(\walk2).reset.stop;
)


## Ppar ##
http://doc.sccode.org/Classes/Ppar.html
 Ppar
  [
    Pgpar
      [ Pgtpar ]
    Ptpar
  ]






## Pseq ##
http://doc.sccode.org/Classes/Pseq.html

Pseq : ListPattern {
	var <>offset;
	*new { arg list, repeats=1, offset=0;
		^super.new(list, repeats).offset_(offset)
	}
	embedInStream {  arg inval;
		var item, offsetValue;
		offsetValue = offset.value(inval);
		if (inval.eventAt('reverse') == true, {
			repeats.value(inval).do({ arg j;
				list.size.reverseDo({ arg i;
					item = list.wrapAt(i + offsetValue);
					inval = item.embedInStream(inval);
				});
			});
		},{
			repeats.value(inval).do({ arg j;
				list.size.do({ arg i;
					item = list.wrapAt(i + offsetValue);
					inval = item.embedInStream(inval);
				});
			});
		});
		^inval;
	}
	storeArgs { ^[ list, repeats, offset ] }
}

Pseq([1, 2]).trace.play;
(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset:0);    // repeat twice
b = a.asStream;
13.do({ b.next.postln; });
)


(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset:5.rand);    // random offset
b = a.asStream;
13.do({ b.next.postln; });
)


(
var a, b;
a = Pseq(list:(0..5),repeats: 2,offset: rrand(1, 3)   );    // random offset
b = a.asStream;
13.do({ b.next.postln; });
)


(
var a, b;
a = Pseq(list:(0..5),repeats: 1,offset:(0..5));    // kind of rotate
b = a.asStream;
6.do({ b.next.postln; });
)

6.do({|i|(0..5).rotate(6-i).postln});

(
var a, d;
a = Pseq(#[60, 61, 63, 65, 67, 63], inf ).asStream.midicps;
d = 0.3;
Task({
    12.do({
        Synth(\help_SPE3_SimpleSine, [ \freq, a.next, \sustain, d ]);
        d.wait;
    });
}).play
)



(
var a;
a = Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67, 63].midicps, inf ),\sustain,0.3,\dur,1/8 ).play;
a.clear.stop;
)
// [60, 61, 63, 65, 67, 63].midicps*(1.0.rand+0.5)

(
Pdef(\player, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67, 63].midicps, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;
Pdef(\player2, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67, 63].midicps*0.75, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/2!32),1),
		Pseq((1/6!96),1),
		Pseq((1/4!64),1)],inf)
)).play;
)

(
Pdef(\player).reset.play;
Pdef(\player2).reset.play;
)

(
Pdef(\player).reset.stop;
Pdef(\player2).reset.stop;
)




## Pser ##
the repeats variable gives the number of items returned


(
var a, b;
a = Pser(list:(0..5),repeats: 12,offset:0);
b = a.asStream;
12.do({ b.next.postln; });
)

## Prand & Pxrand ##
Pxrand, like Prand, returns one item from the list at random for each repeat, but Pxrand never repeats the same element twice in a row.

(
var a, b;
a = Prand((0..5),repeats:2); // return 2 items
b = a.asStream;
3.do({ b.next.postln; });
)

(
Pdef(\player, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Prand([60, 61, 63, 65].midicps, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;
Pdef(\player2, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67,63].midicps*0.5, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/2!32),1),
		Pseq((1/6!96),1),
		Pseq((1/4!64),1)],inf)
)).play;
)

(
Pdef(\player).reset.play;
Pdef(\player2).reset.play;
)

(
Pdef(\player).reset.stop;
Pdef(\player2).reset.stop;
)


(
var a, b;
a = Pxrand((0..5),repeats:2); // return 2 items
b = a.asStream;
3.do({ b.next.postln; });
)


(
Pdef(\player, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pxrand([60, 61, 63, 65].midicps, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;
Pdef(\player2, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67,63 ].midicps*0.5, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/2!32),1),
		Pseq((1/6!96),1),
		Pseq((1/4!64),1)],inf)
)).play;
)

(
Pdef(\player).reset.play;
Pdef(\player2).reset.play;
)

(
Pdef(\player).reset.stop;
Pdef(\player2).reset.stop;
)


(
var a, b;
a = Pshuf((0..5),repeats:2);
b = a.asStream;
13.do({ b.next.postln; }); // return 12 items + nil
)



(
Pdef(\player, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pshuf([60, 61, 63, 65].midicps, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/4!64),1),
		Pseq((1/6!96),1),
		Pseq((1/8!128),1)],inf)
)
).play;
/*Pdef(\player2, Pbind(\instrument,\help_SPE3_SimpleSine,\freq,Pseq([60, 61, 63, 65, 67,63 ].midicps*1.5, inf ),\sustain,0.3,
	\dur,Pxrand([
		Pseq([Rest(4)],1),
		Pseq((1/2!32),1),
		Pseq((1/6!96),1),
		Pseq((1/4!64),1)],inf)
)).play;*/
)

(
Pdef(\player).reset.play;
Pdef(\player2).reset.play;
)

(
Pdef(\player).reset.stop;
Pdef(\player2).reset.stop;
)

## Nesting Patterns is possible ##

(
var a, b;

a = Pxrand([

	Pseq((0..5).reverse,1),
	Pseq((100..105),1),
	Pshuf((1000..1005),1)

],3);
b = a.asStream;
19.do({ b.next.postln; });
)

## Exploring randomness ##
RandomDistPatterns.sc

Plprand : Pwhite {
	embedInStream { |inval|
		var	localLength = length.value(inval),
			pat = Pwhite(lo, hi, localLength);
		^min(pat, pat).embedInStream(inval)
	}
}

Phprand : Pwhite {
	embedInStream { |inval|
		var	localLength = length.value(inval),
			pat = Pwhite(lo, hi, localLength);
		^max(pat, pat).embedInStream(inval)
	}
}

Pmeanrand : Pwhite {
	embedInStream { |inval|
		var	localLength = length.value(inval),
			pat = Pwhite(lo, hi, localLength);
		^((pat + pat) * 0.5).embedInStream(inval)
	}
}

Pbeta : Pattern {
	var <>lo, <>hi, <>prob1, <>prob2, <>length;

	*new{ arg lo = 0.0, hi = 1.0, prob1 = 1, prob2 = 1, length = inf;
		^super.newCopyArgs(lo, hi, prob1, prob2, length);
	}

	storeArgs { ^[lo, hi, prob1, prob2, length] }

	embedInStream { arg inval;
		var loStr = lo.asStream;
		var hiStr = hi.asStream;
		var prob1Str = prob1.asStream;
		var prob2Str = prob2.asStream;
		var loVal, hiVal;

		length.value(inval).do({
			var sum = 2, temp, rprob1, rprob2;
			rprob1 = prob1Str.next(inval);
			rprob2 = prob2Str.next(inval);
			if(rprob1.isNil or: { rprob2.isNil }) { ^inval };
			rprob1 = rprob1.reciprocal;
			rprob2 = rprob2.reciprocal;
			loVal = loStr.next(inval);
			hiVal = hiStr.next(inval);
			if(loVal.isNil or: { hiVal.isNil }) { ^inval };

			while ({
				temp = 1.0.rand ** rprob1;
				sum = temp + (1.0.rand ** rprob2);
				sum > 1;
			});
			inval = (((temp/sum) * (hiVal - loVal)) + loVal).yield;
		});
		^inval;
	}
}

Pcauchy : Pattern {
	var <>mean, <>spread, <>length;

	*new{arg mean = 0.0, spread = 1.0, length = inf;
		^super.newCopyArgs(mean, spread, length);
	}

	storeArgs{ ^[mean, spread, length] }

	embedInStream { arg inval;
		var meanStr = mean.asStream;
		var spreadStr = spread.asStream;
		var meanVal, spreadVal;
		length.value(inval).do({
			var ran = 0.5;
			meanVal = meanStr.next(inval);
			spreadVal = spreadStr.next(inval);
			if(meanVal.isNil or: { spreadVal.isNil }) { ^inval };
			while({
				ran = 1.0.rand;
				ran == 0.5
			});
			inval = ((spreadVal * (ran * pi).tan) + meanVal).yield;
		});
		^inval;
	}
}

Pgauss : Pattern {
	var <>mean, <>dev, <>length;

	*new{ arg mean = 0.0, dev = 1, length = inf;
		^super.newCopyArgs(mean, dev, length);
	}

	storeArgs{ ^[mean, dev, length] }

	embedInStream{arg inval;
		var meanStr = mean.asStream;
		var devStr = dev.asStream;
		var devVal, meanVal;
		length.value(inval).do({
			devVal = devStr.next(inval);
			meanVal = meanStr.next(inval);
			if(meanVal.isNil or: { devVal.isNil }) { ^inval };
			inval = ((((-2*log(1.0.rand)).sqrt * sin(2pi.rand)) * devVal) + meanVal).yield;
		});
		^inval;
	}
}


Ppoisson : Pattern {
	var <>mean, <>length;
	*new{arg mean = 1, length = inf;
		^super.newCopyArgs(mean, length);
		}
	storeArgs{ ^[mean, length] }
	embedInStream{ arg inval;
		var meanStr = mean.asStream;
		length.value(inval).do({
			var inc, test, temp, meanVal = meanStr.next(inval);
			if(meanVal.isNil) { ^inval };
			inc = 0;
			test = 1.0.rand;
			temp = exp(meanVal.neg);
			while({
				test > temp;
				}, {
				inc = inc + 1;
				test = test * 1.0.rand;
			});
			inval = inc.yield;
		});
		^inval;
	}
}

Pexprand : Pwhite {
	*new { arg lo=0.0001, hi=1.0, length=inf;
		^super.newCopyArgs(lo, hi, length)
	}
	storeArgs { ^[ lo, hi, length ] }
	embedInStream { arg inval;
		var loStr = lo.asStream;
		var hiStr = hi.asStream;
		var hiVal, loVal;
		length.value(inval).do({
			hiVal = hiStr.next(inval);
			loVal = loStr.next(inval);
			if(hiVal.isNil or: { loVal.isNil }) { ^inval };
			inval = exprand(loVal, hiVal).yield;
		});
		^inval;
	}
}

Math on pattern is  posible..
https://doc.sccode.org/Overviews/Operators.html#Binary%2520Operators

Arithmetic
+ Addition.
- Subtraction.
* Multiplication.
/ Division.
% Floating point modulo.
pow Exponentiation.
lcm Least common multiple.
gcd Greatest common divisor.

(
var a;
a = Pseq([60], 6) + Pseq([0, 0, -12], 2);
b = a.asStream;
7.do({ b.next.postln; });
)



(

Pswitch1 is divìfferent from Pswitch because:  it embeds only one of its values for each index and not the entire pattern.

var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], inf);
c = Pswitch1([a, b, 800], Pseq([2, 2, 0, 1], inf));
x = c.asStream;
24.do({ x.next.postln; });
)


(
var a, b;
a = Pseq([1, 2, 3], 2);
b = Pseq([65, 76]);
c = Pswitch(list:[a, b, 800],which: Pseq([2, 2, 0, 1], inf));
x = c.asStream;
24.do({ x.next.postln; });
)

(
// choose which pattern using indexes
var a, b;
a = Pseq([1, 2, 3], 2);
b = Pseq([65, 76]);
c = Pswitch(list:[a, b, 800],which: Pseq([0,1,2],1));
x = c.asStream;
10.do({ x.next.postln; });
)

## Pslide ##


Pslide : ListPattern {
	// 'repeats' is the number of segments.
	// 'len' is the length of each segment.
	// 'step' is how far to step the start of each segment from previous.
	// 'start' is what index to start at.
	// indexing wraps around if goes past beginning or end.
	// step can be negative.

	var <>len, <>step, <>start, <>wrapAtEnd;
	*new { arg list, repeats = 1, len = 3, step = 1, start = 0, wrapAtEnd = true;
		^super.new(list, repeats).len_(len).step_(step).start_(start)
			.wrapAtEnd_(wrapAtEnd);
	}
	embedInStream { arg inval;
		var item;
		var pos = start;
		var stepStr = step.asStream, stepVal;
		var lengthStr = len.asStream, lengthVal;

		repeats.value(inval).do {
			lengthVal = lengthStr.next(inval);
				if(lengthVal.isNil) { ^inval };
			if(wrapAtEnd) {
				lengthVal.do { |j|
					item = list.wrapAt(pos + j);
					inval = item.embedInStream(inval);
				}

			} {
				lengthVal.do { |j|
					item = list.at(pos + j);
					if(item.notNil) {
						inval = item.embedInStream(inval);
					} {
						^inval
					};
				}
			};
			stepVal = stepStr.next(inval);
			if(stepVal.isNil) { ^inval };
			pos = pos + stepVal;
		};

		^inval;
	}
}

(
var a, b;
a = Pslide([1, 2, 3, 4, 5], inf, len: 2, step: 3, start: 0, wrapAtEnd: true);
x = a.asStream;
23.do({ x.next.postln; });
)


http://doc.sccode.org/Tutorials/Streams-Patterns-Events4.html
## Streams and Patterns to generate complex sequences of values for a single parameter at a time.
Environments and Events, to control all aspects of a composition using patterns.
##
http://doc.sccode.org/Classes/Environment.html
http://doc.sccode.org/Classes/IdentityDictionary.html


~myvariable = 888; //
currentEnvironment.at(\myvariable).postln;
~myvariable.postln;

//////////////////////////////////////////
Biblio

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


Pclutch(Pseq([1, 2, 3, 4, 5], 3), Pseq([0, 0, 1, 0, 0, 0, 1, 1])).asStream.nextN(10);

http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.html

// Study well these  Primary Patterns
// here it's clearer

https://help.sccode.org/Streams-Patterns-Events/A%20Practical%20Guide/PG_02_Basic_Vocabulary.html


Pseq(list, repeats, offset)
Play through the entire list repeats times. Like list.do.
Prand(list, repeats)
Choose items from the list randomly (same as list.choose).
Pxrand(list, repeats)
Choose randomly, but never repeat the same item twice in immediate succession.
Pshuf(list, repeats)
Shuffle the list in random order, and use the same random order repeats times. Like list.scramble.
Pwrand(list, weights, repeats)
Choose randomly, according to weighted probabilities (same as list.wchoose(weights)).
Pseries(start, step, length)
Arithmetic series (addition).
Pgeom(start, grow, length)
Geometric series (multiplication).
Pwhite(lo, hi, length)
Random numbers, equal distribution ("white noise"). Like rrand(lo, hi) .
Pexprand(lo, hi, length)
Random numbers, exponential distribution. Like exprand(lo, hi) .
Pbrown(lo, hi, step, length)
Brownian motion, arithmetic scale (addition).
Pfunc(nextFunc, resetFunc)
Get the stream values from a user-supplied function.
Pfuncn(func, repeats)
Get values from the function, but stop after repeats items.
Prout(routineFunc)
Use the function like a routine. The function should return values using .yield or .embedInStream.

Pslide(list, repeats, len, step, start, wrapAtEnd)
Play overlapping segments from the list.

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all;

// or, to show the segments as separate arrays
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).clump(3).asStream.all;

// Flock of Seagulls!
(
p = Pbind(
    \degree, Pslide((-6, -4 .. 12), inf, 3, 1, 0),
    \dur, Pseq(#[0.1, 0.1, 0.2], inf),
    \sustain, 0.15
).play;
)
p.stop;

//ddwPAtterns

Quarks.gui
(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)
/*fromEndpoints, for both Pseries and Pgeom that performs this calculation.*/

p = Pgeom.fromEndpoints(0.5, 0.1, 15);    // error if ddwPatterns not installed
p.postcs;

(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
	\dur, Pgeom.fromEndpoints(1/8, 1/64, 22).trace
).play;
)

// how to make accelerandi using a beats?
// in 1 bar make 70 notes starting from 1/8 to whatever it
// will be to rich the note

// There are a bunch of random Patterns that have to be explored
https://doc.sccode.org/Guides/Randomness.html

(
Pbind(\note, Prand([ 0, 2, 4 ], inf),
    \dur, 0.2
).play;
)
​
(
Pbind(
    \note, Pxrand([ 0, 2, 4 ], inf),
    \dur, 0.2
).play;
)
​
(
Pbind(
    \note, Pwrand([ 0, 2, 4 ], [0.1, 0.3, 0.6], inf),
    \dur, 0.2
).play;
)
​
(
Pbind(
    \midinote, Pwhite(48, 72, inf),
    \dur, 0.2
).play;
)
​
(
Pbind(
    \midinote, Pbrown(48, 72, 5, inf),
    \dur, 0.2
).play;
)
​
(
Pbind(
    \midinote, Pgbrown(48, 72, 0.5, inf).round,
    \dur, 0.2
).play;
)


(

SynthDef(\trig_demo, { |freq, gate = 1, t_trig = 1|	// t_trig here

	var	env = Decay2.kr(t_trig, 0.01, 0.1),

		sig = SinOsc.ar(freq, 0, env)

			* Linen.kr(gate, 0.01, 0.1, 0.1, doneAction: 2);

	Out.ar(0, sig ! 2)

}).add;

)



(

p = Pmono(\trig_demo,

	\freq, Pexprand(200, 800, inf),

	\trig, 1,	// note that this is NOT t_trig -- just \trig

	\delta, Pn(Pexprand(1/2, 1/16, 20))

).play;
:
)


