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
codes=newArray("A", "B", "C", "D", "E", "F", "G", "H");

for (c=0; c<8; c++)
{
	for (r=0; r<12; r++)
	{
		was_one=false;
		for (i=0; i<400; i++)
		{
			sub_dir=codes[c]+(r+1)+"-Site_"+i;
			if (File.exists(source_dir+File.separator+sub_dir))
			{
				IJ.log(source_dir+File.separator+sub_dir+File.separator+"img_000000000_Default_000.tif");
				open(source_dir+File.separator+sub_dir+File.separator+"img_000000000_Default_000.tif");
				was_one=true;
			}
		}
		if (was_one)
		{
			run("Concatenate...", "all_open title=[Concatenated Stacks]");
			//run("Brightness/Contrast...");
			run("Enhance Contrast", "saturated=0.35");

			if (nSlices==18*18)
			{
				Stack.getmakeRectangle((1344-1024)/2, 0, 1024, 1024);
				run("Crop");
				run("Image Sequence... ", "format=TIFF name=IMG save="+source_dir+"IMG0000.tif");
				run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x=18 grid_size_y=18 tile_overlap=10 first_file_index_i=0 directory="+source_dir+" file_names=IMG{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	
				rename("t");
				run("Save As Tiff", "save="+source_dir+File.separator+codes[c]+(r+1)+".tif imp=t");
				run("Close All");

			}
		}
	}
}
