name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}


setBatchMode(true);
run("Set Measurements...", "area mean standard min centroid center bounding fit feret's integrated display redirect=None decimal=3");
title=getTitle();
run("Duplicate...", "title=Worm3.tif_mask-1.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
x=getResult("XM", nResults-1);
y=getResult("YM",nResults-1);
theta=getResult("Angle", nResults-1);
Major=getResult("Major", nResults-1);
Minor=getResult("Minor", nResults-1);

width=getWidth();
height=getHeight();

tx=width/2-x;
ty=height/2-y;
close();
selectWindow(title);
run("Translate...", "x="+tx+" y="+ty+" interpolation=None stack");
run("Rotate... ", "angle="+theta+" grid=1 interpolation=None enlarge stack");
width=getWidth();
height=getHeight();
scale=1.2;
if (width>scale*Major&&height>scale*Minor)
{
	makeRectangle(width/2-Major*scale/2, height/2-Minor*scale/2, scale*Major, scale*Minor);
	run("Crop");
}


width=getWidth();
height=getHeight();
if (width%2>0)
{
	makeRectangle(0, 0, width-1, height);
	run("Crop");
}
if (height%2>0)
{
	makeRectangle(0, 0, width, height-1);
	run("Crop");
}
width=getWidth();
height=getHeight();

run("Duplicate...", "title=tmp");
setAutoThreshold("Default dark");
run("Convert to Mask");

makeOval(width/2-Major/2, height/2-Minor/2, Major,Minor);
//run("Fill", "slice");
run("Invert");
makeOval(width/2-Major*1.1/2, height/2-Minor*1.1/2, Major*1.1,Minor*1.1);
run("Clear Outside");
makeRectangle(0, 0, width/2, height);
run("Measure");
makeRectangle(width/2, 0, width/2, height);
run("Measure");
close();
selectWindow(title);
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
	selectWindow(title);
	run("Flip Horizontally", "stack");
}

run("Duplicate...", "title=A");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
selectWindow("A");
close();
selectWindow(title);
Stack.setSlice(4);
run("Duplicate...", "title=B");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
selectWindow("B");
close();
selectWindow(title);
Stack.setSlice(1);
close();