current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Image");
}
else
{
     //current_file=name;
}
fname=File.getName(current_file);
parent=File.getParent(File.getParent(current_file));
results_directory=parent+File.separator+"Results"+File.separator;
raws_directory=parent+File.separator+"Raws"+File.separator;

open(current_file);
run("Canvas Size...", "width=1024 height=1024 position=Center zero");
t=getTitle();

run("Raw...", "open=["+raws_directory+substring(fname, 0, lengthOf(fname)-4)+"_output.raw] image=8-bit width=512 height=512 number=1296420 little-endian");
Stack.getDimensions(width, height, channels, slices, frames);
run("32-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames="+(slices/2)+" display=Color");
run("Make Image From Windows", "width=1024 height=1024 slices="+(slices/18)+" staggered?");
run("Make Composite", "display=Composite");
run("Split Channels");
selectWindow("C1-NewImg");
run("Multiply...", "value=1 stack");
imageCalculator("Subtract create stack", "C2-NewImg","C1-NewImg");
selectWindow("Result of C2-NewImg");
//run("Brightness/Contrast...");
setMinAndMax(0, 254);
setThreshold(128.0000, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=100 max_size=-1");
run("3D Manager Options", "volume integrated_density mean_grey_value std_dev_grey_value mode_grey_value minimum_grey_value maximum_grey_value centroid_(pix) centre_of_mass_(pix) distance_between_centers=10 distance_max_contact=1.80 drawing=Contour");
run("3D Manager");
selectWindow("Seg");
Ext.Manager3D_AddImage();


selectWindow(t);
run("Split Channels");
Ext.Manager3D_Quantif();
Ext.Manager3D_DeselectAll();
Ext.Manager3D_SaveResult("Q",results_directory+current_file+".csv");
Ext.Manager3D_CloseResult("Q");
Ext.Manager3D_Close();

selectWindow("C1-NewImg");
setMinAndMax(0, 255);
run("16-bit");
run("Enhance Contrast", "saturated=0.35");

selectWindow("C2-NewImg");
setMinAndMax(0, 255);
run("16-bit");
run("Enhance Contrast", "saturated=0.35");

run("Merge Channels...", "c1=[C1-"+t+"] c2=[C2-"+t+"] c3=C1-NewImg c4=C2-NewImg c5=Seg create");
Stack.setActiveChannels("10001");
run("Magenta");
run("Save As Tiff", "save=["+results_directory+substring(fname, 0, lengthOf(fname)-4)+"_Results.tif]");