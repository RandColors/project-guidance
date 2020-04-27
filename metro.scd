/*

Init a global metro object

~metro.base:   base metronomes
~metro.nomes:  other metronomes
~metro.setBpm: update all clocks' tempo (and/or beatsPerBar)
~metro.print:  print info about metronomes

clicks:
~metro.stopClicks: stop all active clicks
~metro.playClick(metro_n, amp, note)
~metro.stopClick(metro_n)

*/


/*
TO DO, maybe not everything.. but .

Apply advanced rhythmic stuffs
Tuplets (triplets, quintuplets, septuplets)
Changing time signature within a piece:
Moving from simple to compound (e.g. 2/4 to 6/8)
Changing number of beats in the bar (e.g. 4/4 to 3/4)
Advanced rhythmic devices, to include polyrhythms, polymeter, polytempo
Tempo curves (speeding up or slowing down)
*/


~metro = ~metro ? ();

~metro.use{

    ~bpm = 120;
    ~beatsPerBar = 4;

    // ratios are integer subdivision of base pulse (gati?)
    ~metroRatios = (2..11);
    //~metroRatios = ~metroRatios ++ ~metroRatios.reciprocal;

    // create metronomes
    ~base = TempoClock.new(~bpm/60).permanent_(true);
    ~nomes = ~metroRatios.collect{|ratio|
        TempoClock(~base.tempo * ratio).permanent_(true)
    };


    // update bpm and/or beatsPerBar for all metronomes
    ~setBpm = {|metro, bpm=nil, beatsPerBar=nil|
        bpm !? {
            metro.base.tempo = bpm/60;
            metro.metroRatios.do{|ratio, n|
                metro.nomes[n].tempo_(metro.base.tempo*ratio)
            }
        };
        beatsPerBar !? {
            (metro.nomes ++ metro.base).do{|metronome|
                metronome.schedAbs(metronome.nextBar){
                    metronome.beatsPerBar = beatsPerBar
                }
            }
        };
    };

    ~print = {|metro|
        ([metro.base] ++ metro.nomes).do{|metronome,n|
            "[Metro #%] %bpm, bar:% (next bar: %)"
            .format(n, metronome.tempo * 60, metronome.beatsPerBar, metronome.nextBar)
            .postln
        }
    };

    // clicks
    // create click pbindefs
    ~clicks = ([~base]++~nomes).collect{|metronome, n|
        Pbindef((\metro++n).asSymbol,
            \instrument, \bleep,
            \root, n,
            \degree, Pseq([12,Pn(0,metronome.beatsPerBar-1)],inf),
            \dur, 1,
            \amp, 0.1,
            \sustain, 0.1,
        ).stop
    };

    ~playClick = {|metro, metro_n = 0, amp = nil, note = nil|
        var metronome = if(metro_n == 0){ metro.base }{ metro.nomes.wrapAt(metro_n - 1) };
        metro_n = metro_n.abs; // sanity
        metro.stopClick(metro_n);
        note !? { metro.clicks[metro_n].source.set(\root, note) };
        amp !? { metro.clicks[metro_n].source.set(\amp, amp) };
        metro.clicks[metro_n].play(metronome, quant: metronome.beatsPerBar);
    };

    ~stopClick = {|metro, metro_n=0|
        metro.clicks[metro_n] !? {
            metro.clicks[metro_n].stop;
        };
    };

    ~stopClicks = {|metro|
        metro.clicks.do(_.stop)
    }

};

~metro.setTempo(~metro.bpm,~metro.beatsPerBar);
