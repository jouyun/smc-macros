current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Image");
}
else
{
     //current_file=name;
}
dir=File.getParent(current_file);

run("Bio-Formats Importer", "open=["+current_file+"] color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
/*Stack.getDimensions(w,h,c,s,f);
run("Paste Projection To Front", "channel=1");
run("Save Multipage Image Sequence", "path=/n/core/micro/jeg/vps/smc/gH2Ax_DAPI/tmp");
run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=2 grid_size_y=2 tile_overlap=10 first_file_index_i=0 directory=/n/core/micro/jeg/vps/smc/gH2Ax_DAPI/tmp file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Delete Slice", "delete=channel");
Stack.setDisplayMode("grayscale");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames=1 display=Grayscale");
*/
saveAs("Tiff", substring(current_file, 0, lengthOf(current_file)-4)+".tif");
