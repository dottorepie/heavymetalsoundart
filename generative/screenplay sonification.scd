
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
s.makeGui(w);
s.meter;
s.freqscope;
s.scope;


s.waitForBoot{

Buffer.freeAll;

(
var img = Image.open("/Users/amimid/Desktop/1.png");
var width = img.width;
var height = img.height;
var color = img.getColor(0, 0).postln; // returns a Color object
width.postln;
height.postln;
//[color.red, color.green, color.blue].postln;
)


(
var img = Image.open("/Users/amimid/Desktop/1.png");
var c=0, color,x=0,y=0,r=[],g=[],b=[],h_count;

		~ax=[]; ~ay=[];  ~az=[];

	5.do{
			h_count=((img.height/5)+c);
h_count.do {
				img.width.do {
         color = img.getColor(x, y);
		[color.red, color.green, color.blue].postln;
				r=r++color.red;
				g=g++color.green;
				b=b++color.blue;
x=x+1;
				};
				x=0;
				y=y+1;
    };
			~ax=~ax++(r.sum / r.size);
				~ay=~ay++(g.sum / g.size);
				~az=~az++(b.sum / b.size);
			c=(img.height/5);
};
)





  r= Routine({loop{

	(1/8).wait;
};

	};

);

r.play;

}
);

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


////scale
		(
			{
				var nn=1.neg;
		~scaleee=28.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
			}.value;
		);

				(
			{
				var nn=1.neg;
		~scalee=14.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
			}.value;
		);

		////sound

(
SynthDef.new(\synth,{

	arg gain=1,low=992,tone1=0,tone2=0,tone3=0,x=1,pan=1,mix=0.3,a=1,panx=1,pany=1,panz=1,room=0.5,m=2,pon=1,
				fu=32,drive=1,spread=1,drone_amp=1,pann=0,dron=0,drone=1,theta=0,rx=0,ry=0,rz=0,
				pneuma1=0,pneuma2=0,pneuma3=0,namp1=1,namp2=1,namp3=1,sc=14;

	var rq=1,cloud=5,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph;
	var loc1,loc2,loc3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor,dr;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,axis;
	var r_axis, r_v, r, axisr,spr,rot,i,j,k,level=100;
	var g_ch1,g_ch2,g_ch3,g_ch4,chan=4,nn=0;
	var gn ,g_sum,g_avg ,ton1,ton2,ton3,laxis,sp,spl,g11,g22,g33,g44,env;

fund=fu*(9/8);
lamdoma=(x.lag(0.0001)+a.lag(0.0001))/x.lag(0.0001);

ton1=2.pow(Select.kr(tone1.lag(0.0001), ~scalee) /12).round(0.0001)*2.pow(dron.lag(0.0001)/992);
ton2=2.pow(Select.kr(tone2.lag(0.0001), ~scalee) /12).round(0.0001)*2.pow(dron.lag(0.0001)/992);
ton3=2.pow(Select.kr(tone3.lag(0.0001), ~scalee) /12).round(0.0001)*2.pow(dron.lag(0.0001)/992);

	env=EnvGen.ar(Env.sine(12),doneAction:2,levelScale:1);

						lfo=2.pow(pan/992);
				lfon=2.pow(pann/992);
					band=pan;

				mq=(m.lag(0.0001)+1);

						cloud.do{

		spr=Cartesian(~ax.[nn],~ay.[nn],~az.[nn]);
				sph_object=spr;



				axis=Spherical(sc,(sph_object.theta+azf).wrap(pi,pi.neg),  (sph_object.phi+elf).wrap((pi/2),(pi/2).neg));
				polytope=Cartesian(axis.x,axis.y,axis.z);

b_x=2.pow(Select.kr(polytope.x, ~scale) /12).round(0.0001)*lamdoma;
b_y=2.pow(Select.kr(polytope.y, ~scale) /12).round(0.0001)*lamdoma;
b_z=2.pow(Select.kr(polytope.z, ~scale) /12).round(0.0001)*lamdoma;

anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;


mod_anglex=SinOsc.ar(lfon*ton1,phase1).range(pi.neg,pi).lag(0.01);
mod_angley=SinOsc.ar(lfon*ton2,phase2).range(pi.neg,pi).lag(0.01);
mod_anglez=SinOsc.ar(lfon*ton3,phase3).range((pi/2).neg,(pi/2)).lag(0.01);


					(
	magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magqx=(((Complex(cos(((polytope.theta+mod_anglex)*mq).wrap(pi.neg,pi)),cos(((polytope.theta+mod_anglex)*mq).round(0.00001).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt);



 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));
	);

					mx=(Cartesian(magx,0,0).rho);
					my=(Cartesian(0,magy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
					mag=(Cartesian(mx,my,mz).rho/2.sqrt) ;

		sph=Spherical(mag,polytope.theta,polytope.phi);

loc1=mx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta;
phasey=Complex(1,sph.y).theta;
phasez=Complex(1,sph.z).theta;


freq1=(fund*ton1)*b_x.lag(0.0001);
freq2=(fund*ton2)*b_y.lag(0.0001);
freq3=(fund*ton3)*b_z.lag(0.0001);

					dr=2.pow(drone.lag(0.1)/12)*2.pow(dron.lag(0.0001)/992);

f1=(fund)*b_x.lag(0.0001)*dr;
f2=(fund)*b_y.lag(0.0001)*dr;
f3=(fund)*b_z.lag(0.0001)*dr;

amp1=ton1.reciprocal*b_x.reciprocal;
amp2=ton2.reciprocal*b_y.reciprocal;
amp3=ton3.reciprocal*b_z.reciprocal;

g1=b_x.reciprocal*dr.reciprocal*drone_amp.reciprocal*panx;
g2=b_y.reciprocal*dr.reciprocal*drone_amp.reciprocal*pany;
g3=b_z.reciprocal*dr.reciprocal*drone_amp.reciprocal*panz;

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.0001)/992),phase:phasez.neg,mul:rq).exprange(0.1,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);

ds1=(LPF.ar((Osc.ar(~w1.bufnum,f1+1,phase:phasex,mul:level).abs*SinOsc.ar(f1+1,phase:phasex)),f1*2.pow(low.lag(0.0001)/992),g1)+
	LPF.ar((Osc.ar(~w1.bufnum,f1+1,phase:phasex+(pi/2),mul:level).abs*SinOsc.ar(f1+1,phase:phasex+(pi/2))),f1*2.pow(low.lag(0.0001)/992),g1)
					);
ds2=(LPF.ar((Osc.ar(~w1.bufnum,f2+1,phase:phasey,mul:level).abs*SinOsc.ar(f2+1,phase:phasey)),f2*2.pow(low.lag(0.0001)/992),g2)+
	LPF.ar((Osc.ar(~w1.bufnum,f2+1,phase:phasey+(pi/2),mul:level).abs*SinOsc.ar(f2+1,phase:phasey+(pi/2))),f2*2.pow(low.lag(0.0001)/992),g2)
					);
ds3=(LPF.ar((Osc.ar(~w1.bufnum,f3+1,phase:phasez,mul:level).abs*SinOsc.ar(f3+1,phase:phasez)),f3*2.pow(low.lag(0.0001)/992),g3)+
	LPF.ar((Osc.ar(~w1.bufnum,f3+1,phase:phasez+(pi/2),mul:level).abs*SinOsc.ar(f3+1,phase:phasez+(pi/2))),f3*2.pow(low.lag(0.0001)/992),g3)
					);

					sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.0001)/992),amp1)+(ds1/2));
					sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.0001)/992),amp2)+(ds2/2));
				sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.0001)/992),amp3)+(ds3/2));

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

threshold1=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig3=HPF.ar(sig3, 50);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///distortion


					sig1 = (tanh((sig1*2.pow(drive/992)).softclip)) / (1 + (tanh((sig1*2.pow(drive/992)).softclip)).abs);

		sig2 =  (tanh((sig2*2.pow(drive/992)).softclip)) / (1 + (tanh((sig2*2.pow(drive/992)).softclip)).abs);

	sig3 =  (tanh((sig3*2.pow(drive/992)).softclip)) / (1 + (tanh((sig3*2.pow(drive/992)).softclip)).abs);

	///final out

					gain1=gain*rq1.sqrt.reciprocal*cloud.reciprocal*10*namp1;
					gain2=gain*rq2.sqrt.reciprocal*cloud.reciprocal*10*namp2;
					gain3=gain*rq3.sqrt.reciprocal*cloud.reciprocal*10*namp3;

					sp=azf;
					spl=elf;

g_ch1 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[0],~el[0]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[0],~el[0]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[1],~el[1]).x)+
(Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[1],~el[1]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[2],~el[2]).x)+
   (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[2],~el[2]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[3],~el[3]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[3],~el[3]).y)+
   (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[3],~el[3]).z)
					);

//g11 = g_ch1;
//g22 = g_ch2;
//g33 = g_ch3;
//g44 = g_ch4;

//g_ch1 = (g11 + (g22*spread) + (g33*spread) + (g44*spread));
//g_ch2 = (g22 + (g11*spread) + (g33*spread) + (g44*spread));
//g_ch3 = (g33 + (g11*spread) + (g22*spread) + (g44*spread));
//g_ch4 = (g44 + (g11*spread) + (g22*spread) + (g33*spread));

g_sum = (g_ch1.pow(2) + g_ch2.pow(2) + g_ch3.pow(2) + g_ch4.pow(2)).sqrt;

g_ch1 = (g_ch1 / g_sum).lag(0.01);
g_ch2 = (g_ch2 / g_sum).lag(0.01);
g_ch3 = (g_ch3 / g_sum).lag(0.01);
g_ch4 = (g_ch4 / g_sum).lag(0.01);

g_ch1 = g_ch1.pow(spread.linlin(0.01,1,0.4,0.01));
g_ch2 = g_ch2.pow(spread.linlin(0.01,1,0.4,0.01));
g_ch3 = g_ch3.pow(spread.linlin(0.01,1,0.4,0.01));
g_ch4 = g_ch4 .pow(spread.linlin(0.01,1,0.4,0.01));


g_ch1 =g_ch1.max(0.01) + (g_ch1 - g_ch1.max(0.01)).min(0);
g_ch2 =g_ch2.max(0.01) + (g_ch2 - g_ch2.max(0.01)).min(0);
g_ch3 =g_ch3.max(0.01) + (g_ch3 - g_ch3.max(0.01)).min(0);
g_ch4 =g_ch4.max(0.01) + (g_ch4 - g_ch4.max(0.01)).min(0);

Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch1.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch2.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch3.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch4.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1)/cloud);

Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch1.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch2.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch3.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch4.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1)/cloud);

Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch1.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch2.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch3.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1)/cloud);
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch4.sign.lag(0.1),mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1)/cloud);

					Out.ar(0,WhiteNoise.ar(0.00001)!chan);

						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
nn=nn+1;
				};

}).add;);

10.wait;


////durs
		(
~azz=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~ell=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);
		//tetr
		(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
			~r1=0; ~r2=0; ~r3=0;

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~azz.[m1],~ell.[m1]).rotate(~r1).tilt(~r2).tumble(~r3).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~azz.[m2],~ell.[m2]).rotate(~r1).tilt(~r2).tumble(~r3).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~azz.[m3],~ell.[m3]).rotate(~r1).tilt(~r2).tumble(~r3).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;

}.value;
);

		////////2////sequencer
		(

			~seq1= Pseq(~dur, inf).asStream;
				~seq2 = Pseq(~dur2, inf).asStream;
				~seq3 = Pseq(~dur3, inf).asStream;
		//~system= Pseq(~r,inf).asStream;
			~tonb=0;
			~panwidth=1;
          ~detune=1;
			~pass=992*2;
			~drive=992*3;
			~mox=0.6;
			~gg=1;
			~pon=0.5;
			~sphpan=(992*2).neg;
			~bband=(992*16).neg;
			~drn=0.1;
		//	thisThread.randSeed = 123;

~str1 = Routine({
    var i,m,l;

    loop {
					//	thisThread.randSeed = ~val.asInteger;
							TempoClock.default.tempo_(1);
				//	TempoClock.default.tempo_(~val/300);
				//	~r1=0; ~r2=0; ~r3=0;
				//	i=0;
				//	l=~system.next;
					//~detune=32.rand.round(2).max(1);
							i= ~cart.lag(0.01).size.rand;
~detune=1;

	~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,8,\sc,14,\low,~pass,\pan,~bband,\mix,~mox,\room,~rev.lag(0.01),
				\pann,~sphpan,\x,2,\a,1,\spread,~rev.lag(0.01),\pon,~pon,\pneuma,0,\namp,1,\drone,5.neg,\panx,~drn+0.55.rand
				\pany,~drn+0.55.rand,\panz,~drn+0.55.rand,\dron,~tonb]).register;


        ~seq1.next.wait;

    }
		});


		);




	~str1.play;

	~str1.stop;



		TempoClock.default.tempo_(1/1);









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

