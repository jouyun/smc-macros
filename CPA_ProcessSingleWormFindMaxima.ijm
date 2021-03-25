peak1_channel=2;
peak2_channel=2;
peak3_channel=2;
DAPI_channel=1;

//CPA 20160614
SNR_worm=3;
SNR_peaks1=2000;
SNR_peaks2=4000;
SNR_peaks3=8000;

current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
while (roiManager("count")>0)
{
	roiManager("Select", 0);
	roiManager("delete");
}
IJ.log(current_file);
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);

title=getTitle();

if (selectionType()==-1)
{
	run("Close All");
	return("");
}

roiManager("Add");
roiManager("Select", 0);	
roiManager("Deselect");
run("Select All");

setSlice(peak1_channel);
run("Duplicate...", "title=Peaks1 channels="+peak1_channel);
run("Median...", "radius=.5 stack");
run("32-bit");
selectWindow(title);
setSlice(peak2_channel);
run("Duplicate...", "title=Peaks2 channels="+peak2_channel);
run("Median...", "radius=.5 stack");
run("32-bit");
selectWindow(title);
setSlice(peak3_channel);
run("Duplicate...", "title=Peaks3 channels="+peak3_channel);
run("Median...", "radius=.5 stack");
run("32-bit");
selectWindow(title);
setSlice(DAPI_channel);
run("Duplicate...", "title=DAPI channels="+DAPI_channel);
run("8-bit");
roiManager("Select", 0);	
setForegroundColor(255, 255, 255);
run("Fill", "slice");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
roiManager("Deselect");
run("Select All");

selectWindow(title);
close();
selectWindow("DAPI");


run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");

rename("duh");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");



rename("Mask");

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
     run("Smooth", "slice");
     roiManager("Deselect");
     roiManager("Select", 0);
     run("Measure");
     max=getResult("Max");
     min=getResult("Min");

     selectWindow("Peaks1");
     run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
	 //run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");	 //Remove for no bad mask
     run("Dilate");
     rename("Spots1");
     run("32-bit");
     

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
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
	 //run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");	 //Remove for no bad mask
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
     //imageCalculator("Multiply 32-bit stack", getTitle(),"BadWashMask");  //Remove for no bad mask
	 //run("Find Maxima...", "noise="+SNR_peaks1+" output=[Single Points]");	 //Remove for no bad mask
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
     run("Close All");
     return logs;
}

