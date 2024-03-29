peak1_channel=1;
peak2_channel=1;
peak3_channel=1;
DAPI_channel=2;



//Kai TIFF_20151005_nrg7_2i_1250rads
SNR_worm=2;
SNR_peaks1=120;
SNR_peaks2=500;
SNR_peaks3=800;
//channel 2 H3P 200

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
Stack.getDimensions(width, height, channels, slices, frames);
t = getTitle();
run("Z Project...", "stop="+(slices-1)+" projection=[Max Intensity]");
rename("MAX");
selectWindow(t);
run("Duplicate...", "title=DAPI duplicate range="+slices);
run("Merge Channels...", "c1=MAX c2=DAPI create");
//run("Channels Tool...");
Stack.setDisplayMode("grayscale");
rename("tmp");
selectWindow(t);
close();
selectWindow("tmp");
rename(t);
run("Hyperstack to Stack");

Stack.getDimensions(width, height, channels, slices, frames);
run("Properties...", "channels="+channels+" slices=1 frames=1 unit=micron pixel_width=1 pixel_height=1 voxel_depth=1");

//run("Slice Keeper", "first=1 last=64 increment=1");
title=getTitle();
//run("Max Project With Reference", "channels=4 frames=1");
/*run("Scale...", "x=.5 y=.5 z=1.0 width=1827 height=1022 depth=3 interpolation=Bilinear average create");
rename("Img");
selectWindow(title);
close();
selectWindow("Img");
rename(title);*/


/*To get rid of large borders when the peaks are also in the border
*
*/
/*setSlice(3);
run("Duplicate...", "title=BadEdges channels=3");
run("32-bit");

run("Percentile Threshold", "percentile=30 snr=120");

run("Analyze Particles...", "size=10000-Infinity show=Masks display clear");
run("Invert");
run("Divide...", "value=255");
rename("BadWashMask");
selectWindow("BadEdges");
close();
selectWindow("Result");
close();
selectWindow(title);*/
//***********END BORDER REMOVAL*******************




/*setSlice(peak1_channel);
run("Duplicate...", "title=Peaks1 channels="+peak1_channel);
run("Median...", "radius=1.5 stack");
run("32-bit");*/

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
run("Duplicate...", "title=DAPI duplicate range=2");
run("32-bit");
run("Gaussian Blur...", "sigma=10 slice");
run("Percentile Threshold", "percentile=30 snr="+SNR_worm);


selectWindow(title);
close();
selectWindow("Result");

//run("Dilate");
//run("Dilate");
//run("Dilate");
//run("Dilate");
run("Fill Holes");
run("Open");

run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");


rename("duh");
run("Mask Largest");

setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");


//Alternative Border Removal
run("Invert");
run("Distance Transform 3D");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(50.0000, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask");
//End Alternative Border Removal

for (i=0; i<0; i++)
{
    run("Erode");
}
rename("Mask");
selectWindow("Result");
close();
selectWindow("Mask");

run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
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
     run("Gaussian Blur...", "sigma=1 slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");

     selectWindow("Peaks1");
     run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
     //run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");     //Remove for no bad mask
     run("Dilate");
     rename("Spots1");
     run("32-bit");


     selectWindow("Peaks2");
     roiManager("Select", 0);
     roiManager("Deselect");
     //run("Gaussian Blur...", "sigma=2 slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");
     run("Find Maxima...", "noise="+SNR_peaks2+" output=[Single Points]");
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
     //run("Find Maxima...", "noise="+SNR_peaks2+" output=[Single Points]");     //Remove for no bad mask
     run("Dilate");
     rename("Spots2");
     run("32-bit");

     selectWindow("Peaks3");
     roiManager("Select", 0);
     roiManager("Deselect");
     run("Gaussian Blur...", "sigma=2 slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");
     run("Find Maxima...", "noise="+SNR_peaks3+" output=[Single Points]");
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
     //run("Find Maxima...", "noise="+SNR_peaks3+" output=[Single Points]");     //Remove for no bad mask
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
     run("Close All");
     return "";
}
Stack.getDimensions(width, height, channels, slices, frames);

if (still_good&&(width>1024||height>1024))
{
     print("\\Clear");
     //IJ.log(""+peak1_count+","+peak2_count+","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
     IJ.log(""+peak1_count+","+peak2_count+","+peak3_count +","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
     logs=getInfo("log");
     run("Save As Tiff", "save="+current_file+"_"+SNR_peaks1+"_"+SNR_peaks2+"_"+SNR_peaks3+"_mask.tif");
     close();
     run("Close All");
     return logs;
}