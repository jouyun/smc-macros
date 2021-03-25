t=getTitle();

if (isOpen("ROI Manager"))
{
     selectWindow("ROI Manager");
     run("Close");
}

/*
selectWindow("Image_006.tif");
run("Duplicate...", "title=AAA duplicate channels=1");
setAutoThreshold("Default dark");
//run("Threshold...");
//setThreshold(1, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=0-Inf circularity=0.80-1.00 add");
run("Analyze Particles...", "  circularity=0-1 add");
selectWindow("ROI Manager");
roiManager("Select", 70);
selectWindow("Image_006.tif");
roiManager("Select", 69);
roiManager("Select", 70);
run("Crop");
*/

run("Duplicate...", "title=B duplicate");
run("Invert");
run("Gaussian Blur...", "sigma=2");
run("Split Channels");
imageCalculator("Subtract create", "C3-B","C1-B");
rename("Subtract");
run("Gaussian Blur...", "sigma=7");
run("Invert");
run("32-bit");
run("Divide...", "value=255");
run("Log");
run("Multiply...", "value=-1");

//Using green to find nucleii
selectWindow(t);
run("Duplicate...", "duplicate channels=2");
run("Invert");
run("Gaussian Blur...", "sigma=7");
setAutoThreshold("Default dark");
setThreshold(51, 255);
run("Convert to Mask");
//run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=1500-20000 circularity=0.80-1.00 add");

//Using red to find nucleii
/*run("Duplicate...", "title=Mask");
setMinAndMax(-0.000000000, 0.500000000);
run("Grays");
run("8-bit");
setThreshold(12, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=1500-20000 circularity=0.80-1.00 add");*/

selectWindow("Subtract");
roiManager("Show All");
run("Grays");
setMinAndMax(0, 0.08);
rename(t);
selectWindow("ROI Manager");
roiManager("Measure");
