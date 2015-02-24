first_file=File.openDialog("Pick one");
source_dir = File.getParent(first_file);
parent_dir=File.getParent(source_dir);
tmp_dir=parent_dir+File.separator+"tmp"+File.separator;
IJ.log(""+tmp_dir);
File.makeDirectory(tmp_dir);

width=6;
height=5;
number_images=width*height;

run("Image Sequence...", "open=["+first_file+"] number="+number_images+" starting=1 increment=1 scale=100 file=.tiff sort");
t=getTitle();
zslices=nSlices/number_images-1;
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+(nSlices/number_images)+" frames="+number_images+" display=Grayscale");
run("Duplicate...", "title=A duplicate slices="+(1)+" frames=1-"+number_images);
selectWindow(t);
run("Z Project...", "start=2 stop="+(zslices+1)+" projection=[Max Intensity] all");
rename("B");

run("Concatenate...", "  title=C image1=A image2=B image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytzc channels=2 slices=1 frames="+number_images+" display=Grayscale");
selectWindow(t);
close();
selectWindow("C");
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
	
	/*for (i=0; i<height/2; i++)
	{
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2)+".tif");
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+width+" grid_size_y=1 tile_overlap=20 first_file_index_i="+(i*2*width+width)+" directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		saveAs("Tiff", tmp_dir+"Fused"+(i*2+1)+".tif");
	}
	run("Close All");

	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=1 grid_size_y="+height+" tile_overlap="+number_images+" first_file_index_i=0 directory=["+tmp_dir+"] file_names=Fused{i}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	*/
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+width+" grid_size_y="+height+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_dir+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration_1.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	
}
