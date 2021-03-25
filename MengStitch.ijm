x_tiles=8;
y_tiles=2;

//Get a file
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source mvd2");
}
else
{
     //current_file=name;
}
IJ.log(current_file);

//Create tmp directory
file_path=File.getParent(current_file)+File.separator;
tmp_directory=file_path+"tmp"+File.separator;
File.makeDirectory(tmp_directory);

//Open file
run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
original=getTitle();

//Correct flatness (can be eliminated)
run("32-bit");
run("Correct Flatness Using Sample");
flattened=getTitle();

//Project in Z
run("Z Project...", "projection=[Max Intensity] all");
project=getTitle();

//Export data for stitch
runMacro("SaveMultipageImageSequence.ijm", tmp_directory);


//Run stitch
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_tiles+" grid_size_y="+y_tiles+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Tiffs{iiii}.tif output_textfile_name=out1.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+x_tiles+" grid_size_y="+y_tiles+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Tiffs{iiii}.tif output_textfile_name=out1.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
stitched=getTitle();

selectWindow(original);
close();

/*selectWindow(flattened);
saveAs("Tiff", current_file+"_flattened.tif");
Stack.getDimensions(width, height, channels, slices, frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels*slices)+" slices=1 frames="+frames+" display=Color");
runMacro("SaveMultipageImageSequence.ijm", tmp_directory);
run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+tmp_directory+" layout_file=out1.registered.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
saveAs("Tiff", current_file+"_fused_flattened.tif");
close();*/

selectWindow(flattened);
close();
selectWindow(project);
close();
selectWindow(stitched);

//Do a background subtract
run("Subtract Background...", "rolling=50");
saveAs("Tiff", current_file+"_Fused.tif");