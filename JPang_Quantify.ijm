t=getTitle();
roiManager("reset");
roiManager("Add");
run("Measure");
run("Select All");
run("Duplicate...", "title=A duplicate channels=2");
run("32-bit");
run("Log3D", "imp=A sigmax=7.0 sigmay=7.0 sigmaz=1.0");
run("Find Maxima...", "noise=50 output=[Single Points]");
run("Divide...", "value=255.000");
rename("Points");

selectWindow("A");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Default dark");
setThreshold(20.0000, 254.9538);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Divide...", "value=255.000");
rename("Mask");

imageCalculator("Multiply create", "Points","Mask");
rename("Final");
roiManager("Select", 0);
roiManager("Measure");
spot_count=getResult("IntDen");
setResult("Spots", nResults-2, spot_count);
IJ.deleteRows(nResults-1, nResults);


selectWindow("Final");
run("Find Maxima...", "noise=0.2 output=[Point Selection]");
roiManager("Add");
selectWindow(t);
selectWindow("ROI Manager");
roiManager("Select", 1);
Stack.setChannel(2);