x_dim=4;
y_dim=6;
slices=23;
channels=4;
tdir="D:\\tmp\\";

run("Stack to Hyperstack...", "order=xyzct channels="+channels+" slices="+slices+" frames="+(x_dim*y_dim)+" display=Grayscale");
run("32-bit");
run("Correct Flatness Using Sample");
setMinAndMax(0, 20);
run("16-bit");
run("Paste Projection To Front", "channel=4");
File.makeDirectory(tdir);
run("Save Multipage Image Sequence", "path="+tdir);
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i=0 directory="+tdir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=23 frames=1 display=Grayscale");
