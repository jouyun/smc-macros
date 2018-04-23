t=getTitle();

run("Duplicate...", "title=A duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=2");
imageCalculator("Subtract create", "A","B");
setMinAndMax(0, 255);
run("Invert");

proc=t+"_processed";
rename(proc);
direc="/n/core/micro/jeg/vps/smc/20180116_OSS_Feulgen/SubImages/Tiffs/";

run("32-bit");
run("Divide...", "value=255");
run("Log");
run("Multiply...", "value=-1");
run("Properties...", "channels=1 slices=1 frames=1 unit=pixels pixel_width=1 pixel_height=1 voxel_depth=1.0000000");
run("Enhance Contrast", "saturated=0.35");
run("Grays");

run("Duplicate...", "title=Threshold");
run("Gaussian Blur...", "sigma=1");
//setThreshold(0.0213, 1);
setThreshold(0.1, 1);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Erode");

run("Extended Particle Analyzer", "area=100-Infinity pixel solidity=0.75-1.00 show=Masks redirect=None keep=None add");
selectWindow(proc);

roiManager("Measure");
if (roiManager("count")>0) roiManager("Save", direc+t+".zip");
rois=roiManager("count");
for (i=0; i<rois; i++)
{
	roiManager("Select", 0);
	roiManager("Delete");
}
saveAs("Results", direc+t+".csv");
run("Clear Results");