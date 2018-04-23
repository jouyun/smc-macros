run("Bio-Formats Macro Extensions");

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
	if (endsWith(fname, ".nd2"))
	{
		Ext.setId(fname);
		Ext.getSeriesCount(sC);
		IJ.log("Count: "+sC);
		for (f=0; f<sC; f++)
		{
			run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+(f+1));
			run("Save As Tiff", "save="+fname+"_"+(f+1)+".tif imp="+getTitle());
			run("Z Project...", "projection=[Average Intensity]");
			saveAs("Tiff", fname+"_"+(f+1)+"_projection.tif");
			run("Close All");			
		}
	}
}
