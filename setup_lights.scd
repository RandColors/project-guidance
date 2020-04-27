// reserve a 6 channel bus for lights
~lightsBus =  Bus.control(s,6);
// let's see some waves
~lightsBus.scope;

~lightsAddr = NetAddr("127.0.0.1", 12321);

// reply to Processing's data requests


OSCdef(\processing,{
    var msg = ["/amps"] ++ ~lightsBus.getnSynchronous(6);
    ~lightsAddr.sendMsg(*msg)
}, "/getAmps").permanent_(true);


//
// OSCdef(\processing,{
//
// 	~lightsAddr.sendMsg('/amps', ~lightsBus.getnSynchronous(6).postln );
//
// }, "/getAmps").permanent_(true);
//
//



//
// // UNO
// OSCdef(\getamp1,{
// 	~n1.sendMsg('/amp1',~bus0.getSynchronous.asFloat);
// }, "/getamp1");
// // DUE

/* MAgari con :

getnSynchronous(count)
Get the current values of this control bus. This command is synchronous.

Arguments:
count
The number of channels to read, starting from this bus' first channel.

Returns:
Array of values.*/