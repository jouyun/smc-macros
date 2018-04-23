channel_to_use_for_stitching=2;
x_dim=2;
y_dim=2;
use_random_tile=1;
//Set this =0 to do regular linear blending of tiles

source_dir = getDirectory("Where Put Files?");
Stack.getDimensions(w, h, c, s, f);
run("Paste Projection To Front", "channel="+channel_to_use_for_stitching);
runMacro("SaveMultipageImageSequence.ijm", source_dir);

if (use_random_tile==1) run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i=0 directory="+source_dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Intensity of random input tile] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
else run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i=0 directory="+source_dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");

run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames=1 display=Grayscale");
run("Z Project...", "projection=[Max Intensity]");
