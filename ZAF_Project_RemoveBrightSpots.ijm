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

current_dir=File.getParent(current_file);
//open(current_file);
run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");


//run("Canvas Size...", "width=2048 height=2048 position=Center zero");


/*t=getTitle();

if (isOpen("ROI Manager"))
{
	selectWindow("ROI Manager");
	run("Close");
}

run("Duplicate...", "duplicate channels=4");
run("Gaussian Blur...", "sigma=5");
setThreshold(114, 4000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "  show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=1000000-Infinity add");
selectWindow(t);
roiManager("Select", 0);
run("Crop");
setBackgroundColor(0, 0, 0);
run("Clear Outside", "stack");

run("Select All");

Stack.getDimensions(w,h,c,s,f);
new_width=(floor(w/256)+1)*256;
new_height=(floor(h/256)+1)*256;
run("Canvas Size...", "width="+new_width+" height="+new_height+" position=Center zero");
*/

t=getTitle();
ttt=getTitle();
//run("Find Maxima...", "noise=400 output=[Single Points]");
selectWindow(t);
Stack.setChannel(1);
run("Find Maxima...", "noise=400 output=[Single Points]");
rename("A");

selectWindow(t);
Stack.setChannel(3);
run("Find Maxima...", "noise=400 output=[Single Points]");
rename("B");

imageCalculator("Add create", "A","B");
selectWindow("Result of A");

run("Dilate");
run("Gaussian Blur...", "sigma=5");
setAutoThreshold("Default dark");
setThreshold(1, 255);
run("Convert to Mask");
run("Invert");
run("Divide...", "value=255");
tt=getTitle();
imageCalculator("Multiply create stack", ttt,tt);
rename("C");
run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-4)+"r.tif] imp=C");


run("32-bit");

Stack.getDimensions(w,h,c,s,f);

run("Make Windows", "window=256 z=1 staggered?");
saveAs("Raw Data", current_file+".raw");
run("Make Image From Windows", "width="+w+" height="+h+" slices=1 staggered?");
run("Make Composite", "display=Composite");
run("Save As Tiff", "save=["+current_file+"_resized.tif] imp=NewImg");
run("Close All");