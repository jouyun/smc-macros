
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
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
//for (m=0; m<2; m++) 
{
	if (File.isDirectory(source_dir+list[m]))
	{my_dir=source_dir+list[m]+File.separator;
	IJ.log(my_dir);
	base_name=File.getName(my_dir);
	run("Bio-Formats Importer", "open=["+my_dir+base_name+".mvd2] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
	rename("A");
	run("Bio-Formats Importer", "open=["+my_dir+base_name+".mvd2] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
	run("Z Project...", "projection=[Max Intensity]");
	rename("B");
	run("Merge Channels...", "c1=A c2=B create");
	saveAs("Tiff", my_dir+"Fused.tif");
	run("Close All");
	}
	
}
