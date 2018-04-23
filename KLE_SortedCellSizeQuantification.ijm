mask_channel=3;
piwi_channel=4;

t=getTitle();
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }

selectWindow(t);
run("Duplicate...", "duplicate channels="+mask_channel);
run("Gaussian Blur...", "sigma=1.50");
run("Subtract Background...", "rolling=50");
run("32-bit");

run("Select All");
run("Measure");
intensity=parseFloat(getResult("StdDev", nResults-1));

return("");

IJ.log("Intensity: "+intensity);
if (intensity<950)
{
	//For very dim ones
	run("Percentile Threshold", "percentile=50 snr=8");
	run("Analyze Particles...", "size=200-4000 circularity=0.50-1.00 show=Masks");
	run("Invert LUT");
	run("Fill Holes");
	run("Watershed");
	run("Analyze Particles...", "size=200-2000 circularity=0.50-1.00 show=Nothing add");
}
else
{

	//For reasonably bright ones
	//run("Percentile Threshold", "percentile=50 snr=1000");
	run("Percentile Threshold", "percentile=50 snr=100");
	run("Watershed");
	run("Analyze Particles...", "size=200-2000 circularity=0.50-1.00 show=Nothing add");
}
selectWindow(t);
Stack.setChannel(piwi_channel);
roiManager("Show All");
roiManager("Measure");
