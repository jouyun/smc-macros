channel_to_stitch=2;
number_tiles_x=2;
number_tiles_y=2;
overlap=15;

f=File.openDialog("");
dir=File.getParent(f);
IJ.log(f);
IJ.log(dir);

run("Bio-Formats Importer", "open=["+f+"] autoscale color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
Stack.getDimensions(w,h,c,s,f);
run("16-bit");
run("Paste Projection To Front", "channel="+channel_to_stitch);
run("Save Multipage Image Sequence", "path=["+dir+"]");
run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+number_tiles_x+" grid_size_y="+number_tiles_y+" tile_overlap="+overlap+" first_file_index_i=0 directory=["+dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames=1 display=Composite");
