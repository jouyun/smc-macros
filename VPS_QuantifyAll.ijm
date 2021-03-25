//run("Channels Tool...");
t=getTitle();
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
selectWindow(t);
Stack.setDisplayMode("grayscale");

run("Duplicate...", "duplicate channels=2");
run("Grays");
run("Invert");
run("32-bit");
run("Gaussian Blur...", "sigma=5");
run("Percentile Threshold", "percentile=10 snr=12");
//run("Fill Holes");
rename(t+"_A");
run("Analyze Particles...", "size=100000-Infinity show=Nothing add display");
