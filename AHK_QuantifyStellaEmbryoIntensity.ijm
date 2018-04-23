t=getTitle();

direc="/n/core/micro/mg2/ahk/smc/20180126_WID_Electroporation/AllData/";

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }

run("Subtract Background...", "rolling=200");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
run("Percentile Threshold", "percentile=10 snr=100");
run("Watershed");
run("Analyze Particles...", "size=3000-50000 circularity=0.60-1.00 add");
selectWindow(t);
roiManager("multi-measure measure_all append");

saveAs("Results", direc+t+".csv");
run("Clear Results");