//run("Close All");

ugly_blob_snr=300;
ugly_blob_min_size=1000;
chromosome_snr=40;
chromosome_min_size=100;
chromosome_max_size=100000;
//Prior to 08262014 this was 3, changed to 10
chromosome_find_maxima_thresh=10;

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
//run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+(nSlices/2)+" frames=1 display=Grayscale");
//run("Z Project...", "start=1 stop=9 projection=[Max Intensity]");
run("Duplicate...", "title=Original duplicate channels=1");
run("Percentile Threshold", "percentile=60 snr="+ugly_blob_snr);
tmp=getTitle();

run("Analyze Particles...", "size="+ugly_blob_min_size+"-Infinity circularity=0.50-1.00 show=Masks");

run("Invert LUT");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");

roiManager("reset");
run("Analyze Particles...", "size="+ugly_blob_min_size+"-Infinity circularity=0.50-1.00 show=Nothing add");

close();
selectWindow(tmp);
close();


//run("Correct Flatness", "xcenter=514 ycenter=730 xwidth=650 ywidth=650 background=7");

run("Subtract Background...", "rolling=50");
tt=getTitle();
setMinAndMax(0, 10000);
setBackgroundColor(0, 0, 0);
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



run("Percentile Threshold", "percentile=60 snr="+chromosome_snr);

run("Open");
run("Analyze Particles...", "size="+chromosome_min_size+"-"+chromosome_max_size+" circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
rename("ObjectMask");
selectWindow("Flat");
run("Smooth");

run("Find Maxima...", "noise="+chromosome_find_maxima_thresh+" output=[Single Points]");
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
//selectWindow("Original");
//close();
selectWindow("Final");
