(
s.waitForBoot{
    [
        "synthdefs.scd",
        "utils.scd",
        "setup_lights.scd",
        "metro.scd",
    ]
    .do(_.loadRelative);

	s.plotTree;
	s.meter;
}
)

// start-stop processing osc responder
OSCdef(\processing).disable // pause
OSCdef(\processing).enable // resume

// set tempo
~metro.setBpm(120,4);
~metro.playClick;
~metro.stopClick;
~metro.print;

