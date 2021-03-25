measure_channel=2;
peak1_channel=1;
DAPI_channel=3;



//Kai TIFF_20151005_nrg7_2i_1250rads
SNR_worm=20;
SNR_peaks1=140;



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
run("Z Project...", "projection=[Max Intensity]");
Stack.getDimensions(width, height, channels, slices, frames);
run("Properties...", "channels="+channels+" slices="+slices+" frames="+frames+" unit=micron pixel_width=1 pixel_height=1 voxel_depth=1");
if (channels==4)
{
	run("Delete Slice", "delete=channel");
	IJ.log("I AM HERE");

}

//run("Slice Keeper", "first=1 last=64 increment=1");
title=getTitle();
IJ.log(title);
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




setSlice(peak1_channel);
run("Duplicate...", "title=Peaks1 channels="+peak1_channel);
run("Median...", "radius=.5 stack");
selectWindow("Peaks1");
run("32-bit");

selectWindow(title);
setSlice(measure_channel);
run("Duplicate...", "title=Measure1 channels="+measure_channel);
run("Subtract Background...", "rolling=500");
run("32-bit");

selectWindow(title);
setSlice(DAPI_channel);
run("Duplicate...", "title=DAPI channels="+DAPI_channel);
run("32-bit");
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
//run("Erode");
//run("Erode");
//run("Erode");
//run("Erode");

run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");


rename("duh");
run("Mask Largest");

setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");

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
	//***************MEASURE PEAKS*******************
     selectWindow("Peaks1");
     roiManager("Select", 0);
     roiManager("Deselect");
     run("Gaussian Blur...", "sigma=1 slice");

     selectWindow("Peaks1");
     run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
	 //run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");	 //Remove for no bad mask
     run("Dilate");
     rename("Spots1");
     run("32-bit");

     selectWindow("Measure1");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     measure=getResult("Mean");
     area=getResult("Area");
     

     selectWindow("Mask");
     run("32-bit");
     //run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Peaks2 image5=Spots2 image6=[-- None --]");
     run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=Peaks1 image3=Spots1 image4=Measure1 image5=[-- None --]");

     setSlice(3);
     run("Find Maxima...", "noise="+(100)+" output=Count");
     peak1_count=getResult("Count");
     tt=getTitle();
   
     run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
     selectWindow(tt);
     Stack.setDisplayMode("grayscale");
     setSlice(1);
     run("Enhance Contrast", "saturated=0.35");
     setSlice(2);
     setMinAndMax(2088.95, 2620.96);
     setSlice(3);
     run("Enhance Contrast", "saturated=0.35");
     setSlice(4);
     setMinAndMax(72, 5550);
     setSlice(1);
     run("32-bit");
}
else
{
     run("Close All");
     return "";
}
Stack.getDimensions(width, height, channels, slices, frames);

if (still_good&&(width>500||height>500))
{
     print("\\Clear");
     //IJ.log(""+peak1_count+","+peak2_count+","+getResult("Area",2)+","+max+","+min+","+Dmax+","+Dmin);
     IJ.log(""+peak1_count+","+area+","+measure);
     logs=getInfo("log");
     run("Save As Tiff", "save="+current_file+"_"+SNR_peaks1+"_mask.tif");
     close();
     run("Close All");
     return logs;
}

