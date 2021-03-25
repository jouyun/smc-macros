if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
setSlice(1);
t=getTitle();
run("Gaussian Blur...", "sigma=2 stack");
run("Subtract Background...", "rolling=150 stack");
run("32-bit");
run("Percentile Threshold", "percentile=50 snr=20");
run("Fill Holes");
rename(t+"_processed");

run("Analyze Particles...", "size=8000-42000 display add");
selectWindow(t);
ct=roiManager("Count");
for (i=0; i<ct; i++)
{
	roiManager("Select", i);
	run("Find Maxima...", "noise=100 output=Count");
}


