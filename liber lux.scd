/*(
var win,view,red,green,blue;

~controlBus = Bus.control(s, 1);
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);

    // Create a window
    win = Window("RGB Audio Visualizer", Rect(100, 100, 400, 400));
    view = UserView(win, win.view.bounds);

  red = ~controlBus.getSynchronous;
green = ~controlBus1.getSynchronous;
 blue = ~controlBus2.getSynchronous;

    // Drawing function
    view.drawFunc = {
        Pen.fillColor = Color(red, green, blue);
        Pen.fillRect(view.bounds);
    };

    win.front;

)*/

(
var win,amp1 = 0,amp2 = 0,amp3 = 0;

    win = Window("RGB Audio Visualizer", Rect(100, 100, 400, 400));
~v = UserView(win, Rect(0, 0, 400, 400)).front;
(
a = {
	var amp1 = Amplitude.ar(InFeedback.ar(4,1),mul:100);
	var amp2 = Amplitude.ar(InFeedback.ar(5,1),mul:100);
	var amp3 = Amplitude.ar(InFeedback.ar(6,1),mul:100);
	SendReply.ar(Impulse.ar(25), '/amp1', amp1);
		SendReply.ar(Impulse.ar(25), '/amp2', amp2);
		SendReply.ar(Impulse.ar(25), '/amp3', amp3);
}.play;

OSCdef(\amp, { |msg|
	~amp1 = msg[3];
	defer { ~v.refresh };
}, '/amp1', s.addr);

OSCdef(\amp, { |msg|
	~amp2 = msg[3];
	defer { ~v.refresh };
}, '/amp2', s.addr);

OSCdef(\amp, { |msg|
	~amp3 = msg[3];
	defer { ~v.refresh };
}, '/amp3', s.addr);

).asStream;

~v.drawFunc=({ |view|
	    Pen.fillColor = Color(~amp1, ~amp2, ~amp3);
        Pen.fillRect(view.bounds);
});
    win.front;
)


TempoClock.default.tempo_(120/20);


// edit: forgot loading the buffer
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");





///////////////


TempoClock.default.tempo_(120/20);

(
var w,v;
var run = true;
var partial=2000,radius;
~z=1;
(
SynthDef.new(\id, {
	arg dur=1;
	var x=1,y=1,t;
	var k=0, sig,sig1,env,env1,s;
	var sum=0,sum1=0;
1.do{
		dur=dur+1;
		~z=((dur+1)/~z);
	x=~z.cos.abs; y=~z.sin.abs;
	k=Complex(x,y).abs;
	t=Complex(x,y).angle.abs;
	env=EnvGen.ar(Env.perc(0.01,8,0.05/y,[-4,-2]),doneAction:2);
	env1=EnvGen.ar(Env.perc(0.01,8,0.05/x,[-4,-2]),doneAction:2);

	sig=FSinOsc.ar(x*880,mul:env1,iphase:x*pi);
sig1=FSinOsc.ar(y*881,mul:env,iphase:y*pi);
sum1=sum1+sig1; sum=sum+sig;
	};
		SendReply.ar(Impulse.ar(25), '/z', ~z);
		Out.ar(0,Rotate2.ar(sum*env,sum1*env,LFSaw.ar(t)));

}).add;
);

( Pdef(\1, Pbind(\instrument, \id,
	//\dur,5;
	\dur,Pbrown(1,7,1,inf),
			)).play(quant:1));

OSCdef(\amp, { |msg|
	~z = msg[3];
	defer { ~v.refresh };
}, '/z', s.addr);

    Window.closeAll;
    w = Window("S",Rect( 600,100,2000,1000),scroll:false).front.alwaysOnTop_(true);
    w.alpha = 1;  w.view.background = Color.black;
	//~slider1= Slider(w,Rect(500,940,850,10)).action_({ arg obj; ~z = obj.value.linlin(0,1,1,3600); ~v.refresh;});
~v = UserView.new(w,Rect(50,100,1800,800)).background_(Color.black);
~v.drawFunc ={
	~z=~z*50;~v.refresh;
	Pen.translate(900,400);
	(partial).do{
	~x=~z.cos; ~y=~z.sin;
			~k=Polar.new(~z,~x*pi).asPoint;~v.refresh;
		~a=Polar.new(~z,~y*pi).asPoint;~v.refresh;
			Pen.width=0.1;
		Color(red:1,green:1,blue:1,alpha:1).set;
		Pen.line(~k,~a);Pen.stroke;~v.refresh;
	//	Pen.line(~a,Polar.new(~z,~y).asPoint);Pen.stroke;~v.refresh;
		Pen.rotate(pi/(partial/2));Pen.stroke;~v.refresh;
			};
};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/10).wait } }.fork(AppClock);
//~v.background_(Color.black);~v.refresh;
)