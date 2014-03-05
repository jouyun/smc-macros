
x_dim=13;
y_dim=13;
name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
		//setBatchMode(true);
		
		file_path=source_dir+list[m]+"\\";
		current_file=file_path+substring(list[m], 0, lengthOf(list[m])-1)+".mvd2";
		tmp_directory=source_dir+list[m]+File.separator+"tmp"+File.separator;
		IJ.log(current_file);	
		File.makeDirectory(tmp_directory);

		run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
		t=getTitle();
		Stack.getDimensions(width, height, channels, slices, frames);
		run("Hyperstack to Stack");
		run("Stack to Hyperstack...", "order=xyzct channels="+(channels*slices)+" slices=1 frames="+(x_dim*y_dim)+" display=Grayscale");
		runMacro("SaveMultipageImageSequence.ijm", tmp_directory);
		
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=30 first_file_index_i=0 directory="+tmp_directory+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_4.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+slices+" frames=1 display=Grayscale");
		run("Save", "save="+source_dir+list[m]+File.separator+"Fused.tif");
		run("Close All");
}
