peaks_channel=3;
worm_channel=1;

//Usual settings
SNR_peaks=30;
SNR_worm=4;
//Settings for Hanh 7-22-2013
SNR_peaks=50;
SNR_worm=10;


current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}

run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);
run("32-bit");
orig_title=getTitle();
run("Slice Keeper", "first="+peaks_channel+" last="+peaks_channel+" increment=1");
rename("Peaks");
selectWindow(orig_title);
run("Slice Keeper", "first="+worm_channel+" last="+worm_channel+" increment=1");
rename("DAPI");
selectWindow(orig_title);
close();
selectWindow("Peaks");
rename(orig_title);
selectWindow("DAPI");

run("32-bit");
run("Percentile Threshold", "percentile=15 snr="+SNR_worm);
run("Fill Holes");
run("Open");
rename("Bud");
selectWindow("DAPI");
close();
selectWindow("Bud");
rename("DAPI");
title=getTitle();
run("Set Measurements...", "area mean standard min centroid center fit integrated display redirect=None decimal=3");

run("Analyze Particles...", "size=10000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear");
run("Mask Largest");		
setAutoThreshold("Default dark");
run("Convert to Mask");
	
still_good=1;
if (nResults<1)
{
	still_good=0;
}
rename("Mask");
mask_title=getTitle();
selectWindow(title);
close();
selectWindow(orig_title);

if (still_good)
{
	run("Smooth");
	run("Subtract Background...", "rolling=10");
}
		
run("Percentile Threshold With Mask", "region="+mask_title+" percentile=30 snr="+SNR_peaks);
tmp_title=getTitle();
selectWindow(orig_title);
run("Duplicate...", "title=DAPI");
selectWindow(orig_title);
close();
run("Images to Stack", "name=Stack title=[] use");
		
		
run("Next Slice [>]");
run("Next Slice [>]");
run("Enhance Contrast", "saturated=0.35");
Stack.getDimensions(width, height, channels, slices, frames);
logs="";
if (channels*slices*frames==3&&(width>1024||height>1024)&&still_good)
{		
	print("\\Clear");
	run("Process Peaked Worm Mask", "number=100");
	logs=getInfo("log");
	/*comm=indexOf(logs,",");
	peaks=substring(logs,0,comm);
	area=substring(logs, comm+1,lengthOf(logs));
	print(f, worm_dir+","+ list[m]+","+peaks+","+ area);*/
}
if (still_good&&(width>1024||height>1024)) 
{
	saveAs("Tiff", current_file+"_mask.tif");
	close();
	return logs;
}
close();