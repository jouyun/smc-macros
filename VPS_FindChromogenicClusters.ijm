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
t=getTitle();
run("Duplicate...", "duplicate channels=1");
roiManager("reset");
run("Grays");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
run("Divide...", "value=255.000");
run("Add...", "value=0.001");
run("Log");
run("Multiply...", "value=-1");
run("Enhance Contrast", "saturated=0.35");

//setThreshold(1.5156, 1000000000000000000000000000000.0000);
setThreshold(1.25156, 1000000000000000000000000000000.0000);
run("Convert to Mask");

//run("Analyze Particles...", "size=10-Infinity pixel add");
//selectWindow(t);
//roiManager("Show All");

run("Analyze Particles...", "size=10-Infinity pixel show=Masks");
run("Invert LUT");
run("Find Maxima...", "prominence=200 output=[Single Points]");
run("Divide...", "value=255.000");
rename(t+"_processed");

roi_file=substring(current_file, 0, lengthOf(current_file)-4)+"_RoiSet.zip";
open(roi_file);
count=roiManager("count");

for (i=0; i<count; i++)
{
	roiManager("select", i);
	roiManager("Measure");
}
