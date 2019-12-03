x_dim=9;
y_dim=5;

fname=File.openDialog("");
dir=File.getParent(fname)+File.separator;
IJ.log(fname);
IJ.log(dir);


run("Bio-Formats Importer", "open="+fname+" autoscale color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
run("Z Project...", "projection=[Max Intensity] all");
rename("Projected");
run("32-bit");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=120 stack");
run("Z Project...", "projection=[Average Intensity]");
rename("Blurred");
run("Select All");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
run("Measure");
max=getResult("Max");
run("Divide...", "value="+max);
imageCalculator("Divide create stack", "Projected","Blurred");
run("Enhance Contrast", "saturated=0.35");
run("Enhance Contrast", "saturated=0.35");
run("Multiply...", "value=411 stack");
run("Enhance Contrast", "saturated=0.35");
run("Image Sequence... ", "format=TIFF name=A save="+dir+"A0000.tif");
run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=10 first_file_index_i=0 directory="+dir+" file_names=A{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
run("Enhance Contrast", "saturated=0.35");
