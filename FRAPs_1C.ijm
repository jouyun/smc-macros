
'dirname=getDirectory("Select a source Directory");
'dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi29_12192011";
dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi62_ok693;hjSi29_Photobleaching\\01052012_30s";
'dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi62_ok693;hjIs14_Photobleaching\\01042012";
IJ.log("running on:  "+dirname);
open("");
title=getTitle();
full_name=dirname+"\\"+title;
IJ.log(full_name);
run("Slice Keeper", "first=1 last=1 increment=1");
t=getTitle();
selectWindow(title);
//close();
selectWindow(t);
setAutoThreshold("Default dark");
run("Threshold...");
run("Convert to Mask");
run("Dilate");
run("Dilate");
run("Fill Holes");
run("Erode");
run("Erode");
run("Erode");
run("Analyze Particles...", "size=500-Infinity circularity=0.00-1.00 show=Nothing clear add");
close();
run("Bio-Formats Importer", "open="+full_name+" autoscale color_mode=Default display_rois view=Hyperstack stack_order=XYCZT");
close();
selectWindow("ROI Manager");
//roiManager("Select", 2);
//roiManager("Delete");

