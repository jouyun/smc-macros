current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Image");
}
else
{
     //current_file=name;
}
dir=File.getParent(current_file);

open(current_file);
run("Properties...", "channels=3 slices=1 frames=1 unit=mm pixel_width=.000392 pixel_height=.000392 voxel_depth=.000392");

thresh=0.2;
roiManager("reset");
//run("Z Project...", "projection=[Max Intensity]");
run("Grays");
t=getTitle();
run("Duplicate...", "title=Backup duplicate channels=1");
selectWindow(t);
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=30");
setOption("BlackBackground", true);
run("Erode");
rename("BeforeFill");
run("Duplicate...", "title=AAA");
run("Fill Holes");
rename("PreDiskAnalyzeParticles");
run("Analyze Particles...", "size=10000-Infinity pixel circularity=0-1.00 show=[Count Masks]");
run("Mask Largest");
run("8-bit");
run("Analyze Particles...", "size=10000-Infinity pixel circularity=0-1.00 add");
run("Divide...", "value=255");
rename("ObjectMask");
imageCalculator("Multiply create stack", t,"ObjectMask");
tt=getTitle();

selectWindow(tt);
Stack.getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=Mask duplicate channels="+channels);
selectWindow(tt);
//run("Threshold...");
run("Duplicate...", "title=Outline duplicate channels="+(channels-1));
imageCalculator("Subtract create stack", "Mask","Outline");
setThreshold(thresh, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");

run("Watershed");

run("Analyze Particles...", "size=150-1000 pixel circularity=0.65-1.00 show=Masks add");
rename("FinalMasks");
selectWindow("Backup");
roiManager("Show All");

selectWindow("FinalMasks");
//selectWindow("BlobFinder");
run("32-bit");
run("Merge Channels...", "c2=Backup c6=FinalMasks create");
setMinAndMax(0,9000);
rename(t+"_Analyzed");
roiManager("Select", 0);
//saveAs("Tiff", dir+File.separator+getTitle()+".tif");
run("Save As Tiff", "save=["+dir+File.separator+getTitle()+".tif"+"]");

selectWindow("BeforeFill");
roiManager("Select", 0);
run("Measure");
setResult("Count", nResults-1, roiManager("count")-1);
setResult("Title", nResults-1, t);
