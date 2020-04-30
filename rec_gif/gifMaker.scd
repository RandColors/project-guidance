
~lightsAddr = NetAddr("127.0.0.1", 12321);

/*
osc.plug(this, %22startrec%22, %22/startrec%22);
osc.plug(this, %22stoprec%22, %22/stoprec%22);
*/

(
r =Routine({
~lightsAddr.sendMsg('/startrec',"startrec");


 Pbindef(\firstlastRand,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
	\bus,Pseq([0,5,(1..4).choose],inf)+ ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[Env.perc(0.001,0.999,1,4)]
    ],inf),
	\dur, Pseq((1/16!4)++(1/8!2)++(1/4!1),inf),//added some .rand
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);


	((3/4)*2).wait;

~lightsAddr.sendMsg('/stoprec',"stoprec");
Pbindef(\firstlastRand).stop;

//Pbindef(\firstlastRand).clear;
})
)

r.play;


(
r =Routine({

~lightsAddr.sendMsg('/startrec',"startrec".postln);
//------------------------------------

Pbindef(\ph0,
    \instrument, \DcOuts,
    	\stretch,4,
    \bus,Pseq([0,5,1,4,2,3],1) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    [Env.perc(0.999,0.001,1,-2)]
    ],inf),
    	\dur, Pseq((1/2!2)++(1/4!5),inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base);


	(9.01).wait;
//------------------------------------
~lightsAddr.sendMsg('/stoprec',"stoprec".postln);

Pbindef(\ph0).stop.clear;

}).play(~metro.base ,quant:~metro.base.beatsPerBar);
)
(1/2!2)++(1/4!5)
[ 0.5, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25 ]
1/8
0.5*2

( // an interactive session
e.stop
e.play(~metro.base ,quant:~metro.base.beatsPerBar);
e.reset

~lightsAddr.sendMsg("/startrec","startrec".postln)
~lightsAddr.sendMsg("/stoprec", "stoprec".postln)

~recgif
~metro.base.tempo

~grillini2 = {arg amp;
d = Routine{
	Pbindef(\grillini).stop;

	Pbindef(\grillini,
	\out, 38,
	\bufnum, ~noise,
	\amp,amp,
	\freq, 115.midicps ,
	\rq, 2,
	\sustain, 0.0001,
		\dur, Pstutter(17, Pfunc({ exprand(0.005, 0.03)}))).play(~metroBase,quant:[0,0]);
(~metro[6].tempo).wait; // durata della frase
Pbindef(\grillini).stop;
	};

~metroBase.play(d,quant:[0,0]);};  