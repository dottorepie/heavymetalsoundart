

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;
////sesor ased randomnes
//SerialPort.devices;
//~port = SerialPort.new("/dev/cu.usbserial-210",9600)

/*(
~charArray = [];
~getValues = Routine.new({

	var ascii;
	{ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
			~charArray =[];
		});
	}.loop;

}).play;
);*/

		///vbap

		///octahedron
		(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

(
~a = VBAPSpeakerArray.new(3,
[[~az.[0],~el.[0]], [~az.[1],~el.[1]], [~az.[2],~el.[2]], [~az.[3],~el.[3]],[~az.[4],~el.[4]],[~az.[5],~el.[5]]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);


///animation buses
		~controlBus_1a = Bus.control(s, 1);
		~controlBus_2a = Bus.control(s, 1);
		~controlBus_3a = Bus.control(s, 1);

	//	~controlBus_1b = Bus.control(s, 1);
	//	~controlBus_2b = Bus.control(s, 1);
	//	~controlBus_3b = Bus.control(s, 1);

	//	~controlBus_1c = Bus.control(s, 1);
	//	~controlBus_2c = Bus.control(s, 1);
		//~controlBus_3c = Bus.control(s, 1);

	//	~controlBus_1d = Bus.control(s, 1);
	//	~controlBus_2d = Bus.control(s, 1);
	//	~controlBus_3d = Bus.control(s, 1);

	//	~controlBus_1e = Bus.control(s, 1);
	//	~controlBus_2e = Bus.control(s, 1);
	//	~controlBus_3e = Bus.control(s, 1);

	//	~controlBus_1f = Bus.control(s, 1);
	//	~controlBus_2f = Bus.control(s, 1);
	//	~controlBus_3f = Bus.control(s, 1);

	//	~controlBus_1g = Bus.control(s, 1);
	//	~controlBus_2g = Bus.control(s, 1);
	//	~controlBus_3g = Bus.control(s, 1);

	//	~controlBus_1k = Bus.control(s, 1);
	//	~controlBus_2k = Bus.control(s, 1);
	//	~controlBus_3k = Bus.control(s, 1);

		~controlBus_x = Bus.control(s, 1);
		~controlBus_y = Bus.control(s, 1);
		~controlBus_z = Bus.control(s, 1);

////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(pi/496)); ~ph=992.collect{~n=~n+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);


		/////distortion table
		(
		~transfer_function= Env([0.8.neg,0,0.8],[1,1],[8,8.neg]).asSignal(1024);
			~transfer_function=~transfer_function+(Signal.sineFill(~signalSize,~array,~ph)/8);
		~transfer_function=~transfer_function.normalize;
		//	~transfer_function.plot;
			~dist=Buffer.loadCollection(s,~transfer_function.asWavetableNoWrap);
		);

		////sound


		//////kick

 (
SynthDef(\kick, {
	arg gain=1/8,tone=12,pan=1,low=0,noise=0.001,decay=1/2,attack=0.001,az=0,azr=0,el=0,m=1,rz=100,
			fu=32,mix=1,room=1,drive=1,panx=1,pany=1,panz=1,spread=1;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,phase1,phase2,phase3,sph1,loc1,loc2,loc3,mag,fund,freqq;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3,axis1,axis2,axis3,lfo;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,az1,az2,az3,el1,el2,el3,cx,cy,cz,tensor;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,spx,spy,spz,axis;
	var  axisx1=1,axisy1=1,axisz1=1,axisx2=1,axisy2=1,axisz2=1,axisx3=1,axisy3=1,axisz3=1,v1,v2,cross;


			ton=2.pow(tone/992);
					fund=fu*(9/8);
	freqq = fund*ton;
					lfo=2.pow(pan/992);

				spx=Spherical(1,az,el);spy=Spherical(1,azr,el);

				v1=[spx.x,spx.y,spx.z]; v2=[spy.x,spy.y,spy.z];

cross = [
    v1[1]*v2[2] - v1[2]*v2[1],
    v1[2]*v2[0] - v1[0]*v2[2],
    v1[0]*v2[1] - v1[1]*v2[0]
];
				spz=Cartesian(cross.[0],cross.[1],cross.[2]);

				axisx=[spx.x,spx.y,spx.z];
				axisy=[spy.x,spy.y,spy.z];
				axisz=[spz.x,spz.y,spz.z];

				tensor=axisx+axisy+axisz;

				sph_object=Cartesian(tensor.[0],tensor.[1],tensor.[2]);


				freq = EnvGen.kr(Env([freqq, fund], [decay*2], curve: -8)); // pitch drop
	env= EnvGen.kr(Env.perc(attack, decay, curve: -4),doneAction:2,levelScale:gain*ton.reciprocal);

			threshold=(((343/0.3)/freq).reciprocal.ampdb/2.sqrt).dbamp;


					axis=Spherical(992,sph_object.theta, sph_object.phi);

				sph=Cartesian(axis.x,axis.y,axis.z);


anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;

mod_anglex=SinOsc.ar(lfo,phase1).range(pi.neg,pi);
mod_angley=SinOsc.ar(lfo,phase2).range(pi.neg,pi);
mod_anglez=SinOsc.ar(lfo,phase3).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);

phasex=Complex(1,mx.value).theta;
phasey=Complex(1,my.value).theta;
phasez=Complex(1,mz.value).theta;
									mag=(Cartesian(magx.value,magy.value,magz.value).rho);
									sph1=Spherical(mag,sph.theta,sph.phi);

		//	loc1=sph1.x;  loc2=sph1.y;  loc3=sph1.z;
					loc1=mx;  loc2=my;  loc3=mz;

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:rz).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:rz).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:rz).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;

control1=SinOsc.ar(freq,phasex,ton.reciprocal)*env;
control2=SinOsc.ar(freq,phasey,ton.reciprocal)*env;
control3=SinOsc.ar(freq,phasez,ton.reciprocal)*env;

sig1 = sig1 + (sig1 * BrownNoise.ar(noise*loc1)); sig2 = sig2 + (sig2 * BrownNoise.ar(noise*loc2)); sig3 = sig3 + (sig3 * BrownNoise.ar(noise*loc3));


		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig2, 50);sig3=HPF.ar(sig3, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*drive);sig2=tanh(sig2*drive);sig3=tanh(sig2*drive);


	//amb_sig1= Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01);
	/////amb_sig2=Limiter.ar( LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01);
	//amb_sig3=Limiter.ar( LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01);

			//				amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
				//	amb_x=amb_sig1;
				///	amb_y=amb_sig2;
				////	amb_z=amb_sig3;

				///	out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z, [sph1.theta, sph1.theta], [sph1.phi,sph1.phi],4 ));



//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01),~b,spx.theta.raddeg,spx.phi.raddeg,spread:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01),~b,spy.theta.raddeg,spy.phi.raddeg,spread:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01),~b,spz.theta.raddeg,spz.phi.raddeg,spread:spread));

			// Out.kr(~controlBus_1.index,A2K.kr(sig1*env*loc1.abs*1000));
			//	Out.kr(~controlBus_2.index,A2K.kr(sig2*env*loc2.abs*1000));
			//	Out.kr(~controlBus_3.index,A2K.kr(sig3*env*loc3.abs*1000));

					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1 ),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01));
				///Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01));
					//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01));

			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1 ),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01),SinOsc.ar(panx,phasex),width:spread));
			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01),SinOsc.ar(pany,phasey),width:spread));
			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01),SinOsc.ar(panz,phasez),width:spread));


}).add);

	10.wait;
	/////solid
(

///quaterion rhtyhm solid rotation
/*(var i=Quaternion(0,
axis_xyz.[0], 0, 0),j=Quaternion(0, 0, axis_xyz.[1], 0),k=Quaternion(0, 0, 0, axis_xyz.[2]);

axis=i+j+k;
~x1=tetrahedron.collect{
	plx1=plx1+1;
	qx1=Quaternion(0,Spherical(1,~az1[plx1],~el1[plx1]).x.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).y.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ax=rotor_a*qx1*rotor_a.conjugate;
	ax.b.round(0.00001);
};
)*/

	////durs
	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=6,time=32.reciprocal,beat=1,r=0;

~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[];

					3.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(r).tilt(r).tumble(r).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(r).tilt(r).tumble(r).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(r).tilt(r).tumble(r).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				18.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		18.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
		18.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
);


	(
				//	thisThread.randSeed = ~val;

		~dr=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\gain,0,
				\tone,992*0,
				\pan,992*1,
					\m,1,
			\low,0,
				\noise,0.0001,
\az,pi/4,
	\azr,pi/2,
	\el,pi/2,
				\decay,2,
				\attack,0.001,
					\spread,4,
					\panx,1,
	\pany,1,
	\panz,1,

					\rz,100,
					\mix,0.2,
					\room,0.5;
		))
);


);


	});
	Tdef(\drone).play;
}
)
)



TempoClock.default.tempo_(2);
~dr.play


~dr.play;
~dr.pause





(
				//	thisThread.randSeed = ~val;

		~dr=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\gain,~gian,
				\tone,~tone,
				\pan,~pan,
					\m,~m,
			\low,~low,
				\noise,0.0001,
\az,pi/4,
	\azr,pi/2,
	\el,pi/2,
				\decay,2,
				\attack,0.001,
	\spread,3,
	\panx,1,
	\pany,1,
	\panz,1,

					\rz,200,
					\mix,0.2,
					\room,0.5;
		))
)







/*
/tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/