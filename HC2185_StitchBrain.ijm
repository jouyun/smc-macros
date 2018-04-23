name=getArgument;

number_of_segments=13;
number_x_tiles=4;
number_y_tiles=5;

if (name=="")
{
	dir = getDirectory("Source Directory");
}
else
{
	dir=name;
}

s=0;
c=0;
for (i=0; i<(number_x_tiles*number_y_tiles); i++)
{
	for (ii=0; ii<number_of_segments; ii++)
	{
		run("Bio-Formats Importer", "open="+dir+"NDExp_Point"+IJ.pad(i,4)+"_Count000"+IJ.pad(ii,2)+"_Seq"+IJ.pad(i*number_of_segments+ii,4)+".nd2 autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	}
	Stack.getDimensions(w,h,c,s,f);
	run("Concatenate...", "all_open title=[Concatenated Stacks]");
	IJ.log(""+c+","+s);
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+(s*number_of_segments)+" frames=1 display=Color");
	run("Paste Projection To Front", "channel=1");
	run("Save As Tiff", "save="+dir+"Tiffs"+IJ.pad(i,4)+".tif");
	run("Close All");
}

//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+number_x_tiles+" grid_size_y="+number_y_tiles+" tile_overlap=15 first_file_index_i=0 directory="+dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+number_x_tiles+" grid_size_y="+number_y_tiles+" tile_overlap=15 first_file_index_i=0 directory="+dir+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+(number_of_segments*s)+" frames=1 display=Composite");
run("Save As Tiff", "save="+dir+"Fused.tif");