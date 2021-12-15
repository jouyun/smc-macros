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
list = getFileList(source_dir);
IJ.log(list[0]);

//Cleanup file names
for (m=0; m<list.length; m++)
{
	if (endsWith(list[m], ".nd2"))
	{
	IJ.log(source_dir+list[m]);
	IJ.log(substring(list[m], 15,19));
	idx = substring(list[m], 15,19);
	
	tmp = substring(list[m], 0, lengthOf(list[m])-8);
	IJ.log(tmp);
	new_file = tmp + idx + ".nd2";
	IJ.log(new_file);
   	File.rename(source_dir+list[m], source_dir+new_file);
		
	}
 		    	
}

for (i=1; i<5; i++)
{
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=5 grid_size_y=5 tile_overlap=9 first_file_index_i=0 directory="+source_dir+" file_names=[WellA"+i+"_PointA"+i+"_{iiii}_Channel450 nm,550 nm,640 nm_Seq{iiii}.nd2] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	saveAs("Tiff", source_dir+"A"+i+"_Fused.tif");
	run("Close All");
	//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=5 grid_size_y=5 tile_overlap=9 first_file_index_i=0 directory="+source_dir+" file_names=[WellB"+i+"_PointB"+i+"_{iiii}_Channel450 nm,550 nm,640 nm_Seq{iiii}.nd2] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	//saveAs("Tiff", source_dir+"B"+i+"_Fused.tif");
	//run("Close All");
}

