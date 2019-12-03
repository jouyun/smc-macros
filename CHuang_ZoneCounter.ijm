current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Image");
}
else
{
     //current_file=name;
}
roiManager("reset");

open(current_file);
roi_file=substring(current_file, 0, lengthOf(current_file)-17)+".zip";
open(roi_file);
run("Properties...", "channels=2 slices=1 frames=1 unit=pix pixel_width=1 pixel_height=1 voxel_depth=1");

run("Select All");
run("Delete Slice", "delete=channel");
setThreshold(129, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Ultimate Points");
setThreshold(1, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Divide...", "value=255");

roiManager("Select", 0);
run("Measure");
setResult("Zone", nResults-1, "A");

roiManager("Select", 1);
run("Measure");
setResult("Zone", nResults-1, "B");

roiManager("Select", 2);
run("Measure");
setResult("Zone", nResults-1, "C");
