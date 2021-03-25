run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=6 grid_size_y=3 tile_overlap=20 first_file_index_i=0 directory=C:\\Data\\SMC\\FlatnessFix\\test file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
Stack.setDisplayMode("grayscale");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
rename("A");
makeRectangle(40, 28, 5030, 3434);
run("Crop");
run("32-bit");
for (i=650; i>600; i-=100)
{
selectWindow("test");
//650 is best
run("Correct Flatness", "xcenter=628 ycenter=600 xwidth="+i+" ywidth="+i+" background=100");
run("Enhance Contrast", "saturated=0.35");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=18 display=Grayscale");
runMacro("SaveMultipageImageSequence.ijm", "C:\\Data\\SMC\\FlatnessFix\\Corrected\\");
close();
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=6 grid_size_y=3 tile_overlap=20 first_file_index_i=0 directory=C:\\Data\\SMC\\FlatnessFix\\Corrected file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Channels Tool...");
Stack.setDisplayMode("grayscale");
rename("B");
makeRectangle(40, 28, 5030, 3434);
run("Crop");
run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
}