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
	if (endsWith(fname, "channel.czi"))
	{
		IJ.log(fname);
		if (isOpen("ROI Manager"))
		{
			selectWindow("ROI Manager");
			run("Close");
		}
		
		//Do ASCI ROIs
		run("Bio-Formats Importer", "open="+fname+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		t=getTitle();
		asci=substring(fname, 0, lengthOf(fname)-4)	+"_asci_ROIs.zip";
		open(asci);
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");
		
		setSlice(2);
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");
		
		count=roiManager("Count");
		setForegroundColor(255, 255, 255);
		for (i=0; i<count; i++)
		{
		    roiManager("Select", i);
		    setSlice(1);
		    run("Draw", "slice");
		    setSlice(2);
		    run("Fill", "slice");
		}
		selectWindow(t);		
		run("Select All");
		run("Duplicate...", "title=SacOutlines duplicate channels=1");
		run("Dilate");
		
		
		selectWindow(t);
		run("Duplicate...", "title=B duplicate channels=2");
		imageCalculator("Subtract create", "B","SacOutlines");
		run("Analyze Particles...", "size=20-Infinity pixel show=Masks");
		rename("SacMasks");
		selectWindow(t);
		close();


		//Do spores ROIs
		if (isOpen("ROI Manager"))
		{
			selectWindow("ROI Manager");
			run("Close");
		}
		run("Bio-Formats Importer", "open="+fname+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		tt=getTitle();
		spores=substring(fname, 0, lengthOf(fname)-4)	+"_spores_ROI.zip";
		open(spores);
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");
		
		setSlice(2);
		run("Select All");
		setBackgroundColor(0, 0, 0);
		run("Clear", "slice");
		
		count=roiManager("Count");
		setForegroundColor(255, 255, 255);
		for (i=0; i<count; i++)
		{
		    roiManager("Select", i);
		    setSlice(1);
		    run("Draw", "slice");
		    setSlice(2);
		    run("Fill", "slice");
		}
		selectWindow(tt);		
		run("Select All");
		run("Duplicate...", "title=SporeOutlines duplicate channels=1");
		run("Dilate");
		
		
		selectWindow(tt);
		run("Duplicate...", "title=BB duplicate channels=2");
		imageCalculator("Subtract create", "BB","SporeOutlines");
		run("Analyze Particles...", "size=20-Infinity pixel show=Masks");
		rename("SporeMasks");		
		//Merge them
		selectWindow(tt);
		run("Split Channels");

		run("Merge Channels...", "c1=C3-"+tt+" c2=SporeOutlines c3=SporeMasks c4=SacOutlines c5=SacMasks create");
		selectWindow("Composite");
		Stack.setDisplayMode("grayscale");
		run("Save As Tiff", "save="+substring(fname, 0, lengthOf(fname)-4)+"_DL2.tif"+" imp="+getTitle());		
		run("Close All");
	}
}
