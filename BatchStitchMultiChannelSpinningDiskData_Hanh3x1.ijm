


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
worm_dir=parent_dir+"\\Worms\\";
my_name=File.getName(source_dir);
File.makeDirectory(tmp_dir);
File.makeDirectory(worm_dir);
list = getFileList(source_dir);

x_tile=3;
y_tile=1;
number_worms=list.length/x_tile/y_tile;

//x_tile=8;
//y_tile=8;
//base_name="test";
IJ.log("x: "+x_tile+ " y: "+y_tile);

for (i=0; i<number_worms; i++)
{
	run("Image Sequence...", "open=["+source_dir+"XY point 1 (raw tile 1).ome.tiff] number=300 starting=1 increment=1 scale=100 file=[point "+(i+1)+" ] sort");
	run("Max Project With Reference", "channels=4 frames=3");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=3 display=Grayscale");
	runMacro("SaveMultipageImageSequence.ijm", tmp_dir);
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
	Stack.setDisplayMode("grayscale");
	saveAs("Tiff", worm_dir+"\\Worm"+(i+1)+".tif");
	run("Close All");
}
	
