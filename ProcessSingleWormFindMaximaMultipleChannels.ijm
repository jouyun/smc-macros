peak1_channel=2;
peak2_channel=2;
peak3_channel=2;
DAPI_channel=1;

//Changed 20 to 10 09252013, J2 from 0805 bad
//Changed for TIFF_20150202_1250screen
SNR_worm=8;
SNR_peaks1=400;
SNR_peaks2=200;
SNR_peaks3=200;

//Changed for 20150202_1250radscreen_7dpi
SNR_worm=8;
SNR_peaks1=800;
SNR_peaks2=800;
SNR_peaks3=100;

//Changed for LCC 20150406 Rapmycin
SNR_worm=8;
SNR_peaks1=50;
SNR_peaks2=40;
SNR_peaks3=25;

//Changed for LCC 20150406 tor
SNR_worm=8;
SNR_peaks1=30;
SNR_peaks2=100;
SNR_peaks3=100;

//Changed for KLE 20150502 tor
/*SNR_worm=8;
SNR_peaks1=100;
SNR_peaks2=400;
SNR_peaks3=200;*/

//Changed for KLE 20150508 tor
/*SNR_worm=6;
SNR_peaks1=150;
SNR_peaks2=180;
SNR_peaks3=400;*/

//Kai 20150622_Homeostasis
SNR_worm=8;
SNR_peaks1=100;
SNR_peaks2=200;
SNR_peaks3=300;

//Kai 20150622_Egfr3
SNR_worm=20;
SNR_peaks1=75;
SNR_peaks2=150;
SNR_peaks3=500;

//Kai 20150709_Egfr3
SNR_worm=10;
SNR_peaks1=400;
SNR_peaks2=900;
SNR_peaks3=1200;

//CPA 08172015
SNR_worm=8;
SNR_peaks1=400;
SNR_peaks2=100;
SNR_peaks3=1200;

//Kai TIFF_20151005_egfr3RNAseqHomeostasis
SNR_worm=8;
SNR_peaks1=100;
SNR_peaks2=100;
SNR_peaks3=1000;

//Kai TIFF_20151005_nrg7_2i_1250rads
SNR_worm=8;
SNR_peaks1=100;
SNR_peaks2=400;
SNR_peaks3=1000;

current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
IJ.log(current_file);
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);

//run("Slice Keeper", "first=1 last=64 increment=1");
title=getTitle();

run("Max Project With Reference", "channels=3 frames=1");
selectWindow(title);
close();
selectWindow("Img");
rename(title);

setSlice(peak1_channel);
run("Duplicate...", "title=Peaks1 channels="+peak1_channel);
run("32-bit");
selectWindow(title);
setSlice(peak2_channel);
run("Duplicate...", "title=Peaks2 channels="+peak2_channel);
run("32-bit");
selectWindow(title);
setSlice(peak3_channel);
run("Duplicate...", "title=Peaks3 channels="+peak3_channel);
run("32-bit");
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
run("Mask Middle");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
for (i=0; i<10; i++)
{
	run("Erode");
}
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
     roiManager("Deselect");
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
     roiManager("Select", 0);
     roiManager("Deselect");
     run("Smooth", "slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");

     selectWindow("Peaks1");
     run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
     run("Dilate");
     rename("Spots1");
     run("32-bit");
     //return("");
   

     selectWindow("Peaks2");
     roiManager("Select", 0);
     roiManager("Deselect");
     run("Smooth", "slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");
     run("Find Maxima...", "noise="+SNR_peaks2+" output=[Single Points]");
     run("Dilate");
     rename("Spots2");
     run("32-bit");

     selectWindow("Peaks3");
     roiManager("Select", 0);
     roiManager("Deselect");
     run("Smooth", "slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");
     run("Find Maxima...", "noise="+SNR_peaks3+" output=[Single Points]");
     run("Dilate");
     rename("Spots3");
     run("32-bit");

     selectWindow("Mask");
     run("32-bit");
     //run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image6=[-- None --]");
     run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image6=Peaks3 image7=Spots3 image8=[-- None --]");

     setSlice(3);
     run("Find Maxima...", "noise="+(100)+" output=Count");
     peak1_count=getResult("Count");
     setSlice(5);
     run("Find Maxima...", "noise="+(100)+" output=Count");
     peak2_count=getResult("Count");
     setSlice(7);
     run("Find Maxima...", "noise="+(100)+" output=Count");
     peak3_count=getResult("Count");
   
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
     setSlice(6);
     setMinAndMax(41.2383, 800);
     setSlice(7);
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
     //IJ.log(""+peak1_count+","+peak2_count+","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
     IJ.log(""+peak1_count+","+peak2_count+","+peak3_count +","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
     logs=getInfo("log");
     saveAs("Tiff", current_file+"_"+SNR_peaks1+"_"+SNR_peaks2+"_"+SNR_peaks3+"_mask.tif");
     close();
     return logs;
}
run("Close All");