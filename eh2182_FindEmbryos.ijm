makeRectangle((1344-1024)/2, 0, 1024, 1024);
run("Crop");
run("Image Sequence... ", "format=TIFF name=IMG save=D:\\tmp\\tmp\\IMG0000.tif");
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x=18 grid_size_y=18 tile_overlap=10 first_file_index_i=0 directory=D:\\tmp\\tmp file_names=IMG{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
/*
run("Duplicate...", " ");
run("Invert");
setThreshold(1583, 2100);
setOption("BlackBackground", true);
run("Convert to Mask");
for (i=0; i<10; i++)
{
	run("Dilate");
}

run("Analyze Particles...", "size=20000-Infinity exclude add");
close();
selectWindow("Fused");
roiManager("Select", 0);
run("Crop");
*/