Stack.setDisplayMode("grayscale");
run("Enhance Contrast", "saturated=0.35");

t=getTitle();

if (isOpen("ROI Manager"))
{
     selectWindow("ROI Manager");
     run("Close");
}


roiManager("Show None");
roiManager("Show All");

run("Properties...", "channels=3 slices=1 frames=1 unit=µm pixel_width=0.16 pixel_height=0.16 voxel_depth=1.0000000");
run("Duplicate...", "title=A duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=2");
imageCalculator("Subtract create", "A","B");


run("Subtract Background...", "rolling=50");
run("Enhance Contrast", "saturated=0.35");
run("Duplicate...", "duplicate channels=1");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Li dark");
run("Convert to Mask");
//setOption("BlackBackground", true);
//run("Convert to Mask");

run("Fill Holes");
run("Watershed");
run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.16 pixel_height=0.16 voxel_depth=1.0000000");
run("Analyze Particles...", "size=39.38-393.82 add");

selectWindow("A");
close();
selectWindow("B");
close();
selectWindow("Result of A");
close();

selectWindow(t);
run("Duplicate...", "title=A duplicate channels=3");
/*selectWindow(t);
run("Duplicate...", "title=B duplicate channels=2");
run("Divide...", "value=3.000");
imageCalculator("Subtract create", "A","B");
selectWindow("A");
close();
selectWindow("B");
close();
selectWindow("Result of A");
run("Subtract Background...", "rolling=200");*/
run("Enhance Contrast", "saturated=0.35");
rename(t+"_processed");

roiManager("Show None");
roiManager("Show All");
roiManager("Measure");
run("Select All");
run("Measure");
//run("Close All");
