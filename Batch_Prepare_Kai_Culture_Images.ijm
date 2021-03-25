
name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}
setBatchMode(false);
second_dir="U:\\smc\\public\\KLE\\20161128_CellCulture\\20161128_Test_4\\";
imgNames=newArray("A","B","C","D");

list = getFileList(source_dir);
ctr=0;
for (m=0; m<list.length; m++)
{
	curr_dir=source_dir+"Pos"+m+File.separator;
	//curr2_dir=second_dir+"Pos"+m+File.separator;
	if (File.isDirectory(curr_dir))
	{
		IJ.log(curr_dir);
		ctr++;
		run("Image Sequence...", "open="+curr_dir+" sort");
		rename("AAA");
		//run("Image Sequence...", "open="+curr2_dir+" sort");
		//rename("BBB");
		//run("Concatenate...", "  title=P0 image1=AAA image2=BBB image3=[-- None --]");
		rename("P0");
		
		Stack.getDimensions(width, height, channels, slices, frames);
		//run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=5 frames="+((channels*slices*frames)/5)+" display=Grayscale");
		//run("Z Project...", "projection=[Max Intensity] all");
		run("32-bit");
		run("Histogram Normalize Percentile", "sample=40 percentile_max=90 percentile_min=10 mymax=255 mymin=0 whole");
		setSlice(100);
		run("Enhance Contrast", "saturated=0.35");
		//run("8-bit");
		rename(imgNames[(ctr-1)%4]);
		//run("StackReg", "transformation=Translation");
		//run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");

		if ((ctr-1)%4==3)
		{
			run("Combine...", "stack1=A stack2=B");
			rename("AA");
			run("Combine...", "stack1=C stack2=D");
			rename("BB");
			run("Combine...", "stack1=AA stack2=BB combine");
			run("Save As Tiff", "save=["+source_dir+(ctr-3)+"_Screen.tif] imp=[Combined Stacks]");
			//saveAs("Tiff", source_dir+(ctr-3)+"_Screen.tif");
			run("Close All");		
		}
		//saveAs("Tiff", curr_dir+"Screen.tif");
		//run("Close All");		
	}
}
