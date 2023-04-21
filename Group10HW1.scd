s.plotTree;

(
var window, w, h, tittle,text,explanation, zoom, data;
w = 800;
h = 600;
window = Window("Distortion",Rect.new(Window.screenBounds.width/2-(w/2), Window.screenBounds.height/2-(h/2), w, h)).front;
window.background_(Color.fromHexString("#60656C"));
window.alwaysOnTop_(true);
tittle = StaticText(window, Rect(w/4, h/20, w/2, h/20)).stringColor_(Color.white).font_(Font("Cambria",40)).align_(\center);
tittle.string = "DISTORTION";
text = StaticText(window, Rect(5*w/20, 4*h/20, 10*w/20, 10*h/20)).stringColor_(Color.white).font_(Font("Cambria",18)).align_(\center).visible_(true);
text.string = "This application is a tool that provides an aproach to distortion in musical contexts in two different modes according to the profile of the user. In that Way, this tool can be use as self learn application, Learn mode, and for teaching purpuposes for well knower of the topyc who wants to use an interactive way to explain Distortion to others. Base on the information mentioned above select the mood you prefer and have some fun while.";

f = Buffer.alloc(s,1024,2);
b = Bus.audio(s,1);



~audioSelect = 0;
~eqFreq = 1000;

~eqQue = 0.5;
~eqGain = 12;
~rectSelect = 0;
~transSelect = 0;



//Learn Mode - Student
~learn = Button.new(window, Rect(6*w/20, 16*h/20, 2*w/20, h/20))
.states_([
	["Learn", Color.black,Color.gray(0.8)], //Satate 0
	["Learn", Color.white,Color.fromHexString("#EE6C4D")]]) //Satate 1
.action_({
	arg obj;
	if(obj.value == 1,{
		~teach.valueAction_(0).bounds_(Rect(15.5*w/20, 18.5*h/20, 2*w/20, h/20)); //Teach button set in 0 and actions are triggered
		~learn.bounds_(Rect(2.5*w/20, 18.5*h/20, 2*w/20, h/20)); //Lear button is moved to the button
		text.visible_(false); //hide main text
		explanation.visible = true;
		~menu.visible = true;

		~sineSound.states_([["Sine", Color.black,Color.gray(0.8)],
			["Piano", Color.white,Color.fromHexString("#3693D1")]]).visible_(true).action_({ arg butt; ~audioSel = butt.value; });
				~playButt.states_([["Play", Color.black,Color.gray(0.8)],
			["Play", Color.white,Color.fromHexString("#3693D1")]]).value_(0).visible_(true); //Set play button in learn in state 0


		~ig_knob.bounds_(Rect(4*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#EE6C4D")).visible_(true);
		~lpf_pre_knob.bounds_(Rect(7*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#EE6C4D")).visible_(true);
		~ov_knob.bounds_(Rect(10*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#EE6C4D")).visible_(true);

		~ig_txtknob.bounds_(Rect(3.6*w/20, 14.5*h/20, 2*w/20, h/20)).visible_(true);
		~lpf_pre_txtknob.bounds_(Rect(6.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("LPF").visible_(true);
		~ov_txtknob.bounds_(Rect(9.6*w/20, 14.7*h/20, 2*w/20, h/20)).visible_(true);

		~scopeView.bounds_(Rect(4*w/20, 4*h/20, 7*w/20, 6*h/20)).background_(Color.fromHexString("#EE6C4D")).visible_(true);
		~trFunction.bounds_(Rect(12*w/20, 4*h/20, 7*w/20, 6*h/20)).visible_(true);
		~sig.value = ~symmetric_distortion.value(x:Array.series(100,-1, 2/100),q:6); // TF takes the line value pre set
			~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec; // this set x axis from -1 to 1
		window.drawFunc = { // This function draw the orange square around the knobs
			Pen.strokeColor = Color.fromHexString("#EE6C4D").alpha_(0.5);
			Pen.width = 3;
			Pen.strokeRect(Rect(3.6*w/20, 12.5*h/20, 8*w/20, 3.5*h/20));
		};
		window.refresh;
	},
	{  // if state of Learn is in 0 these actions are done
		~learn.bounds_(Rect(6*w/20, 16*h/20, 2*w/20, h/20));
		~teach.bounds_(Rect(11*w/20, 16*h/20, 2*w/20, h/20));
		~sineSound.visible_(false);
		~playButt.visible_(false);
		~scopeView.visible_(false); ~trFunction.visible_(false);
		~menu.visible_(false);
		~ig_knob.visible_(false);
		~lpf_pre_knob.visible_(false);
		~ov_knob.visible_(false);
		~ig_txtknob.visible_(false);
		~lpf_pre_txtknob.visible_(false);
		~ov_txtknob.visible_(false);
		explanation.visible_(false);
		text.visible_(true);
		window.drawFunc = {
			Pen.strokeColor = Color.white.alpha_(0.5);
			Pen.width = 3;
			Pen.strokeRect(Rect(4*w/20, 4*h/20, 12*w/20, 10*h/20));
		};
		window.refresh;

});})
.font_(Font("Cambria", 15));


// Menu
~menu = PopUpMenu(window,Rect(5.5*w/20, 11*h/20, 178, 20))
.items_(["","Overdrive","Distortion","Fuzz"])
.font_(Font("Cambria", 15))
.background_(Color.grey(0.7))
.visible_(false);

// Short Explanation
explanation = StaticText(window, Rect(13*w/20, 11*h/20, 6*w/20, 5*h/20))
.stringColor_(Color.white).background_(Color.new255(255, 141, 113,100)).font_(Font("Cambria",12)).align_(\center).visible_(false);
explanation.string = "Overdrive is a nearly linear effect for low signal levels that becomes progressively more nonlinear at high levels, distortion operates mainly in a nonlinear region for all input signals, and fuzz is a completely nonlinear effect that creates more drastic changes to the input waveform, resulting in a harder or harsher sound.";


//Teach Mode - Student
~teach = Button.new(window, Rect(11*w/20, 16*h/20, 2*w/20, h/20))
.states_([
	["Teach", Color.black,Color.gray(0.8)], // State 0
	["Teach", Color.white,Color.fromHexString("#3693D1")]]) //State 1
.action_({
	arg obj;
	if(obj.value == 1,{
		~learn.valueAction_(0).bounds_(Rect(2.5*w/20, 18.5*h/20, 2*w/20, h/20)); //Set Learn in state 0 and trigger its actions
		~teach.bounds_(Rect(15.5*w/20, 18.5*h/20, 2*w/20, h/20));
		text.visible = false;
		~menu.visible = false;

		~sineSound.states_([["Sine", Color.black,Color.gray(0.8)],
			["Piano", Color.white,Color.fromHexString("#3693D1")]]).visible_(true).action_({ arg butt; ~audioSel = butt.value; });

/*		~pianoSound.states_([["Piano", Color.black,Color.gray(0.8)],
			["Piano", Color.white,Color.fromHexString("#3693D1")]]).visible_(true).action_({arg butt; ~sineSound.value(); butt.value.postln});*/

		~playButt.states_([["Play", Color.black,Color.gray(0.8)],
			["Play", Color.white,Color.fromHexString("#3693D1")]]).value_(0).visible_(true);

		~ig_knob.bounds_(Rect(2*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(true); //change color
		~lpf_pre_knob.bounds_(Rect(5*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(true);
		~lpf_post_knob.visible_(true);
		~eq_freq_knob.visible_(true);
		~eq_magitud_knob.visible_(true);
		~eq_qfactor_knob.visible_(true);
		~ov_knob.bounds_(Rect(17*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(true);

		~ig_txtknob.bounds_(Rect(1.7*w/20, 14.5*h/20, 2*w/20, h/20)).visible_(true);
		~lpf_pre_txtknob.bounds_(Rect(4.7*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Pre").visible_(true);
		~ov_txtknob.bounds_(Rect(16.7*w/20, 14.7*h/20, 2*w/20, h/20)).visible_(true);
		~lpf_post_txtknob.visible_(true);
		~eq_freq_txtknob.visible_(true);
		~eq_magitud_txtknob.visible_(true);
		~eq_qfactor_txtknob.visible_(true);
		~rectification_txt.visible_(true);
		~symmetry_txt.visible_(true);
		~scopeView.bounds_(Rect(4*w/20, 3*h/20, 7*w/20, 4*h/20)).background_(Color.fromHexString("#3693D1")).visible_(true);
		~freqScopeView.bounds_(Rect(4*w/20, 8*h/20, 7*w/20, 4*h/20)).background_(Color.fromHexString("#3693D1")).visible_(true);
		~tfMode.visible_(true).valueAction_(0); //Default value of the TF button is None and trigger the action
		~trFunction.bounds_(Rect(12*w/20, 3*h/20, 7*w/20, 9*h/20)).visible_(true);
		~sig.value_(Array.series(100,-1, 2/100)); // default value of the TF plot is the diagonal
		~sig.domainSpecs =[-1, 1, \lin, 0, 0, "x"].asSpec;
		~rectification.visible_(true);

		window.drawFunc = { // Draw the blue squares//
			Pen.strokeColor = Color.fromHexString("#3693D1").alpha_(0.5);
			Pen.width = 3;
			Pen.strokeRect(Rect(4.6*w/20, 12.8*h/20, 4*w/20, 2.6*h/20));
			Pen.strokeRect(Rect(9.6*w/20, 12.8*h/20, 6*w/20, 2.6*h/20));
			Pen.strokeRect(Rect(3.7*w/20, 15.8*h/20, 3*w/20, 2.6*h/20));
			Pen.strokeRect(Rect(7.6*w/20, 15.8*h/20, 7*w/20, 2.6*h/20));
		};
		window.refresh; // refresh the window to set the new squares
	},
	{ // actions of the satate 0 of teach
		~learn.bounds_(Rect(6*w/20, 16*h/20, 2*w/20, h/20));
		~teach.bounds_(Rect(11*w/20, 16*h/20, 2*w/20, h/20));
		~sineSound.visible_(false); ~pianoSound.visible_(false);
		~playButt.visible_(false);
		~scopeView.visible_(false); ~freqScopeView.visible_(false); ~trFunction.visible_(false);
		~tfMode.visible_(false);
		~ig_knob.visible_(false);
		~lpf_pre_knob.visible_(false);
		~ov_knob.visible_(false);
		~lpf_post_knob.visible_(false);
		~eq_freq_knob.visible_(false);
		~eq_magitud_knob.visible_(false);
		~eq_qfactor_knob.visible_(false);
		~tf_qs_knob.visible_(false);
		~tf_q_knob.visible_(false);
		~tf_d_knob .visible_(false);
		~tfMode.visible_(false);
		~rectification.visible_(false);
		~ig_txtknob.visible_(false);
		~lpf_pre_txtknob.visible_(false);
		~ov_txtknob.visible_(false);
		~lpf_post_txtknob.visible_(false);
		~eq_freq_txtknob.visible_(false);
		~eq_magitud_txtknob.visible_(false);
		~eq_qfactor_txtknob.visible_(false);
		~tf_q_txtknob.visible_(false);
		~tf_d_txtknob.visible_(false);
		~rectification_txt.visible_(false);
		~symmetry_txt.visible_(false);
		text.visible_(true);

		window.drawFunc = {
			Pen.strokeColor = Color.white.alpha_(0.5);
			Pen.width = 3;
			Pen.strokeRect(Rect(4*w/20, 4*h/20, 12*w/20, 10*h/20));
		};
		window.refresh;
});}).font_(Font("Cambria", 15));


// Buttons

~rectification = Button.new(window, Rect(4*w/20, 16.5*h/20, 100, 20)) //Rectification mode button
.states_([["None", Color.black,Color.gray(0.8)],
	["Half", Color.white,Color.fromHexString("#41B2FD")],
	["Full", Color.white,Color.fromHexString("#2B73A4")]]).font_(Font("Cambria", 15)).visible_(false).action_({ arg butt; ~rectSelect = butt.value.postln; });

~tfMode = Button.new(window, Rect(8*w/20, 16.5*h/20, 100, 20)) //TF mode button
.states_([["None", Color.black,Color.gray(0.8)],["Symmetric", Color.white,Color.fromHexString("#41B2FD")],
	["Asymmetric ", Color.white,Color.fromHexString("#2B73A4")]])
.action_({ arg obj;

	~transSelect = obj.value;

	////////////////



	if(obj.value==0,{~tf_qs_knob.visible_(false);~tf_q_knob.visible_(false);~tf_d_knob .visible_(false);
				~tf_q_txtknob.visible_(false);~tf_d_txtknob.visible_(false);
		~sig.value = Array.series(100,-1, 2/100);
		~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;},
	{if(obj.value==1,{~tf_qs_knob.visible_(true);~tf_q_knob.visible_(false);~tf_d_knob .visible_(false);
		~tf_q_txtknob.visible_(true);~tf_d_txtknob.visible_(false);
		~sig.value = ~symmetric_distortion.value(x:Array.series(100,-1, 2/100),q:~qs_scale.map(~tf_qs_knob.value));
			~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;},
	{~tf_qs_knob.visible_(false);~tf_q_knob.visible_(true);~tf_d_knob .visible_(true);
		~tf_q_txtknob.visible_(true);~tf_d_txtknob.visible_(true);
		~sig.value = ~asymmetric_distortion.value(x:Array.series(100,-1, 2/100),q:~q_scale.map(~tf_q_knob.value),d:~d_scale.map(~tf_d_knob.value));
			~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;
})});}).font_(Font("Cambria", 15)).visible_(false);

~sineSound = Button.new(window, Rect(w/20, 6*h/20, 2*w/20, 20))
/*.action_({
	arg obj;
	if(obj.value == 1,{
		~pianoSound.valueAction_(0); // set Piano button in 0 and trigger the actions
	/*select Sine file*/},
	{~pianoSound.value_(1) /*Set value of piano in 1*/});})*/.font_(Font("Cambria", 15)).visible_(false);

~pianoSound = Button.new(window, Rect(w/20, 8*h/20, 2*w/20, 20))
.action_({
	arg obj;
	if(obj.value == 1,{
		~sineSound.valueAction_(0); // set Sine button in 0 and trigger the actions
	/*select piano file*/},
	{~sineSound.value_(1)});}).font_(Font("Cambria", 15)).visible_(false);


~playButt = Button.new(window, Rect(w/20, 12*h/20, 2*w/20, 20))
.action_({
	arg obj;
	if(obj.value == 1,{~main.value(); ~scopeView.start;  },
	{   ~scopeView.stop; z.free;   });}).font_(Font("Cambria", 15)).visible_(false);


// Knobs
~ig_knob = Knob(window, Rect(4*w/20, 13*h/20, 50, 50)).visible_(false).action_({|v,x,y,m| z.set(\inpGain, v.value);});
~ov_knob = Knob(window, Rect(10*w/20, 13*h/20, 50, 50)).visible_(false).action_({|v,x,y,m| z.set(\outGain, v.value);});

///////////////////
~freqMapper = ControlSpec.new(minval: 0, maxval: 5000, warp: 'lin', step: 1);

~lpf_pre_knob = Knob(window, Rect(4*w/20, 13*h/20, 50, 50)).visible_(false).action_({|v,x,y,m| z.set(\lpfFreq, ~freqMapper.map(v.value)); });
~lpf_post_knob = Knob(window, Rect(7*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false).action_({|v,x,y,m| z.set(\postLPFFreq, ~freqMapper.map(v.value)); });
~eq_freq_knob = Knob(window, Rect(10*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false).action_({|v,x,y,m| z.set(	\eqFreq, v.value *5000);});
~eq_magitud_knob = Knob(window, Rect(12*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false).action_({|v,x,y,m| z.set(\eqGain, (v.value*24-12)); });
~eq_qfactor_knob = Knob(window, Rect(14*w/20, 13*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false).action_({|v,x,y,m| z.set(\eqQue, (v.value));});
~qs_scale = [0,20,'linear',1].asSpec; // scale from 0 to 20 for symmetric q
~tf_qs_knob = Knob(window, Rect(11*w/20, 16*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false).action_({|v,x,y,m| z.set(\qSym, ~qs_scale.map(v.value)); ~sig.value = ~symmetric_distortion.value(x:Array.series(100,-1, 2/100),q:~qs_scale.map(v.value));~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;});
~q_scale = [-0.99,0,'linear',0.01].asSpec;
~tf_q_knob = Knob(window, Rect(11*w/20, 16*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false)
.action_({|v,x,y,m| z.set(\qAsym, ~q_scale.map(v.value)); ~sig.value = ~asymmetric_distortion.value(x:Array.series(100,-1, 2/100),q:~q_scale.map(v.value),d:~d_scale.map(~tf_d_knob.value));~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;});
~d_scale = [1,20,'linear',1].asSpec;
~tf_d_knob = Knob(window, Rect(13*w/20, 16*h/20, 50, 50)).background_(Color.fromHexString("#3693D1")).visible_(false)
.action_({|v,x,y,m| z.set(\dee, ~d_scale.map(v.value)); ~sig.value = ~asymmetric_distortion.value(x:Array.series(100,-1, 2/100),q:~q_scale.map(~tf_q_knob.value),d:~d_scale.map(v.value)); ~sig.domainSpecs=[-1, 1, \lin, 0, 0, "x"].asSpec;});





// Texts
~ig_txtknob = StaticText(window, Rect(2.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Input Gain").stringColor_(Color.white).
font_(Font("Cambria", 15)).align_(\center).visible_(false);
~lpf_pre_txtknob = StaticText(window, Rect(5.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Pre").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~lpf_post_txtknob = StaticText(window, Rect(6.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Post").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~ov_txtknob = StaticText(window, Rect(11.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Output Volume").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~eq_freq_txtknob = StaticText(window, Rect(9.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Frequency").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~eq_magitud_txtknob = StaticText(window, Rect(11.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Magnitud").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~eq_qfactor_txtknob = StaticText(window, Rect(13.6*w/20, 14.5*h/20, 2*w/20, h/20)).string_("Q Factor")
.stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~tf_q_txtknob = StaticText(window, Rect(10.6*w/20, 17.5*h/20, 2*w/20, h/20)).string_("q").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~tf_d_txtknob = StaticText(window, Rect(12.6*w/20, 17.5*h/20, 2*w/20, h/20)).string_("d").stringColor_(Color.white)
.font_(Font("Cambria", 15)).align_(\center).visible_(false);
~rectification_txt = StaticText(window, Rect(4.3*w/20, 17*h/20, 2*w/20, h/20)).string_("Rectification")
.stringColor_(Color.white).font_(Font("Cambria", 15)).align_(\center).visible_(false);
~symmetry_txt = StaticText(window, Rect(7.7*w/20, 17*h/20, 3*w/20, h/20)).string_("Transfer Function")
.stringColor_(Color.white).font_(Font("Cambria", 15)).align_(\center).visible_(false);


// Visualization of signal

//Scope of input and output, the same for both learn and tach mode
~scopeView = ScopeView(window,Rect(4*w/20, 4*h/20, 7*w/20, 4*h/20)).background_(Color.fromHexString("#ECF0F1")).visible_(false);
f = Buffer.alloc(s,1024,2);
b = Bus.audio(s,1);
~scopeView.bufnum = f.bufnum;
~scopeView.server=s;
~scopeView.start;
zoom ={	~scopeView.yZoom =([0.25, 10, \exp, 1/8, 1].asSpec.map(~slider.value));	};
// freq scope only available in teach mode
~freqScopeView = FreqScopeView( window,Rect(4*w/20, 8*h/20, 7*w/20, 6*h/20) );//.background_(Color.fromHexString("#ECF0F1")).visible_(false);
~freqScopeView.background_(Color.fromHexString("#ECF0F1")).visible_(false);
~freqScopeView.active_(true); // turn it on the first time;
~freqScopeView.freqMode_(1); // change to log scale so we can see them
~freqScopeView.inBus(b.index);
window.onClose_({ ~freqScopeView.kill }); // you must have this



a = SynthDef("monoscope", { arg bus, bufnum;
    var z;
    z = In.ar(bus, 1);

    ScopeOut2.ar(z, bufnum);
    Out.ar(0, z);
}).play(
    target: RootNode(s),
    args: [\bus, b.index, \bufnum, f.bufnum],
    addAction: \addToTail // make sure it goes after what you are scoping
);









// Transfer Function View
~trFunction = CompositeView(window, Rect(12*w/20, 4*h/20, 7*w/20, 6*h/20)).visible_(false);
~sig = Plotter.new("TF",parent:~trFunction);

window.drawFunc = {
			Pen.strokeColor = Color.white.alpha_(0.5);
			Pen.width = 3;
			Pen.strokeRect(Rect(4*w/20, 4*h/20, 12*w/20, 10*h/20));
		};

window.onClose = {~scopeView.stop; z.stop; b.free; f.free; Window.allWindows.do(_.close)}; // don't forget this




~readBuffer = {
	arg samples;
	~numframes = samples;
	d = Buffer.read(s,Platform.resourceDir +/+ "sounds/piano.wav",0,~numframes);
	"Buffer read!";
};



// DONE Select audio source

~audioSource = {
	arg selector = 0, freq;
	var signal;
	~readBuffer.value();
	signal = if (selector == 0, SinOsc.ar(freq), PlayBuf.ar(1, d, BufRateScale.kr(d), doneAction: Done.freeSelf, loop: 1.0));
	};





~eqGen ={
	arg inputSignal, freq, que, gain;
	var outputSignal;

	outputSignal = BPeakEQ.ar(inputSignal, freq, que, gain);
};



~lpfGen ={
	arg inputSignal, freq = 1000;
	var outputSignal;
	outputSignal = LPF.ar(inputSignal, freq);
};



~rectGen ={
	arg inputSignal, selector = 0;
	var outputSignal;

	outputSignal = switch(selector,
		0, inputSignal,
		1, (inputSignal + inputSignal.abs())/2,
		2, inputSignal.abs()
	);
};





~transF = {
	arg inputSignal, qSym = 8, qAsym = -0.002, dee = 16, selector = 0;
	var outputSignal;


	outputSignal = switch(selector,
		0, inputSignal,
		2, ~asymmetric_distortion.value(inputSignal, qAsym, dee),
		1, ~symmetric_distortion.value(inputSignal, qSym, dee)
	);

	outputSignal = LeakDC.ar(outputSignal);

};



~symmetric_distortion = {arg x, q; (x).sign*(1 - (-1*q*(x).abs).exp) };
~asymmetric_distortion = { arg x, q, d; ((x-q) / (1 - (-1*d*(x-q)).exp)) + (q / (1 - ( (d*q).exp) )) };
~createSynthDef = {
z = SynthDef(
    "master_",
    { arg freq = 110, eqFreq = 1200, eqQue = 1, eqGain = 12, lpfFreq = 1000, qSym = 8, qAsym = -0.002, dee = 16, audSelect = 0, postLPFFreq = 1000, inpGain = 1, outGain = 1;
		var sourceSig, outputSig, afterPreEQ, afterLPF, afterRect, afterTransF, afterPostEQ, afterLPF2;
		sourceSig = ~audioSource.value(~audioSel,freq); // piano sinus change, change online?

		sourceSig = sourceSig * inpGain; // input gain
        afterPreEQ = ~eqGen.value(sourceSig, eqFreq, eqQue, eqGain);
		afterLPF = ~lpfGen.value(afterPreEQ, lpfFreq);
		afterRect = ~rectGen.value(afterLPF, ~rectSelect); // how to change online?
		afterTransF = ~transF.value(afterRect, qSym, qAsym, dee, ~transSelect); // selector issues again
		afterPostEQ = ~eqGen.value(afterTransF, eqFreq, eqQue, -1 * eqGain);
		afterLPF2 = ~lpfGen.value(afterPostEQ, postLPFFreq);
		outputSig = afterLPF2 * outGain;
			{
   [1].do {
      |n|
      n.postln;
      1.wait;
   }
}.fork();
		Out.ar(b.index, outputSig);
			Out.ar([0,1], outputSig);

}).play;
};


~main = {
	var sourceSig, outputSig, afterPreEQ;
	~createSynthDef.value;

};

~audioSel = 0;
// 3 arguments (controls) with default values



)

z = Synth("master_", [\freq, 220, \beatFreq, 1, \mul, 0.1, \audioSel, 0.0]);