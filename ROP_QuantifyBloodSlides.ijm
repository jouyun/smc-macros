current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}

current_directory=File.getParent(current_file);

run("Bio-Formats Importer", "open="+current_file+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_3");
ta=getTitle();

run("Duplicate...", "title="+substring(ta, 0, lengthOf(ta)-6)+" duplicate");
t=getTitle();
if (isOpen("ROI Manager"))
{
     selectWindow("ROI Manager");
     run("Close");
}
run("Clear Results");
selectWindow(t);
run("Invert");

//Find filtering mask
run("Duplicate...", "duplicate channels=2");
//run("Subtract Background...", "rolling=200");
run("Gaussian Blur...", "sigma=100");
setAutoThreshold("Default dark");
setThreshold(50, 255);
run("Convert to Mask");
run("Invert");
rename("FilterMask");

//Find brown spots
selectWindow(t);
run("Duplicate...", "title=R duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=3");
imageCalculator("Subtract create", "B","R");
selectWindow("Result of B");
rename("Blur");
run("Gaussian Blur...", "sigma=1.5");
setAutoThreshold("Default dark");
setThreshold(15, 255);
run("Convert to Mask");
rename("Brown");
imageCalculator("AND create", "Brown","FilterMask");
run("Analyze Particles...", "size=20-100 show=Nothing display add");
browns=nResults;

//Find all cells
selectWindow(t);
run("Duplicate...", "title=GGG duplicate channels=2");
run("Subtract Background...", "rolling=5");
run("Gaussian Blur...", "sigma=0.75");
setAutoThreshold("Default dark");
run("Convert to Mask");
rename("Cells");
imageCalculator("AND create", "Cells","FilterMask");
run("Analyze Particles...", "size=4-30 show=Nothing display");
normals=nResults-browns;

IJ.log(t+","+browns+","+normals);

selectWindow(t);
run("Invert");
run("Split Channels");
run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=C3-"+t+" c4=[Result of Brown] c5=[Result of Cells] create");
//run("Channels Tool...");
Stack.setActiveChannels("11110");
Stack.setActiveChannels("11100");

run("Save As Tiff", "save="+current_directory+File.separator+t+".tif");

run("Close All");