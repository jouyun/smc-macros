name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}


setBatchMode(false);
run("Set Measurements...", "area mean standard min centroid center bounding fit feret's integrated display redirect=None decimal=3");
title=getTitle();
run("Duplicate...", "title=Worm3.tif_mask-1.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=1000000-Infinity circularity=0.00-1.00 show=Nothing display");
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
run("Translate...", "x="+tx+" y="+ty+" interpolation=Bilinear enlarge stack");
run("Rotate... ", "angle="+theta+" grid=1 interpolation=Bilinear enlarge stack");
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

final_desired_width=1000;
width=getWidth();
height=getHeight();
run("Scale...", "x=- y=- width="+final_desired_width+" height="+floor(final_desired_width/width*height)+" interpolation=Bilinear average create title=Worm2.tif_max_project-2.tiff");

Stack.setSlice(1);
run("Duplicate...", "title=B");

run("Grays");
run("Find Maxima...", "noise=100 output=List");

setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
selectWindow("B");
close();
selectWindow(title);
Stack.setSlice(1);
close();