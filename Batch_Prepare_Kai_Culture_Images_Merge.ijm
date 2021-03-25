f_dir="/n/core/micro/asa/kle/smc/20171102_NIW_CellCulture/20171101_2";
s_dir="/n/core/micro/asa/kle/smc/20171102_NIW_CellCulture/20171101_3";

setBatchMode(true);
for (x=0; x<12; x++)
{
	for (y=0; y<24; y++)
	{
		
		curr_fdir=f_dir+File.separator+"2-Pos_"+IJ.pad(x,3)+"_"+IJ.pad(y,3)+File.separator;
		curr_sdir=s_dir+File.separator+"2-Pos_"+IJ.pad(x,3)+"_"+IJ.pad(y,3)+File.separator;
		p_dir=File.getParent(f_dir)+File.separator;
		IJ.log(p_dir);
		IJ.log(curr_fdir);
		run("Image Sequence...", "open="+curr_fdir+" sort");
		rename("A");
		run("Image Sequence...", "open="+curr_sdir+" sort");
		rename("B");
		run("Concatenate...", "  title=C image1=A image2=B image3=[-- None --]");
		run("32-bit");
		//run("Histogram Normalize Percentile", "sample=10 percentile_max=90 percentile_min=10 mymax=4096 mymin=0 whole");
		run("Histogram Normalize Percentile", "sample=1 percentile_max=99 percentile_min=10 mymax=255 mymin=0 whole");
		//run("Canvas Size...", "width=1344 height=1324 position=Bottom-Center zero");
		//run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
		run("Enhance Contrast", "saturated=0.35");
	
		p_dir=File.getParent(f_dir)+File.separator;
		saveAs("Tiff", p_dir+"2-Pos_"+IJ.pad(x,3)+"_"+IJ.pad(y,3)+".tif");
		run("Close All");
	}
}
