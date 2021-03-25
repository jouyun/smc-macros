name=getArgument;

if (name=="")
{
	fname = File.openDialog("Choose file");
}
else
{
	fname=name;
}

base_dir=File.getParent(fname);

run("Bio-Formats Importer", "open="+fname+" color_mode=Default view=Hyperstack stack_order=XYCZT series_1");

run("Clear Results");
t=getTitle();
run("Duplicate...", "title=R duplicate channels=1");
run("Translate...", "x=1.3 y=1.3 interpolation=Bilinear slice");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=3");
imageCalculator("Subtract create", "B","R");
run("Median...", "radius=2");
run("Grays");

selectWindow("B");
run("Duplicate...", "title=Mask");
setAutoThreshold("Default");
//run("Threshold...");
setThreshold(0, 128);
//run("Threshold...");
//setThreshold(0, 128);
run("Convert to Mask");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");
run("Dilate");

run("Invert");
run("Divide...", "value=255.000");
imageCalculator("Multiply create", "Result of B","Mask");
selectWindow("Result of Result of B");

setOption("BlackBackground", true);
setThreshold(14, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=20-Infinity display clear add");
if (nResults>0) 
{
	selectWindow(t);
	saveAs("Tiff", base_dir+File.separator+t+".tif");
	roiManager("Save", base_dir+File.separator+t+".zip");
}
run("Close All");