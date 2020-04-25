// conversion function
// used to send durations in seconds to synths
// (converting from beats to seconds)
~beatsToSeconds = { ~durSeconds = ~sustain.value / thisThread.clock.tempo };
