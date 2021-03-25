//run("Close All");

ugly_blob_snr=300;
ugly_blob_min_size=1000;
chromosome_snr=40;
chromosome_min_size=100;
chromosome_max_size=100000;
//Prior to 08262014 this was 3, changed to 10
chromosome_find_maxima_thresh=200;

current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Spread");
}
else
{
	//current_file=name;
}
setBatchMode(true);
open(current_file);
t=getTitle();
run("32-bit");
run("Duplicate...", "title=Original duplicate channels=1");

selectWindow(t);


runMacro("ClassifierTest.js");
run("Duplicate...", "title=ObjectMask1");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(0.0800, 0.7940);
run("Convert to Mask");
selectWindow("Probability maps");
close();
selectWindow("Features");
close();
selectWindow("ObjectMask1");
//run("Dilate");
//run("Dilate");
//run("Dilate");


selectWindow("Original");
run("Subtract Background...", "rolling=50");
run("Smooth");
run("Percentile Threshold", "percentile=60 snr="+chromosome_snr);

run("Open");
run("Analyze Particles...", "size="+chromosome_min_size+"-"+chromosome_max_size+" circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
rename("ObjectMask2");
imageCalculator("AND create", "ObjectMask1","ObjectMask2");
rename("ObjectMask");
run("Fill Holes");
selectWindow("Original");
run("Find Maxima...", "noise="+chromosome_find_maxima_thresh+" output=[Single Points]");

rename("PointMask");
imageCalculator("AND create", "ObjectMask","PointMask");
//return("");
rename("AND");
run("Dilate");
run("32-bit");

run("Find Maxima...", "noise=200 output=Count");
run("Concatenate...", "  title=Final image1=AND image2=Original image3=[-- None --]");
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
selectWindow("ObjectMask2");
close();
selectWindow("Final");
selectWindow("Result");
close();
selectWindow("Final");
selectWindow("ObjectMask1");
close();
selectWindow("Final");