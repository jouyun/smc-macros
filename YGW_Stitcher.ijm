name=getArgument;
if (name=="")
{
	dir = getDirectory("Source Directory");
}
else
{
	dir=name;
}

s=0;
for (i=0; i<15; i++)
{
	for (j=0; j<9; j++)
	{
		run("Bio-Formats Importer", "open="+dir+"NDExp_Point"+IJ.pad(i,4)+"_Count"+IJ.pad(j,5)+"_Seq"+IJ.pad(i*9+j,4)+".nd2 autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		//run("Bio-Formats Importer", "open="+dir+"NDExp_Point"+IJ.pad(i,4)+"_Count00001_Seq"+IJ.pad(i*15+1,4)+".nd2 autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
	}
	Stack.getDimensions(w,h,c,s,f);
	run("Concatenate...", "all_open title=[Concatenated Stacks]");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices="+(9*s)+" frames=1 display=Color");
	run("Paste Projection To Front", "channel=1");
	run("Save As Tiff", "save="+dir+"Tiffs"+IJ.pad(i,4)+".tif");
	run("Close All");
}
return("");
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=2 grid_size_y=2 tile_overlap=15 first_file_index_i=0 directory="+dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices="+(2*s)+" frames=1 display=Composite");
run("Save As Tiff", "save="+dir+"Fused.tif");