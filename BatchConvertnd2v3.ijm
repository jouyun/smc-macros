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
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	dir_name=source_dir+source_list[n];
	
	if (File.isDirectory(dir_name))
	{
		
		sub_name=dir_name+substring(source_list[n], 0, lengthOf(source_list[n])-1)+"_FL"+File.separator;
		sub_list=getFileList(sub_name);
		for (m=0; m<sub_list.length; m++)
		{
			fname=sub_name+sub_list[m];
			IJ.log(fname);
			run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			run("Save As Tiff", "save="+fname+".tif imp=["+getTitle()+"]");
			
			run("Close All");			
		}
	}
	
	
}
