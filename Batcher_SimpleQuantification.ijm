signal_channel=1;
DAPI_channel=3;

run("Clear Results");

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
    //if (endsWith(fname, ".tif")&&!(endsWith(fname, "projection.tif"))&&!(endsWith(fname, "aligned.tif"))&&!(endsWith(fname, "combined.tif"))&&(indexOf(fname, "Plate")>-1 ) )
    if (endsWith(fname, "projection.tif"))
    {
        IJ.log(fname);
        open(fname);
        
		roiManager("reset");
		t=getTitle();
		run("Duplicate...", "title=DAPI duplicate channels="+DAPI_channel);
		run("32-bit");
		run("Percentile Threshold", "percentile=15 snr=60");
		run("Fill Holes");
		run("Analyze Particles...", "size=1000-Infinity show=[Count Masks]");
		run("Mask Largest");
		setThreshold(1, 65535, "raw");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Analyze Particles...", "size=1000-Infinity add");
		selectWindow(t);
		run("Duplicate...", "title="+t+"_int duplicate channels="+signal_channel);
		run("Subtract Background...", "rolling=150 stack");
		roiManager("Select", 0);
		run("Measure");

    }        
        //run("Save As Tiff", "save=["+fname+".tif]");
    run("Close All");
    //close();
}