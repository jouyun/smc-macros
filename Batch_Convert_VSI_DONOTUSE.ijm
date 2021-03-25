

name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}
IJ.log(source_dir);
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++)
{
	if (File.isDirectory(source_dir+list[m]))
	{
		sub_list=getFileList(source_dir+list[m]);
		for (n=0; n<sub_list.length; n++)
		{
 		    if (endsWith(sub_list[n],".vsi"))
      		{
      			input_name=source_dir+list[m]+sub_list[n];
      			output_name=source_dir+list[m]+substring(list[m],0,lengthOf(list[m])-1)+".ome.tif";
      			IJ.log(input_name);
      			IJ.log(output_name);
      			if (!File.exists(output_name))
      			{
					run("Bio-Formats Importer", "open="+input_name+" color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
					run("RGB Color");
					run("Bio-Formats Exporter", "save="+output_name+" compression=Uncompressed");
					run("Close All");
      			}
      		}
		}
	}
}
run("Quit");