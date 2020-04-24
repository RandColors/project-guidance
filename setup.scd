(
s.waitForBoot{
    [
        "synthdefs.scd",
        "utils.scd",
        "setup_lights.scd",
        "metro.scd",
    ]
    .do(_.loadRelative);
}
)

// start-stop processing osc responder
OSCdef(\processing).disable // pause
OSCdef(\processing).enable // resume

// set tempo
~metro.setBpm(60)
