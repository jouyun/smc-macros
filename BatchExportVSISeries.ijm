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
		list[m]=substring(list[m], 0, lengthOf(list[m])-1);
		sub_list=getFileList(source_dir+list[m]+File.separator);
		for (n=0; n<sub_list.length; n++)
		{
			IJ.log(sub_list[n]);
			IJ.log(source_dir+list[m]+sub_list[n]);
			if (endsWith(sub_list[n], ".vsi"))
			{
				IJ.log(source_dir+list[m]+File.separator+sub_list[n]);
				run("Bio-Formats Importer", "open="+source_dir+list[m]+File.separator+sub_list[n]+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_5");

				Stack.getDimensions(width, height, channels, slices, frames);
				//if (height>width) run("Rotate 90 Degrees Right");

				//run("Scale...", "x=.5 y=.5 z=1.0 width=3373 height=10227 depth=3 interpolation=Bilinear average create");
				//run("Scale Bar...", "width=500 height=60 font=155 color=Black background=None location=[Lower Right] bold overlay label");
				rename("A");
				IJ.log("save="+source_dir+list[m]+".tif imp="+getTitle());				
				//run("Save As Tiff", "save="+source_dir+list[m]+".tif imp="+getTitle());
				run("Save As Tiff", "save="+source_dir+list[m]+File.separator+sub_list[n]+".tif imp="+getTitle());
				close();
				run("Close All");
			}
		}
	}
}



