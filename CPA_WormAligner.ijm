mask_channel=3;
run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated median area_fraction stack display redirect=None decimal=3");

real_thing=getTitle();
run("Duplicate...", "title=Mask duplicate channels="+mask_channel);

run("32-bit");
run("Percentile Threshold", "percentile=10 snr=15");
//setAutoThreshold("Default dark");
//setOption("BlackBackground", true);
//run("Convert to Mask");

mask_thing=getTitle();
setBatchMode(false);
run("Analyze Particles...", "size=2500-Infinity circularity=0.00-1.00 show=Nothing display");
x=getResult("XM", nResults-1);
y=getResult("YM",nResults-1);
theta=getResult("Angle", nResults-1);
Major=getResult("Major", nResults-1);
Minor=getResult("Minor", nResults-1);

width=getWidth();
height=getHeight();

tx=width/2-x;
ty=height/2-y;
selectWindow(real_thing);
run("Translate...", "x="+tx+" y="+ty+" interpolation=None stack");
IJ.log("Theta "+theta);
run("Rotate... ", "angle="+theta+" grid=1 interpolation=None enlarge stack");
width=getWidth();
height=getHeight();
scale=1.2;

run("Duplicate...", "title=SideMask duplicate channels="+mask_channel);
makeOval(width/2-Major/2, height/2-Minor/2, Major,Minor);
//run("Fill", "slice");
run("Invert");
makeOval(width/2-Major*1.1/2, height/2-Minor*1.1/2, Major*1.1,Minor*1.1);
run("Clear Outside");
makeRectangle(0, 0, width/2, height);
run("Measure");
makeRectangle(width/2, 0, width/2, height);
run("Measure");
left=getResult("IntDen", nResults-2);
right=getResult("IntDen", nResults-1);

IJ.log("Left:  "+left+" Right:  "+right);
if (right>left) 
{
	IJ.log("Head is on RIGHT!");
}
else 
{
	IJ.log("Head is on LEFT!");
	selectWindow(real_thing);
	run("Flip Horizontally", "stack");
}
selectWindow(real_thing);
width=getWidth();
height=getHeight();
makeRectangle(width/2-Major*1.1/2, height/2-Minor*1.1/2, Major*1.1,Minor*1.1);
run("Crop");

run("Scale...", "x=.25 y=.25 z=1.0 width=592 height=310 depth=3 interpolation=Bilinear average create");
run("Canvas Size...", "width=1000 height=400 position=Center zero");

//run("Scale...", "x=- y=- z=1.0 width=600 height=200 depth=5 interpolation=Bilinear average create");

/*makeOval(width/2-Major/2, height/2-Minor/2, Major,Minor);
run("Invert");
makeOval(width/2-Major*1.1/2, height/2-Minor*1.1/2, Major*1.1,Minor*1.1);
run("Clear Outside");
makeRectangle(0, 0, width/2, height);
run("Measure");
makeRectangle(width/2, 0, width/2, height);
run("Measure");
left=getResult("IntDen", nResults-2);
right=getResult("IntDen", nResults-1);

IJ.log("Left:  "+left+" Right:  "+right);
if (right>left) 
{
	IJ.log("Head is on RIGHT!");
}
else 
{
	IJ.log("Head is on LEFT!");
	selectWindow(real_thing);
	run("Flip Horizontally", "stack");
}
selectWindow(closeme);

	close();*/