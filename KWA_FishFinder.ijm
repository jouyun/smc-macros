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

t=getTitle();
run("Z Project...", "projection=Median");
rename("Med");
selectWindow(t);
run("32-bit");
imageCalculator("Subtract stack", t,"Med");
run("Abs", "stack");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Gaussian Blur...", "sigma=5 stack");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(15.0000, 1000000000000000000000000000000.0000);
run("Convert to Mask", "method=Default background=Dark black");
run("Analyze Particles...", "size=4000-Infinity show=Masks stack");
run("Invert LUT");
run("MTrack2 ", "minimum=1 maximum=999999 maximum_=1000 minimum_=2 save show show_0 save=["+dir+File.separator+t+".txt]");
run("Save As Tiff", "save=["+dir+File.separator+t+"_labels.tif]");
