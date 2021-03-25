t=getTitle();

run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
run("Make Composite");
run("Duplicate...", "duplicate channels=2");
run("Invert");

run("Grays");
run("Scale...", "x=.125 y=.125 width=1298 height=755 interpolation=Bilinear average create");
run("Scale...", "x=.125 y=.125 width=162 height=94 interpolation=Bilinear average create");
rename("Master");

run("Duplicate...", "title=A");
setThreshold(44, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Erode");
run("Dilate");
run("Analyze Particles...", "pixel show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=110-Infinity pixel show=Masks display");
setResult("Label", nResults-1, t);
IJ.log(""+nResults);
IJ.log(getResult("Area", (nResults-1)));
setResult("WholeArea", nResults-1, getResult("Area", nResults-1));
run("Invert LUT");
rename("AA");
selectWindow("Master");
run("Duplicate...", "title=B");

run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("Threshold...");
waitForUser
//setThreshold(100, 255);

run("Convert to Mask");
run("Fill Holes");
run("Dilate");
run("Erode");
run("Fill Holes");
run("Analyze Particles...", "pixel show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=110-Infinity pixel show=Masks display");
setResult("LowerArea", nResults-2, getResult("Area", nResults-1));
run("Invert LUT");
rename("BB");

imageCalculator("Subtract create", "AA","BB");
run("Erode");
run("Dilate");
run("Analyze Particles...", "pixel show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=110-Infinity pixel show=Masks display");
setResult("PositiveArea", nResults-3, getResult("Area", nResults-1));
run("Invert LUT");
rename("CC");

selectWindow("Master");
run("Merge Channels...", "c1=Master c2=CC c3=AA c4=BB create");
selectWindow("Composite");
Stack.setActiveChannels("1100");
Stack.setDisplayMode("grayscale");
rename(t+"_processed.tif");
IJ.deleteRows(nResults-2,nResults-1);
