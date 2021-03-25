t=getTitle();
roiManager("reset");

//Make mask
run("Duplicate...", "title=Green duplicate channels=2");
run("Invert", "stack");
run("32-bit");
run("Gaussian Blur...", "sigma=10");
run("Percentile Threshold", "percentile=30 snr=30");
run("Analyze Particles...", "  show=[Count Masks]");
run("Mask Largest");
setThreshold(120, 65535);
run("Convert to Mask");
run("Invert");
run("Distance Transform 3D");
selectWindow("Result");
selectWindow("Distance");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(72.6803, 1000000000000000000000000000000.0000);
run("Convert to Mask");
rename("Mask");

//Make spots
selectWindow(t);
run("Invert", "stack");
run("32-bit");
run("Split Channels");
imageCalculator("Subtract create 32-bit", "C2-"+t,"C1-"+t);
run("Grays");
run("Log3D", "sigmax=2.0 sigmay=2.0 sigmaz=1.0");
run("Find Maxima...", "prominence=400 output=[Single Points]");
rename("Spots");

imageCalculator("AND create", "Mask","Spots");
rename(t+"_processed");
run("Find Maxima...", "prominence=1 output=Count");
if (getResult("Count")>0)
{
	run("Find Maxima...", "prominence=1 output=[Point Selection]");
	roiManager("Add");
	roiManager("Save", "S:/micro/jeg/vps/lem/20200928_OSS_HE/"+t+".roi");
}

