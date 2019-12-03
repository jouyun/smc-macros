current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
open(current_file);

run("Fill Holes", "stack");

/*run("Gaussian Blur 3D...", "x=0.1 y=0.1 z=1");
setAutoThreshold("Default dark");
setThreshold(117, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=1000 max_size=-1");
setAutoThreshold("Default dark");
setThreshold(1, 65535);
run("Convert to Mask", "method=Default background=Dark black");
*/

Stack.getDimensions(width, height, channels, slices, frames);
run("Scale...", "x=.5 y=.5 z=1.0 width=994 height=994 depth="+slices+" interpolation=None average process create");
rename("T");

run("3D Watershed Split", "binary=T seeds=Automatic radius=10");
run("Scale...", "x=2 y=2 z=1 width=1988 height=1988 depth="+slices+" interpolation=None average process create");

run("3D Manager");
Ext.Manager3D_AddImage();
Ext.Manager3D_Measure();
Ext.Manager3D_SaveResult("M",substring(current_file, 0, lengthOf(current_file)-4)+"_Results.csv");
Ext.Manager3D_CloseResult("M");

selectWindow("Split-1");
run("Save As Tiff", "save="+substring(current_file, 0, lengthOf(current_file)-4)+"_3DCountMask.tif");
run("Close All");
/*run("3D Manager");
Ext.Manager3D_AddImage();
selectWindow("Final_Mask.tif");
selectWindow("Test.tif");
Ext.Manager3D_Select(14);
close();
selectWindow("Test.tif");
run("Hide Overlay");
Ext.Manager3D_Select(16);
*/