current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}

base_dir=File.getParent(current_file);
base_name=File.getName(current_file);
roi_name=base_dir+File.separator+"ROI_"+substring(base_name, 0, lengthOf(base_name)-4)+".zip";

open(current_file);
roiManager("reset");
open(roi_name);
num_ROIs=roiManager("Count");

Stack.setDisplayMode("grayscale");
run("Enhance Contrast", "saturated=0.35");

t=getTitle();

for (r=0; r<num_ROIs; r++)
{
	selectWindow(t);
	roiManager("Select", r);
	run("Duplicate...", "title="+t+r+".tif duplicate");
	tt=getTitle();

	run("Duplicate...", "title="+t+r+"A.tif duplicate channels=1");
	ttA=getTitle();
	run("Subtract Background...", "rolling=50");
	run("Clear Outside", "stack");
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
	run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.32 pixel_height=0.32 voxel_depth=1.0000000");
	roiManager("reset");
	run("Analyze Particles...", "size=34.38-393.82 add");
	
	selectWindow(ttA);
	close();
	
	selectWindow(tt);
	run("Duplicate...", "title="+t+"_"+r+"_B.tif duplicate channels=2");
	ttB=getTitle();
	run("Subtract Background...", "rolling=10");
	run("Clear Outside", "stack");
	run("Enhance Contrast", "saturated=0.35");
	rename(ttB+"_processed");
	
	roiManager("Show None");
	roiManager("Show All");
	roiManager("Measure");
	//run("Select All");
	//run("Measure");
	close();
	roiManager("reset");
	selectWindow(t);
	open(roi_name);
	selectWindow(t);
	//run("Close All");
}


