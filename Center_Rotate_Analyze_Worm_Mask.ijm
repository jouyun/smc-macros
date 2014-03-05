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
t=getTitle();
makeRectangle(0, 0, width/2, height);
run("Copy");
newImage("Left", "8-bit Black", width, height, 1);
makeRectangle(0, 0, width/2, height);
run("Paste");
run("Select All");
run("Flip Horizontally");
makeRectangle(0, 0, width/2, height);
run("Paste");
run("Select All");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=150000-Infinity circularity=0.00-1.00 show=Nothing display");
left=getResult("Minor", nResults-1);
leftM=getResult("Major", nResults-1);
leftX=getResult("X", nResults-1);
leftY=getResult("Y", nResults-1);
makeOval(leftX-leftM/2, leftY-left/2, leftM, left);
setForegroundColor(255, 255, 255);
run("Fill", "slice");
run("Select All");
run("Measure");

selectWindow(t);
makeRectangle(width/2, 0, width/2, height);
run("Copy");
newImage("Right", "8-bit Black", width, height, 1);
makeRectangle(width/2, 0, width/2, height);
run("Paste");
run("Select All");
run("Flip Horizontally");
makeRectangle(width/2, 0, width/2, height);
run("Paste");
run("Select All");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=150000-Infinity circularity=0.00-1.00 show=Nothing display");
right=getResult("Minor", nResults-1);
rightM=getResult("Major", nResults-1);
rightX=getResult("X", nResults-1);
rightY=getResult("Y", nResults-1);
makeOval(rightX-rightM/2, rightY-right/2, rightM, right);
selectWindow("Right");
setForegroundColor(255, 255, 255);
run("Fill", "slice");
run("Select All");
run("Measure");

//Have made ovals, now fill in ovals and find how much is outside of them

left=getResult("IntDen", nResults-3);
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
selectWindow(t);
close();
selectWindow("Left");
close();
selectWindow("Right");
close();
selectWindow(title);
run("Duplicate...", "title=A");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
selectWindow("A");
close();
selectWindow(title);
run("Next Slice [>]");
run("Next Slice [>]");
run("Next Slice [>]");
run("Duplicate...", "title=B");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display");
selectWindow("B");
close();
selectWindow(title);
Stack.setSlice(1);
close();