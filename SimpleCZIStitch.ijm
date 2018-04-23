x_dim=2;
y_dim=2;

filename=File.openDialog("Choose czi");
fileparent=File.getParent(filename);
tmpdir=fileparent+"/tmp/";
File.makeDirectory(tmpdir);

run("Bio-Formats Importer", "open=["+filename+"] color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
Stack.getDimensions(width, height, channels, slices, frames) ;
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels*slices)+" slices=1 frames="+frames+" display=Grayscale");
run("Save Multipage Image Sequence", "path="+tmpdir);
run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=2 grid_size_y=2 tile_overlap=10 first_file_index_i=0 directory=["+tmpdir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+slices+" frames=1 display=Composite");
run("Blue");
