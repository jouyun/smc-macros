for (i=1; i<36; i=i+2)
{
	selectWindow("35_51");
	run("Duplicate...", "title=A duplicate channels="+(i+1));
	selectWindow("35_51C");
	run("Duplicate...", "title=B duplicate channels="+(i+1));
	run("Pairwise stitching", "first_image=A second_image=B fusion_method=[Linear Blending] fused_image=Img"+i+" check_peaks=5 compute_overlap subpixel_accuracy x=141.9506 y=149.0247 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
	run("Enhance Contrast", "saturated=0.35");
	selectWindow("A");
	close();
	selectWindow("B");
	close();
}