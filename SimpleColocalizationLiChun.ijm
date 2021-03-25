t=getTitle();

run("Clear Results");
run("Make Composite");
run("Subtract Background...", "rolling=50");
run("Smooth");
run("Duplicate...", "title=G duplicate channels=2");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(22, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display clear");
run("Invert LUT");

selectWindow("G");
close();
selectWindow(t);
run("Duplicate...", "title=R duplicate channels=1");
setThreshold(18, 255);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display clear");
greens=nResults;
selectWindow("Mask of R");
run("Invert LUT");
selectWindow("R");
close();
imageCalculator("AND create", "Mask of G","Mask of R");
selectWindow("Result of Mask of G");
roiManager("Deselect");
roiManager("Show All with labels");
roiManager("Show All");
run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display clear add");
run("Invert LUT");
boths=nResults;
IJ.log("Results:  "+boths+","+greens);
selectWindow("Mask of G");
close();
selectWindow("Mask of R");
close();
selectWindow("Result of Mask of G");
close();
selectWindow("Mask of Result of Mask of G");
close();
selectWindow(t);
setMinAndMax(0, 47);
run("Magenta");
Stack.setActiveChannels("110");
Stack.setChannel(2);
setMinAndMax(0, 47);
roiManager("Show All");