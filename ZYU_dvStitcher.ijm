current_file = File.openDialog("Source dv");
par_dir=File.getParent(current_file);

run("Bio-Formats Importer", "open="+current_file+" autoscale color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=Tiffs save="+par_dir);
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=5 grid_size_y=3 tile_overlap=0 first_file_index_i=0 directory="+par_dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 invert_x invert_y computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display] use");
rename("Bottom");
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x=5 grid_size_y=2 tile_overlap=0 first_file_index_i=15 directory="+par_dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 invert_x invert_y computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display] use");
rename("Top");
run("Combine...", "stack1=Top stack2=Bottom combine");
