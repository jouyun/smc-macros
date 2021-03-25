run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated skewness stack limit display redirect=None decimal=3");

t=getTitle();
makeRectangle(1128, 939, 264, 101);

run("Duplicate...", " ");
run("8-bit");
run("Invert");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Dilate");
run("Dilate");
run("Erode");
run("Erode");
run("Properties...", "channels=1 slices=1 frames=1 unit=pix pixel_width=1 pixel_height=1 voxel_depth=1.0000000");
run("Analyze Particles...", "size=100-Infinity display");
close();
selectWindow(t);
res=nResults;
width=getResult("Width",res-1);
IJ.deleteRows(res-1,res-1);
run("Set Scale...", "distance="+width+" known=2.5 pixel=1 unit=mm");

run("Split Channels");
imageCalculator("Subtract create 32-bit", t+" (red)",t+" (blue)");
rename(t+"_processed");
setThreshold(0.7500, 255.0000);
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Erode");
run("Dilate");
run("Dilate");
run("Dilate");
run("Analyze Particles...", "size=1-Infinity display");
run("Close All");
