//Assign channels

peak1_channel=1;
peak2_channel=2;
DAPI_channel=3;

//Choose thresholds
SNR_worm=2;
SNR_peaks1=2000;
SNR_peaks2=200;

//Clear out ROI Manager
if (isOpen("ROI Manager")) 
{
    selectWindow("ROI Manager");
     run("Close");
}

//Boilerplate file loading
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

t=getTitle();
run("Properties...", "channels=3 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");

//Make mask from DAPI
run("Duplicate...", "title=DAPI duplicate channels="+DAPI_channel);
selectWindow("DAPI");
//run("32-bit");
//run("Percentile Threshold", "percentile=30 snr="+SNR_worm);
//setOption("BlackBackground", true);
//For older data had to manually set threshold
//	setThreshold(113.0000, 3.4e38);
//	run("Convert to Mask");
//run("Erode");
waitForUser;
run("Fill Holes");
run("Distance Map");
setAutoThreshold("Default dark");
setThreshold(30, 255);
run("Convert to Mask");
run("Analyze Particles...", "  show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
rename("Mask");

//Separate out the Peaks images
selectWindow(t);
run("Duplicate...", "title=Peaks1 duplicate channels="+peak1_channel);
run("32-bit");
selectWindow(t);
run("Duplicate...", "title=Peaks2 duplicate channels="+peak2_channel);
run("32-bit");

//roiManager("Deselect");
//roiManager("Select", 0);
//close();

count=roiManager("Count");
if (count==0) return "";
IJ.log(count);

//Process Peaks1 
selectWindow("Peaks1");
roiManager("Select", 0);
roiManager("Deselect");
run("Smooth", "slice");
roiManager("Deselect");
roiManager("Select", 0);
run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
run("Dilate");
rename("Spots1");
run("32-bit");
     
//Process Peaks2
selectWindow("Peaks2");
roiManager("Select", 0);
roiManager("Deselect");
run("Smooth", "slice");
roiManager("Deselect");
roiManager("Select", 0);
run("Find Maxima...", "noise="+SNR_peaks2+" output=[Single Points]");
run("Dilate");
rename("Spots2");
run("32-bit");

//Concatenate Peaks with Mask
selectWindow("Mask");
run("32-bit");
run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image8=[-- None --]");

//Do spot counting
setSlice(3);
run("Find Maxima...", "noise="+(100)+" output=Count");
peak1_count=getResult("Count");
setSlice(5);
run("Find Maxima...", "noise="+(100)+" output=Count");
peak2_count=getResult("Count");
   
//Make it pretty for saving
run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
Stack.setDisplayMode("grayscale");
setSlice(1);
run("Enhance Contrast", "saturated=0.35");
setSlice(2);
setMinAndMax(0,3700);
setSlice(3);
run("Enhance Contrast", "saturated=0.35");
setSlice(4);
setMinAndMax(41.2383, 800);
setSlice(5);
run("Enhance Contrast", "saturated=0.35");
setSlice(1);
run("32-bit");

//Save the data
print("\\Clear");
IJ.log(""+peak1_count+","+peak2_count+","+getResult("Area",0)+",");
logs=getInfo("log");
run("Save As Tiff", "save=["+current_file+"_"+SNR_peaks1+"_"+SNR_peaks2+"_mask.tif"+"]");
close();
run("Close All");
return logs;
