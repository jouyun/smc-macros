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
setThreshold(550.0000, 44779.0000);
run("Convert to Mask");
run("Analyze Particles...", "size=500-Infinity show=Masks exclude");
run("Invert LUT");
run("Dilate");
//run("Dilate");
run("Analyze Particles...", "size=500-Infinity exclude add");
selectWindow(t);
roiManager("Show All");

//Save
old = nResults;
roiManager("Deselect");
roiManager("Save", current_file+".zip");
roiManager("Measure");
new = nResults;
for (i=old; i<new; i++)
{
	setResult("Directory", i, current_file);
}
