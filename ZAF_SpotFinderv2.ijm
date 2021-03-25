t=getTitle();
if (isOpen("ROI Manager"))
{
     selectWindow("ROI Manager");
     run("Close");
}
//DAPI Mask
run("Duplicate...", "duplicate channels=4 title=DAPI");
run("Duplicate...", "title=BlurMask");
run("Gaussian Blur...", "sigma=20");
setMinAndMax(0, 800);
run("8-bit");
setThreshold(37, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
selectWindow("DAPI");
run("Subtract Background...", "rolling=200");
run("Duplicate...", "title=Normalizer");
run("32-bit");
run("Gaussian Blur...", "sigma=200");
selectWindow("DAPI");
run("32-bit");
imageCalculator("Divide create 32-bit", "DAPI","Normalizer");
rename("Normalized");
selectWindow("BlurMask");
run("Divide...", "value=255");
run("32-bit");
imageCalculator("Multiply create 32-bit", "Normalized","BlurMask");
setMinAndMax(0, 5);

//Watershedder
selectWindow("Result of Normalized");
setMinAndMax(0, 10);
run("8-bit");
run("Duplicate...", "title=Water");
run("Gaussian Blur...", "sigma=2");
setThreshold(15, 255);
run("Convert to Mask");
run("Watershed");
run("Merge Channels...", "c2=[Result of Normalized] c6=[Water] create");
selectWindow("Composite");
rename("Segmented");

//Peak Finder
selectWindow(t);
run("Duplicate...", "duplicate channels=1-3");
rename("Root");
run("Subtract Background...", "rolling=200 stack");
run("Gaussian Blur...", "sigma=1 stack");
tt=getTitle();

run("Duplicate...", "title=LargeObjects duplicate channels=1");
run("Gaussian Blur...", "sigma=10");
setAutoThreshold("Default dark");
setMinAndMax(0, 500);
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(31, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Invert");
run("Divide...", "value=255");

imageCalculator("Multiply create 32-bit stack", tt,"BlurMask");
rename("BackSubMiniBlurMask");
run("Subtract Background...", "rolling=3 stack");
rename("BigBackSub");
ttt=getTitle();

//Channel 1 peaks
selectWindow(ttt);
run("Duplicate...", "duplicate channels=1");
run("Log3D", "sigmax=2.0 sigmay=2.0 sigmaz=1.0");
run("Find Maxima...", "noise=150 output=[Single Points]");
tat=getTitle();
imageCalculator("Multiply create", "LargeObjects",tat);
run("Dilate");
run("Analyze Particles...", "size=0-20 show=Masks slice");
run("Invert LUT");
rename("Ch1 PeakMask");

//Channel 2 peaks
selectWindow(ttt);
run("Duplicate...", "duplicate channels=2");
run("Log3D", "sigmax=2.0 sigmay=2.0 sigmaz=1.0");
run("Find Maxima...", "noise=600 output=[Single Points]");
tat=getTitle();
imageCalculator("Multiply create", "LargeObjects",tat);
run("Dilate");
run("Analyze Particles...", "size=0-20 show=Masks slice");
run("Invert LUT");
rename("Ch2 PeakMask");

//Channel 3 peaks
selectWindow(ttt);
run("Duplicate...", "duplicate channels=3");
run("Log3D", "sigmax=2.0 sigmay=2.0 sigmaz=1.0");
run("Find Maxima...", "noise=250 output=[Single Points]");
tat=getTitle();
imageCalculator("Multiply create", "LargeObjects",tat);
run("Dilate");
run("Analyze Particles...", "size=0-20 show=Masks slice");
run("Invert LUT");
rename("Ch3 PeakMask");


run("Merge Channels...", "c1=[Ch1 PeakMask] c2=[Ch2 PeakMask] c3=[Ch3 PeakMask] create");
selectWindow("Composite");
rename("PeakPoints");
run("Z Project...", "projection=[Max Intensity]");
run("Analyze Particles...", "size=0-80 show=Nothing add");
run("Clear Results");
selectWindow("PeakPoints");
roiManager("Measure");
Stack.setChannel(2);
roiManager("Measure");
Stack.setChannel(3);
roiManager("Measure");




