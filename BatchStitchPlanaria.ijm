source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	if (endsWith(list[m], ".tif_Files/") )
	{
		fname=substring(list[m], 0, lengthOf(list[m])-11);
		IJ.log(fname);
		current_directory=source_dir+list[m]+"\\";
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=18 grid_size_y=9 tile_overlap=10 first_file_index_i=0 directory=["+current_directory+"] file_names="+fname+"_p{iii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
		saveAs("Tiff", current_directory+"Fused.tif");
		close();

	}
}
