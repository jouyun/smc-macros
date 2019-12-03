t=getTitle();
roiManager("reset");
run("Duplicate...", "title=Template");

//run("Gaussian Blur...", "sigma=4");
run("Gaussian Blur...", "sigma=12");
run("Invert");
run("Subtract Background...", "rolling=500");
setAutoThreshold("Default dark");
//setThreshold(77686.7342, 1000000000000000000000000000000.0000);
setThreshold(48686.7342, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Erode");
run("Analyze Particles...", "size=2000-Infinity pixel show=Masks add");
rename("Mask");
run("Invert LUT");
saveAs("Tiff", "D:/tmp/Output/"+t+".tif");
selectWindow(t);
roiManager("Show None");
roiManager("Show All");

