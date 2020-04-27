/*


*/


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



