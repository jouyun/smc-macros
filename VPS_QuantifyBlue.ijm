t=getTitle();
run("Duplicate...", "title=R duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=3");

if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }

imageCalculator("Subtract create", "B","R");
selectWindow("Result of B");
rename(t+"_B");
setOption("BlackBackground", true);
setThreshold(89, 255);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=100-Infinity show=Nothing add display");
