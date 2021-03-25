setBatchMode(false);
t=getTitle();
run("Invert");

//Crop out the buffered region if it exists (ruins the blur/percentile threshold later if we don't)
run("Duplicate...", "title=Cropper duplicate channels=3");
setAutoThreshold("Default dark");
setThreshold(1.0000, 255.0000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=100000-Infinity add");
close("Cropper");
rois=roiManager("Count");
selectWindow(t);
roiManager("Select", rois-1);
run("Crop");

//Mask the worm
run("Duplicate...", "title=WormMask duplicate channels=3");
run("Gaussian Blur...", "sigma=10");
run("32-bit");
selectWindow("WormMask");
//return("");
run("Percentile Threshold", "percentile=30 snr=20");
run("Fill Holes");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Analyze Particles...", "size=3385804.94-Infinity add");
close("WormMask");

selectWindow(t);
run("Invert", "stack");
run("Split Channels");
imageCalculator("Add create 32-bit", "C2-"+t,"C3-"+t);
rename("Avg");
run("Divide...", "value=2");
imageCalculator("Subtract create 32-bit", "C1-"+t,"Avg");
rename("Red");

run("Duplicate...", "Tmp");
setThreshold(70.0000, 255.0000);
run("Convert to Mask");

//run("Percentile Threshold", "percentile=30 snr=100");

run("Divide...", "value=255");
rename("Mask1");
//run("Brightness/Contrast...");
imageCalculator("Multiply create 32-bit", "Red","Mask1");
rename(t+"_Red");
roiManager("Select", roiManager("Count")-1);
run("Measure");
//run("Close All");