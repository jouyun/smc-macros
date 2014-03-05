
dirname=getDirectory("Select a source Directory");
IJ.log("running on:  "+dirname);
file_list=getFileList(dirname);
for (i=0; i<lengthOf(file_list); i++)
{
	if (File.isDirectory(dirname+file_list[i])) 
	{
		'newdir=substring(file_list[i], 0, lengthOf(file_list[i])-1)+"\\";
		'IJ.log("directory:  " +dirname+newdir);
		'convert_directory(""+dirname+newdir);
	}
	else
	{
		open(dirname+file_list[i]);
		//rename("A");
		run("Reduce Dimensionality...", "  keep");
		setAutoThreshold("Default dark");
		run("Threshold...");
		run("Convert to Mask");
		run("Dilate");
		run("Dilate");
		run("Fill Holes");
		run("Erode");
		run("Erode");
		run("Erode");
		run("Analyze Particles...", "size=500-Infinity circularity=0.00-1.00 show=Nothing clear add");
		//selectWindow("ROI Manager");
		close();
		IJ.log("running on:  "+dirname+file_list[i]);
		run("Bio-Formats Importer", "open="+dirname+file_list[i]+" autoscale color_mode=Default display_rois view=Hyperstack stack_order=XYCZT");
		close();
		roiManager("Select", 2);
		roiManager("Delete");
		runMacro("U:\\smc\\Fiji.app\\macros\\NewFRAPMacro.ijm");
	}
}




