SNR_peaks=12;
SNR_worm=12;

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
run("Analyze Particles...", "size=60000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
run("Duplicate...", "title=tmp");
print("\\Clear");
my_area=getResult("Area");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Analyze Particles...", "size=60000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
close();
selectWindow(title);
roiManager("Select", 0);
run("Find Maxima...", "noise="+SNR_peaks+" output=[Single Points]");
rename("Peaks");
run("32-bit");
run("Clear Results");
selectWindow(title);
run("Find Maxima...", "noise="+SNR_peaks+" output=Count");
IJ.log(""+getResult("Count")+","+my_area);
selectWindow("Mask");
run("32-bit");
run("Concatenate...", "  title=Results image1=Mask image2="+title+" image3=Peaks image4=[-- None --]");
saveAs("Tiff", current_file+"_mask.tif");
close();
logs=getInfo("log");
return logs;