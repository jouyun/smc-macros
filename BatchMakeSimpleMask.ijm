name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (endsWith(fname, ".tif"))
	{
		IJ.log(fname);
		if (isOpen("ROI Manager"))
		{
			selectWindow("ROI Manager");
			run("Close");
		}
		roi_name=substring(fname,0,lengthOf(fname)-4)+".zip";
		//Do ASCI ROIs
		run("Bio-Formats Importer", "open="+fname+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		t=getTitle();

		run("Make Composite");
		run("Duplicate...", "title=Mask duplicate channels=1");
		
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");

		if (File.exists(roi_name))
		{
			open(roi_name);
			count=roiManager("Count");
			setForegroundColor(255, 255, 255);
			for (i=0; i<count; i++)
			{
			    roiManager("Select", i);
			    //run("Draw", "slice");
			    run("Fill", "slice");
			}
		}
		run("32-bit");
		selectWindow(t);
		run("32-bit");
		run("add channel", "target=Mask");
		run("Make Composite", "display=Composite");
		
		Stack.setDisplayMode("grayscale");
		run("Save As Tiff", "save="+substring(fname, 0, lengthOf(fname)-4)+"_DL.tif"+" imp="+getTitle());		
		run("Close All");
	}
}
