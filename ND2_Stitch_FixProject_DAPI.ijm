correction_file = "S:/micro/cry/jle/smc/20210618_105258_084/DAPI_Correction.tif";

name=getArgument;
if (name=="")
{
    source_dir = getDirectory("Source Directory");
}
else
{
    source_dir=name;
}
setBatchMode(true);
source_list = getFileList(source_dir);


run("Write ND2 Tile Config", "channel=1 fusion=[Max. Intensity] actual=0.000 choose="+source_dir);
t=getTitle();
run("Split Channels");

selectWindow("C1-"+t);
run("Z Project...", "projection=[Max Intensity] all");
run("32-bit");
rename("A");
selectWindow("C2-"+t);
run("Z Project...", "projection=[Max Intensity] all");
run("32-bit");
rename("B");
selectWindow("C3-"+t);
run("Project Best Z Slice");
rename("C");
run("Enhance Contrast", "saturated=0.35");
open(correction_file);
tt=getTitle();
run("32-bit");
selectWindow("C");
run("Correct Flatness Using Image", "correction="+tt);
run("Enhance Contrast", "saturated=0.35");

run("Merge Channels...", "c1=A c2=B c3=Result create");
run("Flip Vertically", "stack");
run("Flip Horizontally", "stack");
run("Save Multipage Image Sequence", "path="+source_dir+" save="+source_dir+"/Tiffs0000.tif");


run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+source_dir+" layout_file=out.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");

saveAs("Tiff", source_dir+"/Fused.tif");