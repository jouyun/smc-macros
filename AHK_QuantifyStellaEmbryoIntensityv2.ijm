t=getTitle();
run("Translate...", "x=0 y=-6 interpolation=None slice");

direc="/n/core/micro/mg2/ahk/smc/20180322_WID_AHK/AllData/";

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }

run("Duplicate...", "duplicate channels=1");
run("Invert");
run("Subtract Background...", "rolling=200");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
//run("Percentile Threshold", "percentile=30 snr=400");
setThreshold(80, 3.4e38);
run("Convert to Mask");

run("Watershed");
run("Analyze Particles...", "size=3000-50000 circularity=0.60-1.00 add");
selectWindow(t);
run("Subtract Background...", "rolling=200");
//roiManager("multi-measure measure_all append");
setSlice(2);
roiManager("Measure");




saveAs("Results", direc+t+".csv");
run("Clear Results");