x_dim=4;
y_dim=4;

fname=File.openDialog("Source Worm");
source_list = getFileList(File.getParent(fname));
for (i=0; i<source_list.length; i++)
{
	IJ.log(source_list[i]);
}
run("Image Sequence...", "open="+fname+" sort");
run("Image Sequence... ", "format=TIFF name=SJH_ save="+File.getParent(fname)+File.separator+"SJH_0000.tif");
run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Left] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=15 first_file_index_i=0 directory="+File.getParent(fname)+File.separator+" file_names=SJH_{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
