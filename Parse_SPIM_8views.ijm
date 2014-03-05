Dialog.create("Multiview Reconstruction");
Dialog.addNumber("Z slices?", 300);
Dialog.addNumber("Angles?", 8);
Dialog.addNumber("Spacing of angles?", 45);
Dialog.addNumber("Frames to truncate from beginning?", 10);
Dialog.addNumber("Lateral resolution (um)?", 1.6);
Dialog.addNumber("Axial resolution (um)?", 3.2);
Dialog.addNumber("Chromatic shift between channels (in slices)?", 11);
Dialog.show();
z_slices=Dialog.getNumber();
angles=Dialog.getNumber();
angle_spacing=Dialog.getNumber();
frames_to_skip=Dialog.getNumber();
lateral_resolution=Dialog.getNumber();
axial_resolution=Dialog.getNumber();
chromatic_z_shift=Dialog.getNumber();

file_name=File.openDialog("Choose raw file");
directory=File.getParent(file_name)+"\\";
IJ.log(file_name);
IJ.log(directory);
red_directory=directory+"red_angles\\";
green_directory=directory+"green_angles\\";
output_directory=directory+"output\\";
red_output_directory=directory+"red_output\\";
green_output_directory=directory+"green_output\\";
File.makeDirectory(red_directory);
File.makeDirectory(green_directory);
run("Raw...", "open=["+file_name+"] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=10000000 gap=0 little-endian");
name=getTitle();
run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+z_slices+" frames="+angles+" display=Grayscale");
run("Properties...", "channels=2 slices="+z_slices+" frames="+angles+" unit=um pixel_width="+lateral_resolution+" pixel_height="+lateral_resolution+" voxel_depth="+axial_resolution+" frame=[0 sec] origin=0,0");
saveAs("Tiff", directory+name);
name=getTitle();
for (i=0; i<angles; i++)
{
	run("Duplicate...", "title=A duplicate channels=2 slices="+frames_to_skip+"-300 frames="+(i+1));
	saveAs("Tiff", directory+"Angle"+IJ.pad(i*angle_spacing,3)+".tif");
	saveAs("Tiff", red_directory+"Angle"+IJ.pad(i*angle_spacing,3)+".tif");
	close();
	selectWindow(name);
}
close();
run("Bead-based registration", "select_type_of_registration=Single-channel select_type_of_detection=Difference-of-Gaussian spim_data_directory=["+directory+"] pattern_of_spim=Angle{aaa}.tif timepoints_to_process=1 angles_to_process=0-"+((angles-1)*angle_spacing)+":"+angle_spacing+" bead_brightness=Strong subpixel_localization=[3-dimensional quadratic fit (all detections)] specify_calibration_manually xy_resolution=1.6 z_resolution=3.2 transformation_model=Affine select_reference=[Manually (interactive)]");
run("Multi-view fusion", "select_channel=Single-channel registration=[Individual registration of channel 0] fusion_method=[Fuse into a single image] process_views_in_paralell=All blending downsample_output=1 crop_output_image_offset_x=0 crop_output_image_offset_y=0 crop_output_image_offset_z=0 crop_output_image_size_x=0 crop_output_image_size_y=0 crop_output_image_size_z=0 fused_image_output=[Save 2d-slices, all in one directory]");
File.rename(output_directory,red_output_directory);
open(directory+name);
for (i=0; i<angles; i++)
{
	run("Duplicate...", "title=A duplicate channels=1 slices="+frames_to_skip+"-300 frames="+(i+1));
	t=getTitle();
	run("shift z and wrap", "shift="+chromatic_z_shift);
	saveAs("Tiff", directory+"Angle"+IJ.pad(i*angle_spacing,3)+".tif");
	saveAs("Tiff", green_directory+"Angle"+IJ.pad(i*angle_spacing,3)+".tif");
	close();
	selectWindow(t);
	close();
	selectWindow(name);
}
close();
run("Multi-view fusion", "select_channel=Single-channel registration=[Individual registration of channel 0] fusion_method=[Fuse into a single image] process_views_in_paralell=All blending downsample_output=1 crop_output_image_offset_x=0 crop_output_image_offset_y=0 crop_output_image_offset_z=0 crop_output_image_size_x=0 crop_output_image_size_y=0 crop_output_image_size_z=0 fused_image_output=[Save 2d-slices, all in one directory]");
File.rename(output_directory,green_output_directory);
run("Image Sequence...", "open=["+green_output_directory+"img_tl1_ch0_z0000.tif] number=8000 starting=1 increment=1 scale=100 file=[] sort");
rename("green");
run("Image Sequence...", "open=["+red_output_directory+"img_tl1_ch0_z0000.tif] number=8000 starting=1 increment=1 scale=100 file=[] sort");
Stack.getDimensions(width, height, channels, slices, frames);
rename("red");
run("Concatenate...", "  title=name image1=green image2=red image3=[-- None --]");
run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+slices+" frames=1 display=Grayscale");

title=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=tmp duplicate channels=1-2 slices="+round(0.25*slices)+"-"+round(0.75*slices));
selectWindow(title);
close();
selectWindow("tmp");
rename(name);