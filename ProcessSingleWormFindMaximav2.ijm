peak_channel=2;
DAPI_channel=3;

//Changed 20 to 10 09252013, J2 from 0805 bad
SNR_worm=3;
SNR_peaks=7;
//08052013 Hanh did 120, she said she wanted to avoid the dimmer spots so switched to 700


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
run("Select All");

title=getTitle();
//run("Median...", "radius=4 stack");
run("Gaussian Blur...", "sigma=2 stack");
/*run("Z Project...", "projection=[Max Intensity]");
tt=getTitle();
selectWindow(title);
close();
selectWindow(tt);
rename(title);*/

setSlice(peak_channel);
run("Duplicate...", "title=Peaks channels="+peak_channel);
selectWindow(title);
setSlice(DAPI_channel);
run("Duplicate...", "title=DAPI channels="+DAPI_channel);

run("32-bit");
run("Percentile Threshold", "percentile=30 snr="+SNR_worm);

selectWindow(title);
close();
selectWindow("Result");
run("Fill Holes");
run("Open");
for (i=0; i<0; i++)
{
	run("Erode");
}

run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
//run("Mask Middle");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
rename("Mask");
selectWindow("Result");
close();
selectWindow("Mask");


run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
still_good=0;
if (nResults>0) still_good=1;
rename("Mask");
selectWindow("DAPI");

if (still_good>0) 
{
	roiManager("Select", 0);
	run("Measure");
	Dmax=getResult("Max");
	Dmin=getResult("Min");
	close();
	max=0;
	min=0;
	IJ.log("results:  "+nResults);
	still_good=1;
	
	selectWindow("Peaks");
	//run("Median...", "radius=2 slice");
	roiManager("Select", 0);
	run("Measure");
	max=getResult("Max");
	min=getResult("Min");
	selectWindow("Peaks");
	//adjusted_SNR_peaks=(getResult("Max")-getResult("Min"))/3800*SNR_peaks;
	run("Find Maxima...", "noise="+SNR_peaks+" output=[Single Points]");
	
	run("Dilate");
	rename("Spots");
	run("16-bit");
	selectWindow("Peaks");
	run("16-bit");
	selectWindow("Mask");
	run("16-bit");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks image3=Spots image4=[-- None --]");
	setSlice(3);

	run("Find Maxima...", "noise="+(100)+" output=Count");
	
	IJ.log("Counted:  "+ getResult("Count"));
	
	run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
	Stack.setDisplayMode("grayscale");
	setSlice(1);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(2);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(3);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(1);
	run("32-bit");
}
else
{
	close();
}
Stack.getDimensions(width, height, channels, slices, frames);
if (still_good&&(width>1024||height>1024)) 
{
	print("\\Clear");
	IJ.log(""+getResult("Count",3) +","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
	logs=getInfo("log");
	saveAs("Tiff", current_file+"_"+SNR_peaks+"mask.tif");
	close();
	return logs;
}
run("Close All");
