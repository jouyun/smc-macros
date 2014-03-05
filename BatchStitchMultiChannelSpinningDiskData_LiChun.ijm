//This assumes you have a single reference channel, that it is the last channel acquired, and that it is the channel you want to stitch with
non_reference_channels=2;
file_extension=".ome.tiff";
scale_down=0;
//If have a reference image at the end set this to 1, if not set to 0
has_reference=1;

//If no reference, use this to tell which frame to use for stitching
channel_to_stitch_to=3;
slice_to_stitch_to=12;

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
parent_dir=File.getParent(source_dir);
tmp_dir=parent_dir+"\\tmp\\";
my_name=File.getName(source_dir);
File.makeDirectory(tmp_dir);
list = getFileList(source_dir);

/*If using folder structure to get tile settings*/
base_name=substring(my_name, 0, indexOf(my_name,"_"));
IJ.log(base_name);
x_tile=parseFloat(substring(my_name, indexOf(my_name, "_")+1, lastIndexOf(my_name, "_")));
y_tile=parseFloat(substring(my_name, lastIndexOf(my_name, "_")+1, lengthOf(my_name)));
number_files=list.length/x_tile/y_tile;


//x_tile=8;
//y_tile=8;
//base_name="test";
IJ.log("x: "+x_tile+ " y: "+y_tile);
	
first_file=base_name+"_"+x_tile+"_"+y_tile+" (raw tile 1)"+file_extension;
//first_file=base_name+" (raw tile 1)"+file_extension;
total_tiles=x_tile*y_tile;
IJ.log(source_dir+first_file);
open(source_dir+first_file);
total_slices=floor(nSlices/non_reference_channels);
if (has_reference==1)
{	
	total_frames=non_reference_channels*total_slices+1;
	frame_to_stitch=total_frames;
}
else
{
	total_frames=non_reference_channels*total_slices;
	frame_to_stitch=(channel_to_stitch_to-1)*total_slices+slice_to_stitch_to;
}
	

close();
	
run("Image Sequence...", "open=["+source_dir+first_file+"] number="+(total_tiles)+" starting=1 increment=1 scale=100 file=["+base_name+"_"+x_tile+"_"+y_tile+"] sort");
//run("Image Sequence...", "open=["+source_dir+first_file+"] number="+(total_tiles)+" starting=1 increment=1 scale=100 file=["+base_name+"] sort");
my_title=getTitle();
IJ.log("frames: "+total_frames);
IJ.log("slices: "+total_slices);

if (scale_down==1)
{
	run("Scale...", "x=.5 y=.5 z=1.0 width=512 height=672 depth="+nSlices+" interpolation=Bicubic average process create title=Temp");
	run("Correct Flatness", "xcenter=314 ycenter=300 xwidth=325 ywidth=325 background=100");
	//return;
	close(my_title);
	close("Temp");
	selectWindow("Result");
	my_title=getTitle();
}
else
{
	//run("Correct Flatness", "xcenter=628 ycenter=600 xwidth=650 ywidth=650 background=100");
	//close(my_title);
	//selectWindow("Result");
	//my_title=getTitle();
}
run("Stack to Hyperstack...", "order=xyczt(default) channels="+total_frames+" slices=1 frames="+total_tiles+" display=Grayscale");
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
run("Duplicate...", "title=t duplicate channels=1-"+total_tiles+" frames="+frame_to_stitch);
run("Concatenate...", "  title=Concat image1=t image2="+my_title+" image3=[-- None --]");
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
runMacro("SaveMultipageImageSequence.ijm", tmp_dir);
close();
//Simple way, no compute overlap
//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+x_tile+" grid_size_y="+y_tile+" tile_overlap=21 first_file_index_i=0 directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_4.registered.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
//Simple way, compute overlap
//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+x_tile+" grid_size_y="+y_tile+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_4.registered.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");

//Not simple way
height=y_tile;
width=x_tile;
if (height>1)
{
	for (i=0; i<height/2; i++)
	{
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2)+".tif");
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width+width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2+1)+".tif");
	}
	run("Close All");
	
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=1 grid_size_y="+height+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_dir+"] file_names=Fused{i}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
}
else
{
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(0*2*width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
}
	
//End not simple way


run("Delete Slice", "delete=channel");
setSlice(frame_to_stitch);
run("Delete Slice", "delete=channel");
run("Stack to Hyperstack...", "order=xyzct channels="+non_reference_channels+" slices="+total_slices+" frames=1 display=Grayscale");
saveAs("Tiff", parent_dir+"\\Fused_"+base_name+".tif");
close();
