/* TODO
look at “phrase networks”: save using dictionaries and then use pbind to recall/structure ..
*/

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
~metro.setBpm(60);

s.scope