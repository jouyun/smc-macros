current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Spread");
}
else
{
	//current_file=name;
}
setBatchMode(false);
open(current_file);
t=getTitle();
run("32-bit");
run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+(nSlices/2)+" frames=1 display=Grayscale");
//run("Z Project...", "start=1 stop=9 projection=[Max Intensity]");
run("Duplicate...", "title=Original duplicate channels=1");
run("Percentile Threshold", "percentile=10 snr=50");
tmp=getTitle();

run("Analyze Particles...", "size=14000-Infinity circularity=0.50-1.00 show=Masks");
run("Invert LUT");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");

roiManager("reset");
run("Analyze Particles...", "size=14000-Infinity circularity=0.50-1.00 show=Nothing add");
close();
selectWindow(tmp);
close();


run("Correct Flatness", "xcenter=514 ycenter=730 xwidth=450 ywidth=450 background=142");
run("Subtract Background...", "rolling=50");
tt=getTitle();
setMinAndMax(0, 10000);
for (i=0; i<roiManager("count"); i++)
{
	selectWindow(tt);
	roiManager("Select", i);
	run("Clear", "slice");
	roiManager("Deselect");
}
//makeRectangle(18, 130, 994, 1010);
//run("Crop");
rename("Flat");
run("Select All");




run("Percentile Threshold", "percentile=30 snr=10");
run("Open");
run("Analyze Particles...", "size=400-100000 circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
rename("ObjectMask");

selectWindow("Flat");
run("Smooth");
run("Find Maxima...", "noise=700 output=[Single Points]");
rename("PointMask");
imageCalculator("AND create", "ObjectMask","PointMask");
rename("AND");
run("Dilate");
run("32-bit");

run("Find Maxima...", "noise=200 output=Count");
run("Concatenate...", "  title=Final image1=AND image2=Flat image3=[-- None --]");
run("Channels Tool...");
run("Make Composite", "display=Composite");
setSlice(2);
run("Magenta");
//setMinAndMax(0, 1000);
setSlice(1);
run("Green");


setResult("File", nResults-1, t);
selectWindow(t);
close();
//selectWindow("MAX_"+t);
//close();
selectWindow("PointMask");
close();
selectWindow("ObjectMask");
close();
selectWindow("Result");
close();
selectWindow("Original");
close();
selectWindow("Final");
return("");


