run("32-bit");
t=getTitle();
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=10 stack");
run("Subtract Background...", "rolling=100 create sliding stack");
rename("Background");
imageCalculator("Subtract create stack", t,"Background");
rename(t+"_processed");
/*run("Quantify ROI 3D", "z=1 channel=0 channel=0 channel=0");

nRois=roiManager("Count");
for (i=0; i<nRois; i++)
{
	roiManager("Select", 0);
	roiManager("Delete");
}
*/