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
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".tif")&&!(endsWith(fname, "projection.tif"))&&!(endsWith(fname, "aligned.tif"))&&!(endsWith(fname, "combined.tif")) )
    {
    	
        //run("Cellpose Infer", "source="+fname+" diameter=60 normalize=-1 normalize_0=-1 type=cyto channel=2");

        IJ.log(fname);
        open(fname);
       
		t=getTitle();

		run("Duplicate...", "title=A duplicate channels=2");
		runMacro("U:/smc/Fiji_2016.app/macros/Spots.ijm");
		run("Z Project...", "projection=[Sum Slices]");
		run("Divide...", "value=255");
		run("Select All");
		rename(t+"_processed.tif");
		run("Measure");

		selectWindow("Composite");
        run("Save As Tiff", "save=["+fname+".tiff]");
        run("Close All");
    }
    //close();
}