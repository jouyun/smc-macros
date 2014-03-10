peak1_channel=2;
peak2_channel=3;
//peak3_channel=4;
DAPI_channel=1;

//Changed 20 to 10 09252013, J2 from 0805 bad
SNR_worm=8;
SNR_peaks1=300;
SNR_peaks2=200;
//SNR_peaks3=1000;


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

title=getTitle();
run("Max Project With Reference", "channels=3 frames=1");
selectWindow(title);
close();
selectWindow("Img");
rename(title);
setSlice(peak1_channel);
run("Duplicate...", "title=Peaks1 channels="+peak1_channel);
selectWindow(title);
setSlice(peak2_channel);
run("Duplicate...", "title=Peaks2 channels="+peak2_channel);
selectWindow(title);
/*setSlice(peak3_channel);
run("Duplicate...", "title=Peaks3 channels="+peak3_channel);*/
selectWindow(title);
setSlice(DAPI_channel);
run("Duplicate...", "title=DAPI channels="+DAPI_channel);
run("32-bit");
run("Percentile Threshold", "percentile=10 snr="+SNR_worm);

selectWindow(title);
close();
selectWindow("Result");
run("Fill Holes");
run("Open");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
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

	selectWindow("Peaks1");
	run("Smooth", "slice");
	roiManager("Select", 0);
	run("Measure");
	max=getResult("Max");
	min=getResult("Min");
	run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
	run("Dilate");
	rename("Spots1");
	run("16-bit");

	selectWindow("Peaks2");
	run("Smooth", "slice");
	roiManager("Select", 0);
	run("Measure");
	max=getResult("Max");
	min=getResult("Min");
	run("Find Maxima...", "noise="+SNR_peaks2+" output=[Single Points]");
	run("Dilate");
	rename("Spots2");
	run("16-bit");

	/*selectWindow("Peaks3");
	run("Smooth", "slice");
	roiManager("Select", 0);
	run("Measure");
	max=getResult("Max");
	min=getResult("Min");
	run("Find Maxima...", "noise="+SNR_peaks3+" output=[Single Points]");
	run("Dilate");
	rename("Spots3");
	run("16-bit");*/

	selectWindow("Mask");
	run("16-bit");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image6=[-- None --]");
	//run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image6=Peaks3 image7=Spots3 image8=[-- None --]");

	setSlice(3);
	run("Find Maxima...", "noise="+(100)+" output=Count");
	peak1_count=getResult("Count");
	setSlice(5);
	run("Find Maxima...", "noise="+(100)+" output=Count");
	peak2_count=getResult("Count");
	/*setSlice(7);
	run("Find Maxima...", "noise="+(100)+" output=Count");
	peak3_count=getResult("Count");*/
	
	run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
	Stack.setDisplayMode("grayscale");
	setSlice(1);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(2);
	setMinAndMax(41.2383, 800);
	setSlice(3);
	run("Enhance Contrast", "saturated=0.35");
	setSlice(4);
	setMinAndMax(41.2383, 800);
	setSlice(5);
	run("Enhance Contrast", "saturated=0.35");
	/*setSlice(6);
	setMinAndMax(41.2383, 800);
	setSlice(7);
	run("Enhance Contrast", "saturated=0.35");*/
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
	IJ.log(""+peak1_count+","+peak2_count+","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
	//IJ.log(""+peak1_count+","+peak2_count+","+peak3_count +","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
	logs=getInfo("log");
	saveAs("Tiff", current_file+"_mask.tif");
	close();
	return logs;
}
run("Close All");