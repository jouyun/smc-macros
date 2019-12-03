/*current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Image");
}
else
{
     //current_file=name;
}
dir=File.getParent(current_file);

open(current_file);*/
roiManager("reset");
run("Z Project...", "projection=[Max Intensity]");
run("Grays");
t=getTitle();
run("Duplicate...", "title=Backup");
selectWindow(t);
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=15");
setOption("BlackBackground", true);
run("Erode");
rename("BeforeFill");
run("Duplicate...", "title=AAA");
run("Fill Holes");
rename("PreDiskAnalyzeParticles");
run("Analyze Particles...", "size=10000-Infinity circularity=0-1.00 show=Masks add");
run("Invert LUT");
run("Divide...", "value=255");
rename("ObjectMask");
imageCalculator("Multiply create", t,"ObjectMask");



run("Duplicate...", "title=PreBackgroundSubtract");
run("Subtract Background...", "rolling=50");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Gaussian Blur...", "sigma=1.5");
run("32-bit");
rename("BlobFinder");
run("Percentile Threshold", "percentile=30 snr=17");
//return("");
run("Watershed");

run("Analyze Particles...", "size=150-1000 circularity=0.65-1.00 show=Masks add");
rename("FinalMasks");
selectWindow("Backup");
roiManager("Show All");

selectWindow("FinalMasks");
//selectWindow("BlobFinder");
run("16-bit");
run("Merge Channels...", "c2=Backup c6=FinalMasks create");
setMinAndMax(0, 300);
rename(t+"_Analyzed");
roiManager("Select", 0);
saveAs("Tiff", dir+File.separator+getTitle()+".tif");

selectWindow("BeforeFill");
roiManager("Select", 0);
run("Measure");
setResult("Count", nResults-1, roiManager("count")-1);
setResult("Title", nResults-1, t);
