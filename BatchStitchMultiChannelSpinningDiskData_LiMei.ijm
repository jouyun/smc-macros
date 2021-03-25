x_tile=12;
y_tile=12;
channels=2;
channel_to_stitch_to=2;
slice_to_stitch_to=10;

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
//data_directory=source_dir+"Tiffs\\";
data_directory=source_dir;
//source_dir=File.getParent(source_dir);
tmp_directory=source_dir+"tmp\\";
worm_directory=source_dir+"Brain\\";
File.makeDirectory(tmp_directory);
File.makeDirectory(worm_directory);
list = getFileList(data_directory);
number_files=list.length/x_tile/y_tile;
IJ.log("Number files: "+number_files);
for (m=0; m<number_files-1; m++) 
{
	base_file_name="";
	//base_file_name="";
	first_file=base_file_name+" (raw tile 1).tif";
	total_tiles=x_tile*y_tile;
	IJ.log(data_directory+first_file);
	open(data_directory+first_file);
	total_slices=(nSlices)/channels;
	total_frames=channels*total_slices;
	frame_to_stitch=(channel_to_stitch_to-1)*total_slices+slice_to_stitch_to;
	frame_to_stitch=slice_to_stitch_to;

	close();
	run("Image Sequence...", "open=["+data_directory+first_file+"] number="+(total_tiles)+" starting=1 increment=1 scale=100 file=["+base_file_name+"] sort");
	my_title=getTitle();
	IJ.log("frames: "+total_frames);
	IJ.log("slices: "+total_slices);
	//run("Correct Flatness", "xcenter=628 ycenter=600 xwidth=650 ywidth=650 background=100");
	//close(my_title);
	//selectWindow("Result");
	my_title=getTitle();
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+total_frames+" slices=1 frames="+total_tiles+" display=Grayscale");
	run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
	run("Duplicate...", "title=t duplicate channels=1-"+total_tiles+" frames="+frame_to_stitch);
	run("Concatenate...", "  title=Concat image1=t image2="+my_title+" image3=[-- None --]");
	run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
	runMacro("SaveMultipageImageSequence.ijm", tmp_directory);
	close();
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_tile+" grid_size_y="+y_tile+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_4.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	run("Delete Slice", "delete=channel");
	run("Stack to Hyperstack...", "order=xyzct channels="+channels+" slices="+total_slices+" frames=1 display=Grayscale");
	saveAs("Tiff", worm_directory+"\\Brain"+(m+1)+".tif");
	close();
}
list = getFileList(tmp_directory);
for (m=0; m<list.length; m++) 
{
	File.delete(tmp_directory+File.separator+list[m]);
}