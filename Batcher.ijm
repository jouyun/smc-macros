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
    if (endsWith(fname, "SIM.czi"))
    {
        //run("Cellpose Infer", "source="+fname+" diameter=60 normalize=-1 normalize_0=-1 type=cyto channel=2");

        run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        t=getTitle();
        run("Save As Tiff", "save=["+substring(fname, 0, lengthOf(fname)-4)+".tif]");
        run("Close All");
    }
    //close();
}