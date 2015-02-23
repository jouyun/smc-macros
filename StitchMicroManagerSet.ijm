name=getArgument;
if (name=="")
{
	base_folder = getDirectory("Source Directory");
}
else
{
	base_folder=name;
}
list=getFileList(base_folder);
for (i=0; i<list.length; i++)
{
	source_dir=base_folder+File.separator+list[i];
	current_name=substring(list[i],0,lengthOf(list[i])-1);
	if (File.isDirectory(source_dir)&&!File.exists(base_folder+File.separator+current_name+".tif"))
{
	IJ.log(current_name);
	IJ.log(source_dir);
	sub_list=getFileList(source_dir);
	for (j=0; j<sub_list.length; j++)
	{
		if (indexOf(sub_list[j],"_0.ome")>1)
		{
			run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by image metadata] multi_series_file="+source_dir+sub_list[j]+" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap increase_overlap=0 invert_x invert_y computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
			
			saveAs("Tiff", base_folder+current_name+".tif");
			close();
		}
	}
}	
}
