root_directory="C:\\Data\\MAR Spectral\\Neuromasts_in_time\\";
//root_directory=getDirectory("image")+"\\";
Stack.getPosition(channel, slice, frame);
Stack.getDimensions(width, height, channels, slices, frames);
roiManager("reset");
roiManager("Add");
title=getTitle();

run("32-bit");
run("Reduce Dimensionality...", "  slices keep");
rename("Original");

spectra_file=root_directory+substring(title, 0, indexOf(title, "unmixed"))+"espectra.lsm.tif";
IJ.log(spectra_file);
open(spectra_file);
rename("SpectralMask");
roiManager("Select", 0);
Stack.setSlice(slice);
run("ApplyDotProduct ", "target=SpectralMask");
rename("Mask");

roiManager("Select", 0);
Stack.setSlice(slice);
run("Set Measurements...", "area mean standard min centroid center fit integrated redirect=None decimal=3");
run("Measure");
low=getResult("Min", nResults-1);
high=getResult("Max", nResults-1);
setThreshold(0.0*(high-low)+low, 65536);
IJ.log("Low threshold:  " + low); 
//setThreshold(950, 65536);
//setThreshold(983, 65536);

run("Convert to Mask", "  black");
run("Fill Holes", "stack");
run("Erode", "stack");
run("Dilate", "stack");
run("Watershed", "stack");

run("Analyze Particles...", "size=0-1500 circularity=0.00-1.00 show=Masks exclude stack");
selectWindow("Mask");
close();
selectWindow("Mask of Mask");
rename("Mask");

roiManager("Select", 0);
Stack.setSlice(slice);
run("seeded region grow 3D watershed");
rename("Single");
run("Dilate", "stack");
run("Dilate", "stack");
selectWindow("Mask");
close();
selectWindow("Single");
run("Divide...", "value=255 stack");
imageCalculator("Multiply create 32-bit stack", "Original","Single");
rename("Mult");
selectWindow("Original");
run("32-bit");
imageCalculator("Add create 32-bit stack", "Original","Mult");
rename("Sum");
selectWindow("Single");
close();
selectWindow("Original");
close();
selectWindow("Sum");
Stack.setSlice(slice);
run("Enhance Contrast", "saturated=0.35");
selectWindow("Mult");
Stack.setSlice(slice);
run("Enhance Contrast", "saturated=0.35");
selectWindow(title);
run("add channel", "target=Sum");
selectWindow("Img");
run("add channel", "target=Mult");
Stack.setSlice(slice);
Stack.getDimensions(width, height, channels, slices, frames);
for (i=0; i<channels; i++)
{
	Stack.setChannel(i);
	run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(channels-1);	
rename(title+"_highlighted");
selectWindow("Img");
close();
selectWindow("Sum");
close();
selectWindow("Mult");
close();
selectWindow("SpectralMask");
close();