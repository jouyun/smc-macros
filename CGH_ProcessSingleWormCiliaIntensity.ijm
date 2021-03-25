//Assign channels

quantify_channel=1;
DAPI_channel=2;

//Choose thresholds
SNR_worm=15;

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
run("Properties...", "channels=2 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");

//Make mask from DAPI
run("Duplicate...", "title=DAPI duplicate channels="+DAPI_channel);
selectWindow("DAPI");
run("Duplicate...", "title=Multi");
selectWindow("Multi");
setAutoThreshold("Default dark");
setThreshold(1, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Invert");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Invert");
run("Divide...", "value=255");

selectWindow("DAPI");
run("Gaussian Blur...", "sigma=5 stack");
imageCalculator("Multiply", "DAPI","Multi");
run("32-bit");
run("Percentile Threshold", "percentile=30 snr="+SNR_worm);
run("Fill Holes");
run("Analyze Particles...", "  show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=10000-Infinity circularity=0.00-1.00 show=Nothing clear add");
rename("Mask");

selectWindow(t);
roiManager("Select", 0);
run("Measure");
print("\\Clear");
IJ.log(""+getResult("Mean",0)+","+0+","+getResult("Area",0)+",");
logs=getInfo("log");
saveAs("Tiff", current_file+"mask.tif");
run("Close All");
return logs;