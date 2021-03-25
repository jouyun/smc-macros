current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
open(current_file);
roiManager("reset");
t=getTitle();
if (indexOf(t, "0119")>-1)
{
	run("Multiply...", "value=2.5");
}
run("Make Composite");
//run("Channels Tool...");
Stack.setDisplayMode("grayscale");
run("Duplicate...", "title=AA duplicate channels=3");

//Find Circle
run("Grays");
run("Invert");
run("Duplicate...", "title=AAA");
/*run("32-bit");
run("Percentile Threshold", "percentile=30 snr=12");*/
run("Gaussian Blur...", "sigma=20");
//setThreshold(174.0000, 255.0000);
setThreshold(158.0000, 255.0000);
setOption("BlackBackground", true);
run("Convert to Mask");

rename("A");
run("Duplicate...", "title=B");

run("Fill Holes");

imageCalculator("Subtract create", "B","A");
selectWindow("Result of B");

run("Fill Holes");


run("Fill Holes");
run("Analyze Particles...", "size=1000000-Infinity show=[Count Masks]");
run("Mask Largest");
rename("CircleMask");
run("8-bit");
run("Analyze Particles...", "  show=Nothing add");

//Find worms
selectWindow(t);
selectWindow(t);
run("Duplicate...", "title=asdf duplicate");
run("Log", "stack");
run("Invert", "stack");
run("Subtract Background...", "rolling=100 stack");
run("Split Channels");
selectWindow("C3-asdf");
//run("Subtract...", "value=20");
imageCalculator("Multiply create 32-bit", "C1-asdf","C3-asdf");
run("Enhance Contrast", "saturated=0.35");
//return("");
setThreshold(550.0000, 44779.0000);
run("Convert to Mask");
roiManager("Select", 0);
run("Analyze Particles...", "size=500-Infinity show=Masks exclude");
run("Invert LUT");
run("Dilate");
run("Dilate");
run("Analyze Particles...", "size=500-Infinity exclude add");
selectWindow(t);
roiManager("Show All");

//Save
old = nResults;
roiManager("Deselect");
roiManager("Save", current_file+".zip");
roiManager("Select", 0);
roiManager("Delete");
roiManager("Measure");
new = nResults;
for (i=old; i<new; i++)
{
	setResult("Directory", i, current_file);
}
