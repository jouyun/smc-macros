direc="U:\\smc\\public\\VPS\\Hdac8_Feulgen_Redo\\";
t=getTitle();

run("Duplicate...", "title=G duplicate channels=2");
selectWindow(t);
run("Duplicate...", "title=A duplicate channels=1");
imageCalculator("Subtract create", "A","G");
rename(t+"_processed");
setThreshold(17, 255);

/*run("Duplicate...", "title="+t+"_processed duplicate channels=2");
run("Invert");
run("Grays");
run("Gaussian Blur...", "sigma=1");
setThreshold(60, 255);*/

setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Extended Particle Analyzer", "area=225-Infinity pixel solidity=0.80-1.00 show=Masks redirect=None keep=None display add");

return("");

if (roiManager("count")>0) roiManager("Save", direc+t+".zip");
rois=roiManager("count");
for (i=0; i<rois; i++)
{
	roiManager("Select", 0);
	roiManager("Delete");
}

