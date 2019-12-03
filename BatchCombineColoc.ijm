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
    if (endsWith(fname, "DL.tif"))
    {
        IJ.log(fname);
        //open(fname);
        //run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        //run("AVI...", "open=["+fname+"] convert");
		//run("Save As Tiff", "save=["+fname+".tif]");
        {
        	//open(fname);
        	//run("Z Project...", "projection=[Max Intensity]");

        	//run("Save As Tiff", "save=["+fname+"_project.tif]");
            //runMacro("/n/projects/smc/Fiji_2016.app/macros/Align_3D_Worms.ijm", fname);
            runMacro("U:\\smc\\Fiji_2016.app\\macros\\CombineColocv3.ijm", fname);
        }
        //run("Save As Tiff", "save=["+fname+".tif]");
        run("Close All");
    }
    //close();
}