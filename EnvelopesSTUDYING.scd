/*


*/

(
~dEnv = Dictionary.new;

	~dEnv.add(\perc -> Env.perc(0.001,0.999,1,-4));
	~dEnv.add(\percrev ->  Env.perc(0.999,0.001,1,4));
)

// write to a .png
~aplot = ~dEnv[\percrev].plot(bounds: Rect(left: 0, top: 400, width: 600, height: 400));
i = Image.fromWindow(~aplot.parent, ~aplot.interactionView.bounds);
i.write("~/desktop/\percrev.png".standardizePath);
i.free;


a =(0..5).powerset


// write to a .png
(
~aplot =
[ 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0 ]
.plot(bounds: Rect(left: 0, top: 400, width:800 /*Window.screenBounds.width*/, height:600 /*Window.screenBounds.height*/),discrete: false, separately: false,numChannels:1);
)

i = Image.fromWindow(~aplot.parent, ~aplot.interactionView.bounds);
i.write("~/desktop/mirror2).png".standardizePath);
i.free;

[ 0, 0, 1, 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5 ].size


(
    Pbindef(\forward,
    \instrument, \DcOuts,
    	\stretch,4,
    	\legato,1,
    \bus,Pseq((0..5),inf) + ~lightsBus.index,
    \amp,1,
    \env, Pseq([
    		[~dEnv[\perc]]
    ],inf),
    	\dur, Pseq([1/4],inf),
    \finish, ~beatsToSeconds
    ).play(~metro.base ,quant:~metro.base.beatsPerBar);
    )


    Pbindef(\forward).stop;
    Pbindef(\forward).clear;




	Pbind(\envelope, d[\exp] \dur,0.25).play;

http://www.musicaecodice.it/SC_Env/SC_Env.php
(
~aplot = [
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \step),      // Scalini
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \lin),       // Curva lineare
 Env([0.0001,0.5,0.1,0.0001],[0.1,0.2,1], \exp),     // Curva esponenziale
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \sin),       // Curva sinusoidale
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \wel),       // Curva welch
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \sqr),       // Curva radice
 Env([0,0.5,0.1,0],        [0.1,0.2,1], \cub)].plot; // Curva quartica
)

~aplot = [0,2,3,2,1,0.4].plot;





20.do{|i|Env.perc().plot(i,name:"myplotNum point visualized:"++i,minval: nil, maxval: nil,bounds:800@300)}

http://www.musicaecodice.it/SC_Controllo/SC_Gui/SC_Gui.php#sf
(
w = Window.new("EnvelopeView", 500@400);
e = EnvelopeView.new(w, Rect(10,10,480,380));

~h = Env.new([0,1,0.4,0],[0.2,0.5,1],[3,-2.3,1.5]);
~dur = h.duration; // recupera la durata dell'inviluppo (può servire)
e.setEnv(~h);

w.front;
w.alwaysOnTop_(true);
w.onClose_({e.free;w.free;~h.free;r.stop});
)

(
/*
looking at the plot I can't understand why there are those data displayed? I mean, why there are more than 20 secs displayed and iterations, and the range is so wide?
I see 6 picks so... there is a kind of loop
*/
var baseEnv = { |default| Env((default!6).postln, [1, 0, 0, 0, 0]).asArray };
baseEnv.(20).plot(name:"baseEnv!6.asArray",minval: nil, maxval: nil)
)

(
// is this one the same of the above one?
var baseEnv = { |default| Env(levels:default ,times: [1, 0, 0, 0, 0].asArray ) };
baseEnv.([20,20,20,20,20,20]).plot(name:"baseEnv.[20,20,20,20,20,20]",minval: nil, maxval: nil)
// press"m" to change the way data looks
)

(
// is this one the same of the above one?
var baseEnv = { |default| Env(levels:default ,times: [1, 0, 0, 0, 0].asArray ) };
baseEnv.(20).plot(name:"baseEnv.asArray",minval: nil, maxval: nil)
)


(
// changing times values to me
var baseEnv = { |default| Env(levels:default ,times: [1, 1, 1, 1, 1].asArray) };
baseEnv.([0,20,20,10,20,0]).plot(name:"baseEnv",minval: nil, maxval: nil)
)



