
'dirname=getDirectory("Select a source Directory");
'dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi29_12192011";
dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi62 ok693;hjSi29 Photobleaching";
IJ.log("running on:  "+dirname);
open("");
title=getTitle();
full_name=dirname+"\\"+title;
IJ.log(full_name);
run("Reduce Dimensionality...", "  keep");
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


