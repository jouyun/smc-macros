t=getTitle();
run("Make Composite");
//run("Channels Tool...");
Stack.setDisplayMode("grayscale");
run("Duplicate...", "title=DAPIMask duplicate channels=1");
run("Grays");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=2");
run("Grays");
selectWindow("DAPIMask");
run("Gaussian Blur...", "sigma=20");
//For 5X auto works fine
setAutoThreshold("Default dark");
//For 20X put in manual
setThreshold(7, 255);

setOption("BlackBackground", true);
run("Convert to Mask");

run("Divide...", "value=255");

selectWindow("B");
run("Subtract Background...", "rolling=100");

imageCalculator("Multiply create", "DAPIMask","B");
selectWindow("Result of DAPIMask");

run("Select All");
run("Measure");
intensity=getResult("RawIntDen", nResults-1);

selectWindow("DAPIMask");
run("Select All");
run("Measure");

area=getResult("RawIntDen", nResults-1);
setResult("Area", nResults-2, area);
setResult("ActMean", nResults-2, intensity/area);
setResult("File", nResults-2, t);
IJ.deleteRows(nResults-1, nResults-1);

run("Close All");
