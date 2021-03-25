t=getTitle();
run("Z Project...", "projection=[Max Intensity]");
run("Gaussian Blur...", "sigma=1.50 stack");
run("Subtract Background...", "rolling=50 stack");
run("32-bit");
rename(t+"ZProj");
run("Duplicate...", "duplicate channels=3");

run("Percentile Threshold", "percentile=40 snr=100");
run("Watershed");
run("Analyze Particles...", "size=200-1800 add");
selectWindow(t+"ZProj");
setSlice(4);
roiManager("Measure");

if (isOpen("ROI Manager")) 
{
     selectWindow("ROI Manager");
     run("Close");
}