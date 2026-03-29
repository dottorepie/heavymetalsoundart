
(
var img = Image.open("/Users/amimid/Desktop/1.png");
var width = img.width;
var height = img.height;

// Get pixel color at (x, y)
var color = img.getColor(0, 0); // returns a Color object

[color.red, color.green, color.blue].postln;
)


(
var img = Image.open("/Users/amimid/Desktop/1.png");

img.width.do { |x|
    img.height.do { |y|
        var color = img.getColor(x, y);
        // do something with c.red, c.green, c.blue
		[color.red, color.green, color.blue].postln;
    };
};
)


(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
s.makeGui(w);
s.waitForBoot{
Buffer.freeAll;
~controlBus = Bus.control(s, 1);
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
~controlBus3 = Bus.control(s, 1);
~controlBus4 = Bus.control(s, 1);
~controlBus5 = Bus.control(s, 1);
~controlBus6 = Bus.control(s, 1);
~controlBus7 = Bus.control(s, 1);

	~scale1= Buffer.alloc(s,2048);
	~scale2= Buffer.alloc(s,2048);
	~scale= Buffer.alloc(s,2048);
	~rotation= Buffer.alloc(s,2048);
	~harm= Buffer.alloc(s,2048);
	~temp= Buffer.alloc(s,2048);
	~space= Buffer.alloc(s,2048);



{
var signal,wt;
	//signal=Env([1,100],[3],[8]);
		signal=Env([1,2000],[3],[10]);
	wt = signal.asSignal(1024).asWavetable;
~scale2.loadCollection(wt);
//signal.plot;
		}.value;
		{
var signal,wt;
//	signal=Env([1,10000],[3],[12]);
			signal=Env([1,1000],[3],[16]);
	wt = signal.asSignal(1024).asWavetable;
~scale1.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	//signal=Env([0.005,1,0.01],[2,1],[4,2.neg]);
		signal=Env([1,20000,1],[2.95,0.05],[5,1.neg]);
	wt = signal.asSignal(1024).asWavetable;
~scale.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	signal=Env([0.4,0.001],[3],[4]);
	wt = signal.asSignal(1024).asWavetable;
~rotation.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	signal=Env([10,1],[3],[8]);
	wt = signal.asSignal(1024).asWavetable;
~harm.loadCollection(wt);
//signal.plot;
		}.value;

		{
var signal,wt;
	signal=Env([1,0],[3],[16]);
	wt = signal.asSignal(1024).asWavetable;
~temp.loadCollection(wt);
//signal.plot;
		}.value;

			{
var signal,wt;
	signal=Env([0,1],[3],[256]);
	wt = signal.asSignal(1024).asWavetable;
~space.loadCollection(wt);
	//signal.plot;
		}.value;


(
SynthDef.new(\player,{

	Out.kr(~controlBus.index, (Osc.kr(~scale.bufnum,(1/100)).abs));
	Out.kr(~controlBus1.index, (Osc.kr(~scale1.bufnum,(1/100)).abs));
	Out.kr(~controlBus4.index, (Osc.kr(~scale2.bufnum,(1/100)).abs));
	Out.kr(~controlBus2.index, (Osc.kr(~rotation.bufnum,(1/100)).abs));
    Out.kr(~controlBus3.index, (Osc.kr(~harm.bufnum,(1/100)).abs));
	Out.kr(~controlBus5.index, (LFNoise1.kr(1/100).range(pi.neg,pi)));
	Out.kr(~controlBus6.index, (Osc.kr(~temp.bufnum,(1/100)).abs));
	Out.kr(~controlBus7.index, (Osc.kr(~space.bufnum,(1/100)).abs));


}).add;
	);~count=[1,2,2,2,2,8];
}
)



//Server.freeAll
//smoothing
//az1 = az1 + (targetAz1 - az1) * 0.1;
//el1 = el1 + (targetEl1 - el1) * 0.1;

//////////////////////////////////////////////////////////////////////animation
(
({
var ot=0,dota,pla=0;
var data;
var az=0,el=0;
var sph,mag,r,run = true;
var scale=1,scale1=10,scale2=10,harm,perspective;
var axis=~count.[0],cloud=~count.[1],axis1=~count.[2],gravity1=~count.[3],axis2=~count.[4],gravity2=~count.[5];
var m_x=1,m_y=1,m_z=1,mq=m_x+1;
var sph1,sph2,sph3,sph4,sph7,sph6;
var sph11,sph22,sph33,sph44,sph77,sph66;
var sph_1,sph_2,sph_3,sph_4,sph_7,sph_6;
var sph_11,sph_22,sph_33,sph_44,sph_77,sph_66;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,az4=0,el4=0,az7=0,el7=0,az6=0,el6=0;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az77=0,el77=0,az66=0,el66=0;
var az_1=0,el_1=0,az_2=0,el_2=0,az_3=0,el_3=0,az_4=0,el_4=0,az_7=0,el_7=0,az_6=0,el_6=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,magnitudeqx;
var magx,magy,magz,magqx,rotation;
var angle=0,angle1=0,angle11=0;
var g=((1+5.sqrt)/2),s=(1+2.sqrt),ott=pi.rand2,temp,space;

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[]; ~cart=[];      ~detune=1;
//	spread = if(m_z < 1) { 1 / m_z } { m_z };
Synth.new(\player);
data = [];
Window.free;
~w = Window.new("3D Scatterplot", Rect(40,40, 2000, 1200)).front;

~v = UserView.new(~w,Rect(0,0,1800,1000)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [-5000, 5000].asSpec,[-5000, 5000].asSpec,[-5000, 5000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 2;
a.symbolColor = Color.white;
a.background = Color.clear;
b = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [-4000, 4000].asSpec,[-4000, 4000].asSpec,[-9000, 4000].asSpec);
b.drawMethod = \fillRect;
b.symbolSize = 2;
b.symbolColor = Color.white;
b.background = Color.clear;

  r= Routine({loop{



		scale=~controlBus.getSynchronous;
	scale1=~controlBus1.getSynchronous;
	scale2=~controlBus4.getSynchronous;
	rotation=~controlBus2.getSynchronous;
	harm=~controlBus3.getSynchronous;
	angle=~controlBus5.getSynchronous;
		temp=~controlBus6.getSynchronous;
			space=~controlBus7.getSynchronous;

		~rev=harm/10;

	m_x=m_y=m_z=harm;
		mq=harm+1;


	axis=~count.[0];
	cloud=~count.[1];
	axis1=~count.[2];
	gravity1=~count.[3];
	axis2=~count.[4];
	gravity2=~count.[5];

        az1=0; el1=0;
        az2=0; el2=0;
        az3=0; el3=0;
        az4=0; el4=0;
        az7=0; el7=0;
        az6=0; el6=0;
angle = 0;
angle1 = 0;
angle11 = 0;

az11=0; el11=0;
az22=0; el22=0;
az33=0; el33=0;
az44=0; el44=0;
az77=0; el77=0;
az66=0; el66=0;

az_1=0; el_1=0;
az_2=0; el_2=0;
az_3=0; el_3=0;
az_4=0; el_4=0;
az_7=0; el_7=0;
az_6=0; el_6=0;

        data = [];
	dota=[];
        pla = 0;

	//scale=1;
	//scale.postln;

	(
{
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~magqx=[];


	axis.do{

//////////////////////////// AZ
cloud.do{

az1=(az1+(2pi-(2pi/g))).wrap(pi.neg,pi);
el1=(el1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph1=Spherical(1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az11=sph1.theta;
el11=sph1.phi;

gravity1.do{

az11=(az11+(2pi-(2pi/g))).wrap(pi.neg,pi);
el11=(el11+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph11=Spherical(1/scale1,(az11+angle1).wrap(pi.neg,pi),(el11+angle1).wrap((pi/2).neg,(pi/2)));

sph_1=(sph1.asCartesian+sph11.asCartesian);

axis2.do{

az_1=sph11.theta;
el_1=sph11.phi;

azimuth=gravity2.collect{

az_1=(az_1+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_1=(el_1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_11=Spherical(1/scale2,(az_1+angle11).wrap(pi.neg,pi),(el_1+angle11).wrap((pi/2).neg,(pi/2)));

(sph_1+sph_11.asCartesian).asSpherical.theta

};

~az=~az++azimuth;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// EL
cloud.do{

az2=(az2+(2pi-(2pi/g))).wrap(pi.neg,pi);
el2=(el2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph2=Spherical(1,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az22=sph2.theta;
el22=sph2.phi;

gravity1.do{

az22=(az22+(2pi-(2pi/g))).wrap(pi.neg,pi);
el22=(el22+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph22=Spherical(1/scale1,(az22+angle1).wrap(pi.neg,pi),(el22+angle1).wrap((pi/2).neg,(pi/2)));

sph_2=(sph2.asCartesian+sph22.asCartesian);

axis2.do{

az_2=sph22.theta;
el_2=sph22.phi;

elevation=gravity2.collect{

az_2=(az_2+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_2=(el_2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_22=Spherical(1/scale2,(az_2+angle11).wrap(pi.neg,pi),(el_2+angle11).wrap((pi/2).neg,(pi/2)));

(sph_2+sph_22.asCartesian).asSpherical.phi

};

~el=~el++elevation;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG X
cloud.do{

az3=(az3+(2pi-(2pi/g))).wrap(pi.neg,pi);
el3=(el3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph3=Spherical(1,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az33=sph3.theta;
el33=sph3.phi;

gravity1.do{

az33=(az33+(2pi-(2pi/g))).wrap(pi.neg,pi);
el33=(el33+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph33=Spherical(1/scale1,(az33+angle1).wrap(pi.neg,pi),(el33+angle1).wrap((pi/2).neg,(pi/2)));

sph_3=(sph3.asCartesian+sph33.asCartesian);

axis2.do{

az_3=sph33.theta;
el_3=sph33.phi;

magnitudex=gravity2.collect{

az_3=(az_3+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_3=(el_3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_33=Spherical(1/scale2,(az_3+angle11).wrap(pi.neg,pi),(el_3+angle11).wrap((pi/2).neg,(pi/2)));

magx=((Complex(cos((sph3.theta*m_x)),cos((sph3.theta*m_x))).rho/(2.sqrt))*
(Complex(cos((sph3.phi)),cos((sph3.phi))).rho/(2.sqrt)));

(Spherical(magx,sph3.theta,sph3.phi).asCartesian
+Spherical(magx/scale2,sph_33.theta,sph_33.phi).asCartesian).asSpherical.rho

};

								~magx=~magx++magnitudex;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG Y
cloud.do{

az4=(az4+(2pi-(2pi/g))).wrap(pi.neg,pi);
el4=(el4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph4=Spherical(1,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az44=sph4.theta;
el44=sph4.phi;

gravity1.do{

az44=(az44+(2pi-(2pi/g))).wrap(pi.neg,pi);
el44=(el44+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph44=Spherical(1/scale1,(az44+angle1).wrap(pi.neg,pi),(el44+angle1).wrap((pi/2).neg,(pi/2)));

sph_4=(sph4.asCartesian+sph44.asCartesian);

axis2.do{

az_4=sph44.theta;
el_4=sph44.phi;

magnitudey=gravity2.collect{

az_4=(az_4+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_4=(el_4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_44=Spherical(1/scale2,(az_4+angle11).wrap(pi.neg,pi),(el_4+angle11).wrap((pi/2).neg,(pi/2)));

magy=((Complex(sin((sph4.theta*m_x)),sin((sph4.theta*m_x))).rho/(2.sqrt))*
(Complex(cos((sph4.phi)),cos((sph4.phi))).rho/(2.sqrt)));

(Spherical(magy,sph4.theta,sph4.phi).asCartesian
+Spherical(magy/scale2,sph_44.theta,sph_44.phi).asCartesian).asSpherical.rho

};

								~magy=~magy++magnitudey;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG Z
cloud.do{

az7=(az7+(2pi-(2pi/g))).wrap(pi.neg,pi);
el7=(el7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph7=Spherical(1,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az77=sph7.theta;
el77=sph7.phi;

gravity1.do{

az77=(az77+(2pi-(2pi/g))).wrap(pi.neg,pi);
el77=(el77+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph77=Spherical(1/scale1,(az77+angle1).wrap(pi.neg,pi),(el77+angle1).wrap((pi/2).neg,(pi/2)));

sph_7=(sph7.asCartesian+sph77.asCartesian);

axis2.do{

az_7=sph77.theta;
el_7=sph77.phi;

magnitudez=gravity2.collect{

az_7=(az_7+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_7=(el_7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_77=Spherical(1/scale2,(az_7+angle11).wrap(pi.neg,pi),(el_7+angle11).wrap((pi/2).neg,(pi/2)));

magz=(Complex(sin((sph7.phi*m_z)),sin((sph7.phi*m_z))).rho/(2.sqrt));

(Spherical(magz,sph7.theta,sph7.phi).asCartesian
+Spherical(magz/scale2,sph_77.theta,sph_77.phi).asCartesian).asSpherical.rho

};

								~magz=~magz++magnitudez;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

/////////////////////////////////MAG QX
	cloud.do{

az6=(az6+(2pi-(2pi/g))).wrap(pi.neg,pi);
el6=(el6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph6=Spherical(1,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az66=sph6.theta;
el66=sph6.phi;

gravity1.do{

az66=(az66+(2pi-(2pi/g))).wrap(pi.neg,pi);
el66=(el66+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph66=Spherical(1/scale1,(az66+angle1).wrap(pi.neg,pi),(el66+angle1).wrap((pi/2).neg,(pi/2)));

sph_6=(sph6.asCartesian+sph66.asCartesian);

axis2.do{

az_6=sph66.theta;
el_6=sph66.phi;

magnitudeqx=gravity2.collect{

az_6=(az_6+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_6=(el_6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_66=Spherical(1/scale2,(az_6+angle11).wrap(pi.neg,pi),(el_6+angle11).wrap((pi/2).neg,(pi/2)));

		magqx=((((Complex(cos(((sph6.theta)*mq).wrap(pi.neg,pi)),cos(((sph6.theta)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
										(Complex(cos((sph6.phi).wrap((pi/2).neg,(pi/2))),cos((sph6.phi).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));

(Spherical(magqx,sph6.theta,sph6.phi).asCartesian
+Spherical(magqx/scale2,sph_66.theta,sph_66.phi).asCartesian).asSpherical.rho

};

								~magqx=~magqx++magnitudeqx;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle=(angle+(2pi-(2pi/g))).wrap(0,2pi);

az1=0;el1=0;
az2=0;el2=0;
az3=0;el3=0;
az4=0;el4=0;
az7=0;el7=0;
az6=0;el6=0;

};
}.value;
);

	~azimuth=~az;
	~elevation=~el;
	~magnitude=(~magqx.[pla].pow(2)+~magy.pow(2)+~magz.pow(2)).sqrt*(14/~detune);
//~magnitude.postln;

	dota=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]).collect{

	az=~az.[pla];
	el=~el.[pla];
	//mag=1000;
			mag=(Cartesian(~magqx.[pla],~magy.[pla],~magz.[pla]).rho)/2.sqrt;
	//	mag=mag+(Cartesian(~magqx.[pla],0,0).rho);
	pla=pla+1;
			//mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);
			//sph=Spherical(perspective*scale*mag,az,el).asCartesian.asArray;
		sph=Spherical(scale*mag,az,el).asCartesian.asArray;
};
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	data =data++dota;

	//data.postln;
        // schedule GUI update on AppClock
        AppClock.sched(0, {
            a.data = data;   // ScatterView3d data
			b.data = data;

			~v.background_(Color(space,space,space));
            ~v.refresh;
          //  0;               // keep AppClock loop going
        }); /*~cart.postln;*/ (1/8).wait;
};};

);
r.play;


~v.animate;
~v.drawFunc ={

    Pen.translate(1000,600);

		b.symbolColor = Color.new(red:temp,blue:temp,green:temp);
		//a.symbolColor =Color.new(red:temp,blue:temp,green:temp);
   a.rot(ot,ot,ot);
		 b.rot(ott,ott,ott);
				~r1=ot; ~r2=ot; ~r3=ot;

		ot = (ot + rotation.degrad).wrap(0,2pi);
		ott = (ott + (0.1+rotation).degrad).wrap(0,2pi);

    ~cart = data.collect{|p|

        var x=p[0], y=p[1], z=p[2];
        var rx,ry,rz;

        // rotate X
		ry = (y*cos(ot)) - (z*sin(ot));
		rz = (y*sin(ot) )+ (z*cos(ot));
        y = ry; z = rz;

        // rotate Y
		rx = (x*cos(ot)) + (z*sin(ot));
		rz =( x.neg*sin(ot)) + (z*cos(ot));
        x = rx; z = rz;

        // rotate Z
		rx = (x*cos(ot)) -(y*sin(ot));
		ry = (x*sin(ot)) + (y*cos(ot));
        x = rx; y = ry;

        [x,y,z];
    };

};
//{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);
}.value);

)



(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
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
//s.freqscope;
//s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	//Buffer.freeAll;


		///octahedron
	//	(
//~azz=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
//~ell=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
//);

			//tetr
		(
~azz=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~ell=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

				///vbap
/*(
~a = VBAPSpeakerArray.new(3,
[[~azz.[0],~ell.[0]], [~azz.[1],~ell.[1]], [~azz.[2],~ell.[2]], [~azz.[3],~ell.[3]],[~azz.[4],~el.[4]],[~azz.[5],~ell.[5]]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/

/////tetrahedron
		/*(
~a = VBAPSpeakerArray .new3,(
[[45.degrad,35.264390.neg.degrad], [135.neg.degrad,35.264390.neg.degrad], [45.neg.degrad,35.264390.degrad], [135.degrad,35.264390.degrad]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/


////sesor based randomnes
		// SerialPort.devices;
		// ~port = SerialPort.new("/dev/cu.usbserial-2240",9600);
		//
		// (
		// 	~charArray = [];
		// 	~getValues = Routine.new({
		//
		// 		var ascii;
		// 		{ascii = ~port.read.asAscii;
		// 			if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		// 			if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
		// 				~charArray =[];
		// 			});
		// 		}.loop;
		//
		// 	}).play;
		// );


		///////L-system
	(
{
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 9;

//These are diction for the mapping of the alphabet to "artistic" parameters: degrees in a scale, beat occurrence, etc.

var dictnotes = IdentityDictionary[\A -> 0.5, \B -> 1];
 ~r=[];

//This iteration generates the system recursively

iter.do({

word.asArray.do({|i|
    string_temp = string_temp ++ dict[i.asSymbol];
});

word = string_temp;
	string_temp = "";
});

word.postln;

//Here we map the final system to the parameters as above

word.do({|i| ~r = ~r ++ dictnotes[i.asSymbol];});

~r.postln;
}.value
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


		/////distortion table
		(
			~dist= Buffer.alloc(s,2048);
		~transfer_function= Env([0.8.neg,0,0.8],[1,1],[8,8.neg]).asSignal(1024);
			~transfer_function=~transfer_function+(Signal.sineFill(~signalSize,~array,~ph)/8);
		~transfer_function=~transfer_function.normalize;
		//	~transfer_function.plot;
			~dist.loadCollection(~transfer_function.asWavetableNoWrap);
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

	arg gain=1,low=992,tone1=0,tone2=0,tone3=0,x=1,pan=1,mix=0.3,a=1,room=0.5,fund_tone=1,pon=0.01,namp=1,
				drive=1,spread=1,drone_amp=1,pann=0,drone=1,xx=1,yy=1,zz=1,
				pneuma=0,panx=1,pany=1,panz=1,sc=1,dron=1,az=0,el=0;

	var rq=1,cloud=3,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,ton,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z;
	var polytope,gain1,gain2,gain3,env,azimuth,elevation,m=2,fu=4;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph;
	var loc1,loc2,loc3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor,dr;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,axis;
	var r_axis, r_v, r, axisr,spr,rot,i,j,k,level=100,spx,spy,spz;
	var g_ch1,g_ch2,g_ch3,g_ch4,chan=4,sp,spl;
	var gn ,g_sum,g_avg ,ton1,ton2,ton3,tonb,laxis,g11,g22,g33,g44;


				m = In.kr(~controlBus3).lag(0.1).round(1);

				env=EnvGen.ar(Env.sine(12),doneAction:2,levelScale:1);
fund=fu*(9/8);
lamdoma=(x.lag(0.001)+a.lag(0.001))/x.lag(0.001);


						sph_object=Spherical(28,az.lag(0.0001),el.lag(0.0001));
				tone1=sph_object.x;
				tone2=sph_object.y;
				tone3=sph_object.z;

				tonb=2.pow(dron.lag(0.0001)/992);

ton1=2.pow(Select.kr(tone1.round(1), ~scaleee) /12).round(0.0001)*tonb;
ton2=2.pow(Select.kr(tone2.round(1), ~scaleee) /12).round(0.0001)*tonb;
ton3=2.pow(Select.kr(tone3.round(1), ~scaleee) /12).round(0.0001)*tonb;


				lfon=2.pow(pann/992);
					band=pan;

				mq=(m.lag(0.001)+1);

				spr=Cartesian(xx.max(0.01).lag(0.01),yy.max(0.01).lag(0.01),zz.max(0.01).lag(0.01));
				//spx=Cartesian(spr.x,0,0);
				//spy=Cartesian(0,spr.y,0);
				//spz=Cartesian(0,0,spr.z);

					polytope=Spherical(sc.max(0.01).lag(0.01),spr.theta,spr.phi);
						//	laxis=Spherical(lamdoma,spr.theta,spr.phi);


b_x=2.pow(Select.kr(polytope.x.round(0.0001), ~scalee) /12).round(0.0001)*lamdoma;
b_y=2.pow(Select.kr(polytope.y.round(0.0001), ~scalee) /12).round(0.0001)*lamdoma;
b_z=2.pow(Select.kr(polytope.z.round(0.0001), ~scalee) /12).round(0.0001)*lamdoma;

//b_x=laxis.x.round((9/8)/2);
//b_y=laxis.y.round((9/8)/2);
//b_z=laxis.z.round((9/8)/2);


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

loc1=magqx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta;
phasey=Complex(1,sph.y).theta;
phasez=Complex(1,sph.z).theta;


freq1=(fund*ton1)*b_x.lag(0.0001);
freq2=(fund*ton2)*b_y.lag(0.0001);
freq3=(fund*ton3)*b_z.lag(0.0001);

					dr=2.pow(drone.lag(0.1)/12)*tonb;

f1=(fund)*b_x.lag(0.0001)*dr;
f2=(fund)*b_y.lag(0.0001)*dr;
f3=(fund)*b_z.lag(0.0001)*dr;

amp1=ton1.reciprocal*b_x.reciprocal;
amp2=ton2.reciprocal*b_y.reciprocal;
amp3=ton3.reciprocal*b_z.reciprocal;

g1=b_x.reciprocal*dr.reciprocal*panx;
g2=b_y.reciprocal*dr.reciprocal*pany;
g3=b_z.reciprocal*dr.reciprocal*panz;

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.001)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.001)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.001)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.001)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.001)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.001)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.001)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.001)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.001)/992),phase:phasez,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.001)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.001)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.001)/992),phase:phasez.neg,mul:rq).exprange(0.1,1)]);


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

					sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.001)/992),amp1)+ds1);
					sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.001)/992),amp2)+ds2);
					sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.001)/992),amp3)+ds3);

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

threshold1=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,65);
		sig2=HPF.ar(sig2, 65);
		sig3=HPF.ar(sig3, 50);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15);

	///distortion
					sig1 = (tanh((sig1*2.pow(drive/992)).softclip)) / (1 + (tanh((sig1*2.pow(drive/992)).softclip)).abs);

		sig2 =  (tanh((sig2*2.pow(drive/992)).softclip)) / (1 + (tanh((sig2*2.pow(drive/992)).softclip)).abs);

	sig3 =  (tanh((sig3*2.pow(drive/992)).softclip)) / (1 + (tanh((sig3*2.pow(drive/992)).softclip)).abs);


	///final out
					gain1=gain*rq1.sqrt.reciprocal*env;
					gain2=gain*rq2.sqrt.reciprocal*env;
					gain3=gain*rq3.sqrt.reciprocal*env;


		cloud.do{
					//sp= LFNoise2.ar(6).range(spread*pi.neg, spread*pi);
					//spl= LFNoise2.ar(6).range(spread*(pi/2).neg, spread*(pi/2));
								sp=azf*spread;
					spl=elf*spread;


g_ch1 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[0],~el[0]).x) +
 (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[0],~el[0]).y)+
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[1],~el[1]).x)+
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[1],~el[1]).y)+
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[2],~el[2]).x)+
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[2],~el[2]).y)+
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).x * Spherical(mag,~az[3],~el[3]).x) +
 (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).y * Spherical(mag,~az[3],~el[3]).y )+
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(pi/2,(pi/2).neg)).z * Spherical(mag,~az[3],~el[3]).z)
					);

g11 = g_ch1;
g22 = g_ch2;
g33 = g_ch3;
g44 = g_ch4;

g_ch1 = (g11 + (g22*spread) + (g33*spread) + (g44*spread));
g_ch2 = (g22 + (g11*spread) + (g33*spread) + (g44*spread));
g_ch3 = (g33 + (g11*spread) + (g22*spread) + (g44*spread));
g_ch4 = (g44 + (g11*spread) + (g22*spread) + (g33*spread));

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


//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1)),0.9,0.01)*g_ch1*loc1)
//Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1)),0.9,0.01)*g_ch2*loc1);
//Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1)),0.9,0.01)*g_ch3*loc1);
//Out.ar(3,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1)),0.9,0.01)*g_ch4*loc1);

//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2)),0.9,0.01)*g_ch1*loc2)
//Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2)),0.9,0.01)*g_ch2*loc2);
//Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2)),0.9,0.01)*g_ch3*loc2);
//Out.ar(3,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2)),0.9,0.01)*g_ch4*loc2);

					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3)),0.9,0.01)*g_ch1*loc3);
//Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3)),0.9,0.01)*g_ch2*loc3);
//Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3)),0.9,0.01)*g_ch3*loc3);
//Out.ar(3,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3)),0.9,0.01)*g_ch4*loc3);

					///three channel
				//	Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1*loc1.abs)),0.9,0.01));
				//	Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2*loc2.abs)),0.9,0.01));
				//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3*loc3.abs)),0.9,0.01));

					////azimuthal multichannel expansion

//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1*loc1.abs)),0.9,0.01),SinOsc.ar(panx,phasex),width:spread));	//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2*loc2.abs)),0.9,0.01),SinOsc.ar(pany,phasey),width:spread));
//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3*loc3.abs)),0.9,0.01),SinOsc.ar(panz,phasez),width:spread));

				/////3d vbap expansion
		/*			Out.ar(0,VBAP.ar(3,Limiter.ar(LeakDC.ar(
						FreeVerb.ar(env*sig1,mix.lag(0.001),room.lag(0.001),mul:gain1*loc1.abs)),0.9,0.01),~b,(spx.theta.raddeg+SinOsc.ar(panx,phasex).range(180,180.neg)).wrap(180,180.neg),
					(spx.phi.raddeg+SinOsc.ar(panx,phasex).range(90,90.neg)).wrap(90,90.neg),spread:spread));

Out.ar(0,VBAP.ar(3,Limiter.ar(LeakDC.ar(
						FreeVerb.ar(env*sig2,mix.lag(0.001),room.lag(0.001),mul:gain2*loc2.abs)),0.9,0.01),~b,(spy.theta.raddeg+SinOsc.ar(pany,phasey).range(180,180.neg)).wrap(180,180.neg),
					(spy.phi.raddeg+SinOsc.ar(pany,phasey).range(90,90.neg)).wrap(90,90.neg),spread:spread));

Out.ar(0,VBAP.ar(3,Limiter.ar(LeakDC.ar(
						FreeVerb.ar(env*sig3,mix.lag(0.001),room.lag(0.001),mul:gain3*loc3.abs)),0.9,0.01),~b,(spz.theta.raddeg+SinOsc.ar(panz,phasez).range(180,180.neg)).wrap(180,180.neg),
					(spz.phi.raddeg+SinOsc.ar(panz,phasez).range(90,90.neg)).wrap(90,90.neg),spread:spread));
*/

///ambisonic decoded on stereo
					//=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain1)),0.9,0.01));
					//amb_sig2=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain2)),0.9,0.01));
					//amb_sig3=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain3)),0.9,0.01));

				//	amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
				//	amb_x=amb_sig1;
				//	amb_y=amb_sig2;
				//	amb_z=amb_sig3;

							//	out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z,
					//	[sph.theta+LFSaw.ar(pon,0), sph.theta+LFSaw.ar(pon,0.5)], [sph.phi,sph.phi],2 ));






Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch1.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch2.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch3.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch4.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1));

Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch1.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch2.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch3.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch4.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1));

Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch1.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch1.abs.lag(0.1),LFSaw.ar(pon,0),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch2.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch2.abs.lag(0.1),LFSaw.ar(pon,1/4),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch3.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch3.abs.lag(0.1),LFSaw.ar(pon,1/2),width:spread+1));
Out.ar(0,PanAz.ar(chan,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch4.sign.lag(0.1).abs,mix.lag(0.0001),room.lag(0.0001),mul:gain3)),0.9,0.01)*g_ch4.abs.lag(0.1),LFSaw.ar(pon,3/4),width:spread+1));


					Out.ar(0,WhiteNoise.ar(0.00001)!chan);

						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2))
				};

}).add;);

10.wait;


////durs
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

	~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,8,\sc,14,//~magnitude.lag(0.01).[i].round(1).max(1).asInteger,
						\low,~pass,\pan,~bband,\mix,~mox,\room,~rev.lag(0.01),\pann,~sphpan,\x,2,\a,1,\spread,~rev.lag(0.01),
						\pon,~pon,\pneuma,0,\namp,1,\drone,5.neg,\az,~azimuth.lag(0.01).[i],\el,~elevation.lag(0.01).[i]
						,\panx,~drn+0.55.rand,\pany,~drn+0.55.rand,\panz,~drn+0.55.rand,\dron,~tonb,
\xx,~cart.lag(0.01).[i].[0].round(0.00001), \yy,~cart.lag(0.01).[i].[1].round(0.00001),\zz,~cart.lag(0.00001).[i].[2].round(0.00001)]).register;


        ~seq1.next.wait;

    }
		});


		);


	});
	Tdef(\drone).play;
}
)
)


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

