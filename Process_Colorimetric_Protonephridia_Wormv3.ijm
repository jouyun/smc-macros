SNR_protos=33;
SNR_worm=10;
//setBatchMode(true);
current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite");
open(current_file);
title=getTitle();
run("Invert");
run("32-bit");
run("Duplicate...", "title=tmp");
run("Smooth");
run("Subtract Background...", "rolling=800");
run("Percentile Threshold", "percentile=10 snr="+SNR_worm);
run("Fill Holes");
rename("Mask");
selectWindow("tmp");
close();
selectWindow("Mask");
rename("Premask");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
rename("Mask");
selectWindow("Premask");
close();
selectWindow("Mask");
run("Analyze Particles...", "size=60000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
print("\\Clear");
my_area=getResult("Area");


selectWindow(title);
//run("Subtract Background...", "rolling=50");
run("Smooth");

/*Attempt A*/
run("Enhance Local Contrast (CLAHE)", "blocksize=49 histogram=256 maximum=4 mask=Mask");
roiManager("Select", 0);
run("Find Maxima...", "noise=10 output=[Point Selection]");
run("Level Sets", "method=[Active Contours] use_fast_marching use_level_sets grey_value_threshold=35 distance_threshold=0.50 advection=2.20 propagation=1 curvature=1 grayscale=30 convergence=0.0050 region=outside");
run("Invert");
roiManager("Show All with labels");
roiManager("Show All");
run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
rename("Peaks");
selectWindow("Segmentation progress of "+title);
close();
selectWindow("Segmentation of "+title);
close();
/*
selectWindow(title);
roiManager("Select", 0);
run("Find Maxima...", "noise=30 output=[Single Points]");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear add");
close();
selectWindow(title);
roiManager("Select", 0);
roiManager("Select", 0);
run("Level Sets", "method=[Active Contours] use_fast_marching grey_value_threshold=40 distance_threshold=0.50 advection=2.20 propagation=1 curvature=1 grayscale=30 convergence=0.0050 region=outside");
rename("A");
selectWindow("Segmentation progress of "+title);
close();
selectWindow("A");
for (i=0; i<nResults; i++)
{
	selectWindow(title);
	roiManager("Select", i);
	run("Level Sets", "method=[Active Contours] use_fast_marching grey_value_threshold=10 distance_threshold=0.50 advection=2.20 propagation=1 curvature=1 grayscale=30 convergence=0.0050 region=outside");
	rename("B");
	selectWindow("Segmentation progress of "+title);
	close();
	imageCalculator("Min", "A","B");
	close("B");
}
selectWindow("A");
run("Invert");
run("Analyze Particles...", "size=10-Infinity pixel circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
rename("Peaks");
close("A");*/

number_pros=nResults;
avg_pro=0;
for (i=0; i<nResults; i++)
{
	avg_pro=avg_pro+getResult("Area", i);
}
avg_pro=avg_pro/number_pros;
selectWindow("Peaks");
run("32-bit");
selectWindow("Mask");
run("32-bit");

run("Concatenate...", "  title=Results image1=Mask image2="+title+" image3=Peaks image4=[-- None --]");
saveAs("Tiff", current_file+"_"+SNR_protos+"_smooth_mask.tif");
close();
print("\\Clear");
IJ.log(""+number_pros+","+avg_pro+","+my_area);
logs=getInfo("log");
return logs;