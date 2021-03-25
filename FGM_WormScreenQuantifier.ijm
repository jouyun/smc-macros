run("Set Measurements...", "area mean min centroid center perimeter bounding fit shape integrated median stack display redirect=None decimal=3");

t=getTitle();
processed_title=t+"_processed.tif";
run("Duplicate...", "duplicate channels=1");
run("Subtract Background...", "rolling=50 stack");
rename("Piwi");

selectWindow(t);
run("Duplicate...", "title=DAPI duplicate channels=2");
run("32-bit");
run("Percentile Threshold", "percentile=20 snr=30");
run("Dilate");
run("Fill Holes");
run("Analyze Particles...", "size=100000-Infinity show=[Count Masks]");
run("Mask Largest");
setThreshold(129, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
rename("DAPIMask");
run("Analyze Particles...", "size=100000-Infinity add");
run("16-bit");
run("Multiply...", "value=255.000");

selectWindow("Piwi");
run("Duplicate...", "duplicate channels=1");
setAutoThreshold("Default dark");
setThreshold(35, 2000);
run("Convert to Mask", "method=Default background=Dark black");
run("16-bit");
run("Divide...", "value=255 stack");
rename("Mask");
imageCalculator("Multiply create 32-bit stack", "Piwi","Mask");
rename(processed_title);
run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
if (roiManager("Count")>0)
{
	roiManager("Select", 0);
	run("Measure");
	roiManager("Delete");
	setMinAndMax(0, 65535);
	run("16-bit");
	run("Merge Channels...", "c1=DAPIMask c2="+processed_title+" create");
	selectWindow("Composite");
	rename(processed_title);
}


