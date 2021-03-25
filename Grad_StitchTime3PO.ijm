dir="S:/micro/grad/smc/20181108_3PO_Timelapse/20181107_143507_421/";

num_points=8;
num_times=31;

point=0;
for (point=0; point<num_points; point++)
{
	for (time=0; time<num_times; time++)
	{
		seq=point+num_points*time;
		run("Bio-Formats Importer", "open="+dir+"NDExp_Time"+IJ.pad(time,5)+"_Point"+IJ.pad(point,4)+"_Seq"+IJ.pad(seq,4)+".nd2 autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");	
	}
	run("Concatenate...", "all_open open");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=37 frames="+num_times+" display=Grayscale");
	run("Save As Tiff", "save=S:/micro/grad/smc/20181107_3PO_Timelapse/20181106_172046_826/Point"+IJ.pad(point,4)+".tif");
	run("Close All");
	run("Collect Garbage");
}	
