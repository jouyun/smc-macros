
//run("Image Sequence...", "open=S:\\Microscopy\\USERS\\SMC\\Share\\AEC\\11132013_shift6\\piwi1_5G1_2d_1_tiled\\Tiffs\\Tiffs0000.tif number=16 starting=1 increment=1 scale=100 file=[] sort");
//

views=8;
x_grid=2;
y_grid=2;
chromatic_shift_slices=6;
bad_buffer=20;
channels=2;


current_file = File.openDialog("Source Raw");
base_dir=File.getParent(current_file)+File.separator;
IJ.log(base_dir);
green_dir=base_dir+"FinalGreen"+File.separator;
red_dir=base_dir+"FinalRed"+File.separator;
run("Raw...", "open="+current_file+" image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=80000 gap=0 little-endian");
//open(current_file);
slices=nSlices/x_grid/y_grid/views/channels;
run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+slices+" frames="+(x_grid*y_grid*views)+" display=Grayscale");
t=getTitle();

File.makeDirectory(green_dir);
File.makeDirectory(red_dir);
for (i=0; i<views; i++)
{
	selectWindow(t);
	Stack.getDimensions(w, h, c, s, f);
	idx=i*x_grid*y_grid+1;
	run("Duplicate...", "title=TiffsA duplicate channels=1-2 slices=1-"+s+" frames="+idx+"-"+(idx+x_grid+y_grid-1));
	current_directory=base_dir+"zTiffs"+i+File.separator;
	File.makeDirectory(current_directory);
	runMacro("SaveMultipageImageSequence.ijm", current_directory);
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_grid+" grid_size_y="+y_grid+" tile_overlap=50 first_file_index_i=0 directory="+current_directory+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	Stack.getDimensions(w, h, c, s, f);
	run("Duplicate...", "title=A duplicate channels=1 slices="+bad_buffer+"-"+(s-bad_buffer));
	selectWindow("Fused");
	run("Duplicate...", "title=B duplicate channels=2 slices="+(bad_buffer+chromatic_shift_slices)+"-"+(s-bad_buffer+chromatic_shift_slices));
	selectWindow("A");
	saveAs("Tiff", green_dir+"View"+IJ.pad(i*45,3)+".tif");
	close();
	selectWindow("B");
	saveAs("Tiff", red_dir+"View"+IJ.pad(i*45,3)+".tif");
	close();
	selectWindow("Fused");
	close();
	selectWindow("TiffsA");
	close();
}

