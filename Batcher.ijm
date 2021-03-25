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
    if (endsWith(fname, ".tif"))
    {
        IJ.log(fname);
        //open(fname);
        //run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        //run("AVI...", "open=["+fname+"] convert");

		//run("Save As Tiff", "save=["+substring(fname, 0, lengthOf(fname)-4)+"_renormed.tif]");
        {
        	//open(fname);
        	//run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        	//run("Z Project...", "projection=[Max Intensity]");
        	//run("Minimum...", "radius=1");


        	//run("Save As Tiff", "save=["+fname+"_project.tif]");
            //runMacro("/n/core/micro/asa/fgm/smc/20190919_Screen/DeepLearn/FindAndCount.ijm", fname);
            runMacro("U:/smc/Fiji_2016.app/macros/VID_Align_QuantifySpots.ijm", fname);
            //runMacro("S:/micro/asa/fgm/smc/20190919_Screen/DeepLearn/FindAndMaskAndCount.ijm",fname);
            //runMacro("/n/core/micro/mg2/cyc/rla/cnidocyte_analysis/Volumes/Macro.ijm");
            //runMacro("S:/micro/asa/fgm/smc/20190919_Screen/DeepLearn/FindAndCount.ijm", fname);

			//t=getTitle();
			//run("Save As Tiff", "save=/n/core/micro/mg2/cyc/rla/cnidocyte_analysis/Tiffs/"+t+".tif");

            /*open(fname);
			run("Delete Slice", "delete=channel");
			run("Next Slice [>]");
			run("Delete Slice", "delete=channel");
			run("Next Slice [>]");
			run("Delete Slice", "delete=channel");
			run("Save");
			close();*/

        }
        
        //run("Save As Tiff", "save=["+fname+".tif]");
        run("Close All");
    }
    //close();
}