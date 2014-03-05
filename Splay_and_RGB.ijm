flag=1;
original=getTitle();

if (!flag) base="Source-";
else base="Target-";

run("Crop");
run("32-bit");
run("Mean...", "radius=2 stack");
runMacro("Z_Splayed.ijm");
run("Properties...", "channels=32 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000 frame=[0 sec] origin=0,0");
rename(base+"Spectral");
runMacro("MakeRGBfromSpectral.ijm");
rename(base+"RGB");
selectWindow(base+"Spectral");
run("MakeNormalizedSpectra ");
run("Enhance Contrast", "saturated=0.35");
selectWindow(original);
close();