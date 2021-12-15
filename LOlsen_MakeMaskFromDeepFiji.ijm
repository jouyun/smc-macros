current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}


open(current_file);

thresh=0.5;
roiManager("reset");
t=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=Mask duplicate channels="+channels);
selectWindow(t);
//run("Threshold...");
run("Duplicate...", "title=Outline duplicate channels="+(channels-1));
run("Multiply...", "value=1 stack");
imageCalculator("Subtract create stack", "Mask","Outline");
setThreshold(thresh, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Divide...", "value=255");

selectWindow(t);
run("8-bit");
run("Duplicate...", "title=Final duplicate channels=1");
//run("Channels Tool...");
run("Grays");
setOption("ScaleConversions", true);

run("Merge Channels...", "c2=[Result of Mask] c4=Final create");

makeRectangle(30, 30, 964, 964);
run("Crop");
setMinAndMax(0, 3);
run("Save As Tiff", "save="+substring(current_file, 0, lengthOf(current_file)-4)+"_processed.tif");
rename(substring(t, 0, lengthOf(t)-4)+"_processed.tif");
run("Select All");
run("Measure");