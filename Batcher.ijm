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
    //if (endsWith(fname, ".tif")&&!(endsWith(fname, "projection.tif"))&&!(endsWith(fname, "aligned.tif"))&&!(endsWith(fname, "combined.tif"))&&(indexOf(fname, "Plate")>-1 ) )
    if (endsWith(fname, ".tiff"))
    {
    	dir_name = substring(fname, 0, lengthOf(fname)-5)+File.separator;
    	File.makeDirectory(dir_name);
        //run("Cellpose Infer", "source="+fname+" diameter=60 normalize=-1 normalize_0=-1 type=cyto channel=2");

        IJ.log(dir_name);
        //run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        roiManager("reset");
        open(fname);
        t=getTitle();
		run("Duplicate...", "duplicate channels=3");
        run("Save As Tiff", "save=["+dir_name+t+"]");
        run("Close All");
    }
    //close();
}