// Exploring the Envelopes
    (
    ~dEnv = Dictionary.new;
    
    	~dEnv.add(\perc -> Env.perc(0.001,0.999,1,-4));
    	~dEnv.add(\percrev ->  Env.perc(0.999,0.001,1,4));
    )

    // write to a .png on your desktop
    ~aplot = ~dEnv[\percrev].plot(bounds: Rect(left: 0, top: 400, width: 600, height: 400));
    i = Image.fromWindow(~aplot.parent, ~aplot.interactionView.bounds);
    i.write("~/desktop/\percrev.png".standardizePath);
    i.free;
