root_dir="/n/core/micro/asa/emd/smc/20180914_FAL_Coloc/Clone7_Spatial/";

file_list=getFileList(root_dir);
for (f=0; f<file_list.length; f++)
{
    run("Bio-Formats Importer", "open="+root_dir+file_list[f]+" color_mode=Default view=Hyperstack stack_order=XYCZT");
    t=getTitle();
    run("Gaussian Blur...", "sigma=2 stack");
    run("Subtract Background...", "rolling=50 stack");
    run("32-bit");
    run("find blob 3D mask subspots", "threshold=6000 minimum=500 max=30000 segment=2 quantify=1 filter=20 percentile=70");

    run("32-bit");
    selectWindow(t);
    run("add channel", "target=TempImg");
    run("Make Composite", "display=Grayscale");
    Stack.setDisplayMode("composite");
    Stack.setActiveChannels("1001");
    run("Magenta");
    Stack.setChannel(4);
    run("Grays");
    setMinAndMax(0, 1);

	run("Duplicate...", "title=A duplicate channels=3");
	setAutoThreshold("Default dark");
	setMinAndMax(0.000000000, 0.227450982);
	run("8-bit");

    Stack.getDimensions(ww,hh,cc,ss,ff);
    run("Properties...", "channels=1 slices="+ss+" frames=1 unit=um pixel_width=0.1 pixel_height=0.1 voxel_depth=0.29");
	run("3D Objects Counter", "threshold=128 slice=9 min.=5 max.=4718592 exclude_objects_on_edges statistics summary");
	selectWindow("Statistics for A");
	saveAs("Results", root_dir+file_list[f]+"_Puncta.csv");
	run("Close");

	selectWindow(t);
	run("Duplicate...", "title=B duplicate channels=2");
	setAutoThreshold("Default dark");
	setThreshold(3000.0000, 655333.0000);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Properties...", "channels=1 slices="+ss+" frames=1 unit=um pixel_width=0.1 pixel_height=0.1 voxel_depth=0.29");
	run("3D Objects Counter", "threshold=128 slice=9 min.=500 max.=4718592 statistics summary");
	selectWindow("Statistics for B");
	saveAs("Results", root_dir+file_list[f]+"_DAPI.csv");
	return("");
	run("Close");
    run("Close All");    
}


