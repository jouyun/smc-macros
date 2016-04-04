t=getTitle();
ct=roiManager("Count");
for (i=0; i<ct; i++) 
{
	roiManager("Select", 0);
	roiManager("Delete");
}
run("Select All");
Stack.setDisplayMode("grayscale");
run("Duplicate...", "duplicate channels=2");
setThreshold(5000, 65535);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Open", "stack");
run("Dilate", "stack");
run("Dilate", "stack");
run("Dilate", "stack");
run("Fill Holes", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Analyze Particles...", "size=10-Infinity add stack");
selectWindow(t);

tt=t+"_results";
run("Duplicate...", "title="+tt+" duplicate channels=1");

run("32-bit");
run("Duplicate...", "title=Back duplicate channels=1");
run("Gaussian Blur...", "sigma=10 stack");
run("Subtract Background...", "rolling=50 create sliding stack");
imageCalculator("Subtract create 32-bit stack", tt,"Back");

run("Grays");
roiManager("Measure");
run("Close All");
