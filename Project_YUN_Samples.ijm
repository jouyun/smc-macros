channels=2;
slices=50;
max_frames=30000;
frames=0;

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
open(source_dir+"out_aligned_cropped.tif");
run("Max Project Subsets", "frames=8");

saveAs("Tiff", source_dir+"/out_aligned_cropped_8slices.tif");
print("Image windows:");
     setBatchMode(true);
     for (i=1; i<=nImages; i++) {
        selectImage(i);
        print("   "+getTitle);