tmp_directory="D:\\Data\\SMC\\LIM\\F228122-1\\Tiffs\\";
x_dim=10;
y_dim=10;
run("Bio-Formats Importer", "open=D:\\Data\\SMC\\LIM\\F228122-1\\F228122-1.mvd2 autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
t=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyzct channels="+(channels*slices)+" slices=1 frames="+(x_dim*y_dim)+" display=Grayscale");
runMacro("SaveMultipageImageSequence.ijm", tmp_directory);

run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=30 first_file_index_i=0 directory=D:\\Data\\SMC\\LIM\\F228122-1\\Tiffs file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_4.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+slices+" frames=1 display=Grayscale");
run("Save", "save=D:\\Data\\SMC\\LIM\\F228122-1\\Fused.tif");
run("Close All");