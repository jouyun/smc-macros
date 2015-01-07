//Must have "SubtractedMask.tif" open as the Mask, image you want it to work on selected when running

name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}
t=getTitle();
for (i=0; i<190; i++)
{
	selectWindow(t);
	run("Duplicate...", "title=A"+(i+1)+" duplicate range="+(i+1)+"-"+(i+1));
	real_thing=getTitle();
	selectWindow("Subtracted_Mask.tif");
	run("Duplicate...", "title=B"+(i+1)+" duplicate range="+(i+1)+"-"+(i+1));
	closeme=getTitle();
	setBatchMode(false);
	run("Set Measurements...", "area mean standard min centroid center bounding fit feret's integrated display redirect=None decimal=3");
	run("Analyze Particles...", "size=25000-Infinity circularity=0.00-1.00 show=Nothing display");
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
	run("Rotate... ", "angle="+theta+" grid=1 interpolation=None stack");
	width=getWidth();
	height=getHeight();
	scale=1.2;
	selectWindow(closeme);

run("Translate...", "x="+tx+" y="+ty+" interpolation=None stack");
run("Rotate... ", "angle="+theta+" grid=1 interpolation=None stack");
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
selectWindow(closeme);

	close();

/*	if (width>scale*Major&&height>scale*Minor)
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
	}*/
}
return("");
waitForUser("Hold shift to flip");
if (isKeyDown("shift"))
{
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