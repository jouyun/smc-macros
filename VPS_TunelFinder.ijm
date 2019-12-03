distance_thresh=30;

t=getTitle();
roiManager("reset");

/*****Make distance mask map*****/
//Scale down
run("Duplicate...", "title=A duplicate channels=3");
run("Grays");
run("Scale...", "x=.125 y=.125 width=1322 height=716 interpolation=Bilinear average create");
run("Invert");
setAutoThreshold("Default dark");
setThreshold(58, 255);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=100000-Infinity show=Masks");
run("Invert LUT");
run("Duplicate...", " ");
run("Distance Map");
setAutoThreshold("Default dark");
setThreshold(distance_thresh, 255);
run("Convert to Mask");
run("Analyze Particles...", "  show=[Count Masks]");
//Get just the largest
run("Mask Largest");
setAutoThreshold("Default dark");
setThreshold(129, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
rename("DistanceMask");
//Scale it back up
run("Scale...", "x=8 y=8 width=10576 height=5728 interpolation=Bilinear average create");
setAutoThreshold("Default dark");
setThreshold(50, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=1562.50-Infinity add");


/**********FIND LARGE BRIGHT AREAS TO IGNORE*********/
selectWindow(t);
run("Duplicate...", "duplicate channels=2");
run("Invert");
run("Gaussian Blur...", "sigma=2");
roiManager("Select", 0);
run("Measure");
std=getResult("StdDev");
mean=getResult("Mean");
new_thresh=mean+std*3;
setAutoThreshold("Default dark");
setThreshold(new_thresh, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Dilate");
run("Fill Holes");
run("Analyze Particles...", "size=500-Infinity show=Masks");
run("Invert");
rename("PatchMask");
IJ.deleteRows(nResults-1, nResults); 

/**********Find the dead cells*************/
selectWindow(t);
run("Duplicate...", "duplicate channels=2");
run("Invert");
run("Gaussian Blur...", "sigma=2");
roiManager("Select", 0);
run("Measure");
std=getResult("StdDev");
mean=getResult("Mean");
new_thresh=mean+std*6.5;
setAutoThreshold("Default dark");
setThreshold(new_thresh, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
rename("SpotMask");

imageCalculator("AND create", "SpotMask","PatchMask");
roiManager("Select", 0);
run("Analyze Particles...", "size=20-200 show=Masks add");
run("Invert LUT");
setResult("Count", nResults-1, roiManager("count")-1);

selectWindow(t);
roiManager("Show None");
roiManager("Show All");
//roiManager("Save", "S:/micro/jeg/vps/smc/20181019_OSS_IMARE-87312_TUNEL/01_01_02/RoiSet.zip");




