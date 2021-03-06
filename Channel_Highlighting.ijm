Dialog.create("Channel Highlighting");
Dialog.addCheckbox("Separate touching neighbors?  (can also lead to extra blobs)", true);
Dialog.addCheckbox("Prevent vertical forking?", true);
Dialog.addCheckbox("Fill holes during processing?", true);
Dialog.show();
separate_neighbors=Dialog.getCheckbox();
separate_vertical_neighbors=Dialog.getCheckbox();
fill_holes=Dialog.getCheckbox();

IJ.log(""+separate_neighbors);
IJ.log(""+separate_vertical_neighbors);

getThreshold(lower, upper);
IJ.log("Lower thresh:  "+lower);
run("32-bit");
title=getTitle();
roiManager("reset");
roiManager("Add");
//run("Add to Manager");
Stack.getPosition(channel, slice, frame);
IJ.log(""+slice);
run("Reduce Dimensionality...", "  slices keep");
rename("Original");
Stack.getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=[Mask] duplicate channels=1-"+channels+" slices=1-"+slices);
roiManager("Select", 0);
Stack.setSlice(slice);
run("Set Measurements...", "area mean standard min centroid center fit integrated redirect=None decimal=3");
run("Measure");
if (lower==-1) 
{
	IJ.log("Used ROI");
	low=getResult("Min", nResults-1);
}
else low=lower;
setThreshold(low, 65536);
run("Convert to Mask", "  black");
if (fill_holes) run("Fill Holes", "stack");
run("Erode", "stack");
run("Dilate", "stack");
if (separate_neighbors) run("Watershed", "stack");

run("Analyze Particles...", "size=0-1200 circularity=0.00-1.00 show=Masks exclude stack");
selectWindow("Mask");
close();
selectWindow("Mask of Mask");
rename("Mask");

roiManager("Select", 0);
Stack.setSlice(slice);
if (separate_vertical_neighbors) run("seeded region grow 3D watershed");
else run("seeded region grow 3D");

rename("Single");
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
