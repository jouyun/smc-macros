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
run("Clear Results");
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".czi")&&!(endsWith(fname, "_SIM².czi")))
    //if (endsWith(fname, "colored.czi"))
    {
    	
        //run("Cellpose Infer", "source="+fname+" diameter=60 normalize=-1 normalize_0=-1 type=cyto channel=2");

        IJ.log(fname);

        run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
		run("Z Project...", "projection=[Average Intensity] all");
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
		run("Scale...", "x=4 y=4 z=1.0 width=4096 height=4096 depth=23 interpolation=Bilinear average create");
		rename("Raw");
		sim_file = substring(fname, 0, lengthOf(fname)-4)+"_SIM².czi";
		run("Bio-Formats Importer", "open=["+sim_file+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		rename("SIM");
		run("Split Channels");
		selectWindow("Raw");
		run("Split Channels");
		run("Merge Channels...", "c1=[C1-Raw] c2=[C2-Raw] c3=[C3-Raw] c4=[C1-SIM] c5=[C2-SIM] c6=[C3-SIM] create");
		run("Save As Tiff", "save=["+substring(sim_file, 0, lengthOf(sim_file)-4)+".tif]");

        
        //run("Save As Tiff", "save=["+fname+".tif]");
        run("Close All");
    }
    //close();
}