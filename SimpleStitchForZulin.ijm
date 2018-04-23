x_dim=12;
y_dim=3;

name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}

run("Image Sequence...", "open="+source_dir+" sort");

run("32-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames="+(nSlices/3)+" display=Composite");
run("Correct Flatness Using Sample");

tmp_directory=source_dir+File.separator+"tmp"+File.separator;
File.makeDirectory(tmp_directory);
runMacro("SaveMultipageImageSequence.ijm", tmp_directory);

run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=7 first_file_index_i=0 directory="+tmp_directory+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
saveAs("Tiff", source_dir+File.separator+"Fused.tif");

run("Close All");