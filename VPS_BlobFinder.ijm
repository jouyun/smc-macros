
direc='U:\\smc\\public\\VPS\\Hdac8_PAS_Redo\\Marked\\';
t=getTitle();
roiManager("Add");
roiManager("Select", 0);
roiManager("Deselect");
run("Select All");
//run("Gaussian Blur...", "sigma=4");
run("Make Composite");
run("Duplicate...", "title=G duplicate channels=2");
rename(t+"_processed");
run("Invert");
return("");
run("Maximum...", "radius=4");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(225, 255);
run("Convert to Mask");
run("Dilate");
run("Fill Holes");
run("Erode");
roiManager("Select",0);
run("Measure");
setResult("Label",nResults-1,getTitle());
run("Clear Outside");
run("Select All");
setThreshold(129, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=500.00-Infinity display add");

run("Analyze Particles...", "size=500-Infinity display add");
roiManager("Save", direc+t+"_Sub.zip");
rois=roiManager("count");
for (i=0; i<rois; i++)
{
	roiManager("Select", 0);
	roiManager("Delete");
}

