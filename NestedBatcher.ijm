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
	sub_dir=source_dir+source_list[n];
	if (File.isDirectory(sub_dir))
	{
	sub_list=getFileList(sub_dir);
	for (m=0; m<sub_list.length; m++)
	{
		fname=sub_dir+sub_list[m];
		//run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		//saveAs("Tiff", File.getParent(source_dir)+File.separator+File.getName(source_dir)+"_Tiff"+File.separator+File.getName(fname)+".tif");
	
		//if (!endsWith(fname, "01.tif")&!endsWith(fname, "_processed.tif")&!endsWith(fname, "projection.tif")&!endsWith(fname, "mask.tif")&endsWith(fname, ".tif")&!endsWith(fname, "backsub.tif")&!endsWith(fname,"unthreshed.tif"))
		if (endsWith(fname, ".tif"))
		//if (!File.exists(fname+"_backgroundp.tif"))
		{
			IJ.log(fname);
			
			//run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			open(fname);
			rename(source_list[n]+":"+getTitle());
			//if (File.exists(fname+".zip"))
			{
				//open(fname+".zip");
				runMacro("U:\\smc\\Fiji_2016.app\\macros\\VPS_QuantifyRedLargeNucleii.ijm", source_dir);
				//runMacro("/home/smc/Fiji.app/macros/VPS_QuantifyRedLargeNucleii.ijm", source_dir);
				//runMacro("/home/smc/Fiji.app/macros/AHK_ProcessStellaWells.ijm");
				//saveAs("Results", fname+"_Results.csv");
				//run("Clear Results");
				
				//saveAs("Tiff", fname+"_processed.tif");
				//run("Save As Tiff", "save="+fname+"_BackSub.tif"+" imp="+getTitle());
			}
			run("Close All");
		}
		//close();	
	}
	}
}
