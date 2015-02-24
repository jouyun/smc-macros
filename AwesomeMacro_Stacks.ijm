first_file=getArgument;
if (first_file=="")
{
     first_file=File.openDialog("Pick one");
}
else
{
     //current_file=name;
}


source_dir = File.getParent(first_file);
parent_dir=File.getParent(source_dir);
tmp_dir=parent_dir+File.separator+"tmp"+File.separator;
IJ.log(""+tmp_dir);
File.makeDirectory(tmp_dir);
base_name=File.getName(first_file);

space=0;
current=0;
last=0;
temp=indexOf("abcdef", "g");
IJ.log(base_name);

while (indexOf(substring(base_name,current,lengthOf(base_name)),"_")>-1)
{
	last=current;
	IJ.log(substring(base_name,current,lengthOf(base_name)));
	current=indexOf(substring(base_name,current,lengthOf(base_name)),"_")+current+1;
}
space=indexOf(substring(base_name,current,lengthOf(base_name))," ")+current+1;
IJ.log("Found it: "+substring(base_name,last,current-1)+","+substring(base_name,current,space-1)+","+space);
width=parseInt(substring(base_name,last, current-1));
height=parseInt(substring(base_name,current,space-1));


//width=6;
//height=5;
number_images=width*height;

run("Image Sequence...", "open=["+first_file+"] number="+number_images+" starting=1 increment=1 scale=100 file=.tiff sort");
t=getTitle();
run("Stack to Hyperstack...", "order=xyczt(default) channels="+(nSlices/number_images)+" slices=1 frames="+number_images+" display=Grayscale");

run("Paste Channel To Front", "channel="+(nSlices/number_images)+" slice=1");

runMacro("SaveMultipageImageSequence.ijm", tmp_dir);

backwards=0;
if (backwards==1)
{
	for (i=0; i<height/2; i++)
	{
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Down] grid_size_x="+width+" grid_size_y=1 tile_overlap="+number_images+" first_file_index_i="+(i*2*width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2)+".tif");
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+width+" grid_size_y=1 tile_overlap="+number_images+" first_file_index_i="+(i*2*width+width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2+1)+".tif");
	}
	run("Close All");
	
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Down] grid_size_x=1 grid_size_y="+height+" tile_overlap="+number_images+" first_file_index_i=0 directory=["+tmp_dir+"] file_names=Fused{i}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
}
else
{
	/*
	for (i=0; i<height/2; i++)
	{
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2)+".tif");
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width+width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2+1)+".tif");
	}
	run("Close All");*/
	run("Close All");
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+width+" grid_size_y="+height+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	
}
//run("Delete Slice", "delete=channel");
return("");
run("Convert PE Reference Stack", "number=4");

Stack.getDimensions(width, height, channels, slices, frames);
run("Make Composite", "display=Composite");
Stack.setChannel(1);
Stack.setSlice(floor(slices/2));
run("Enhance Contrast", "saturated=0.35");
run("Green");
Stack.setChannel(2);
Stack.setSlice(floor(slices/2));
run("Enhance Contrast", "saturated=0.35");
run("Red");
Stack.setChannel(3);
Stack.setSlice(floor(slices/2));
run("Enhance Contrast", "saturated=0.35");
run("Magenta");
Stack.setChannel(4);
Stack.setSlice(floor(slices/2));
run("Enhance Contrast", "saturated=0.35");
run("Blue");
