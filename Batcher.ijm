name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(true);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (endsWith(fname, ".zvi"))
	{
		IJ.log(fname);
		//open(fname);
		//runMacro("ProcessWidefieldFRETv2.ijm");

run("Bio-Formats Importer", "open="+fname+" color_mode=Default view=Hyperstack stack_order=XYCZT");
t=getTitle();
call("ij.ImagePlus.setDefault16bitRange", 16);
//run("Brightness/Contrast...");
run("Invert");
setSlice(1);
run("Duplicate...", "title=A duplicate channels=1");
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=20");
run("Analyze Particles...", "  show=[Count Masks]");
tt=getTitle();
run("Mask Largest");
//run("Threshold...");
setAutoThreshold("Default dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "add");
Res=roiManager("Count");
selectWindow(tt);
close();
selectWindow("A");
close();
selectWindow("Result");
close();
selectWindow(t);
run("Subtract Background...", "rolling=500");
roiManager("Select", Res-1);
run("Measure");


		
		//saveAs("Tiff", fname);
		//close();
		run("Close All");
	}
}
