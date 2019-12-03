if (isOpen("ROI Manager"))
{
	selectWindow("ROI Manager");
	run("Close");
}
t=getTitle();
run("Invert");
run("Log3D", "imp="+getTitle()+" sigmax=5.0 sigmay=5.0 sigmaz=1.0");
//run("Log3D", "imp="+getTitle()+" sigmax=4.0 sigmay=4.0 sigmaz=1.0");
run("Find Maxima...", "noise=600 output=[Single Points]");
//run("Find Maxima...", "noise=800 output=[Single Points]");
makeRectangle(36, 1934, 200, 102);
setBackgroundColor(0, 0, 0);
run("Clear", "slice");
run("Select All");
proc=getTitle();
run("Analyze Particles...", "add");
selectWindow(t);
run("Invert");
roiManager("Show All");
//roiManager("Save", "/n/projects/smc/public/SMC/tensorflow/2HPF-ribosome/asdf.zip")
selectWindow(proc);
run("Find Maxima...", "noise=5 output=Count");

selectWindow(t);
roiManager("Show All");