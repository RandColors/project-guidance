Quarks.install("https://github.com/smoge/superfomus");

(
a = 12.collect({|i|
  ( 'midinote': (
      (63 + rrand(-6,6.5) + [0,8,13]) ++
      (60 + rrand(-6,6.5) + [0,5,6,9]) ),
    'dur': 1 )
});

f = Fomus();
f.fileName = "C:/Users/ET/Desktop/SCFomus_"; // complete file path
f.add(a);
f.ly;
)


(
{
~a.size.debug("~a.size: ");
	0.1.wait;
~midinotes.size.debug("~midinotes.size: ");
	0.1.wait;
~durs.size.debug("~durs.size: ");
}.fork;
)



(
p = Pbind(
  \midinote, Pseq(~midinotes.pyramid(3), 1),
  \dur, Pseq(~durs.pyramid(3), 1)
);

//p.play;

f = Fomus(p.asStream, 300);
f.fileName = "C:/Users/ET/Desktop/SCFomusPAtternTest"; // complete file path
f.ly;
f.midi;
f.xml;
)