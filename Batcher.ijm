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
    if (endsWith(fname, ".nd2"))
    {
        runMacro("U:/smc/Fiji_2016.app/macros/Quantify_InSitus_Using_DAPI_FGM.ijm", fname);
        /*IJ.log(fname);
        open(fname);
        t=getTitle();
        //run("16-bit");
        run("Make Composite");
		saveAs("Tiff", "S:/micro/brs/smc/Fish_DF_Test/Training/"+substring(t, 0, lengthOf(t)-4)+".tif");
		close();*/

        //csv = substring(fname, 0, lengthOf(fname)-4)+".csv";
        
        
        //run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        //run("AVI...", "open=["+fname+"] convert");

		//run("Save As Tiff", "save=["+substring(fname, 0, lengthOf(fname)-4)+"_renormed.tif]");
        {
        	//open(fname);
        	//makeRectangle(0, 4872, 4096, 4096);	
			//run("Crop");
			//run("Scale...", "x=0.5 y=0.5 width=6048 height=6720 interpolation=Bilinear average create");	
			/*makeRectangle(0, 1584, 3132, 3852);
			run("Crop");
			saveAs("Tiff", fname);*/
			
        	//run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        	//run("Z Project...", "projection=[Max Intensity]");
        	//run("Minimum...", "radius=1");

			/*open(fname);
			run("Scale...", "x=0.5 y=0.5 width=1024 height=1024 interpolation=Bilinear average create");
			run("Save As Tiff", "save=["+fname+"]");*/

        	//run("Save As Tiff", "save=["+fname+"_project.tif]");
            //runMacro("/n/core/micro/asa/fgm/smc/20190919_Screen/DeepLearn/FindAndCount.ijm", fname);
            /*if (!File.exists(csv))
            {
            	runMacro("U:/smc/Fiji_2016.app/macros/Quantify_InSitus_Using_DAPI.ijm", fname);
            }*/
            //runMacro("S:/micro/ksi/kz2132/0711-tissue bias/Separate.ijm", fname);
            //run("SIMR Nd2 Reader", "imagefile="+fname);
            /*open(fname);
            run("32-bit");
            run("Percentile Threshold", "percentile=30 snr=100");
            run("Save As Tiff", "save=["+fname+"]");*/
            /*run("Cellpose Infer", "source=["+fname+"] diameter=200 normalize=-1000 normalize_0=-2000 type=cyto");
            t=getTitle();
            open(substring(fname, 0, lengthOf(fname)-4)+"_mask.tif");
            tt=getTitle();
            run("8-bit");
			run("Merge Channels...", "c2="+tt+" c4="+t+" create");
			saveAs("Tiff", substring(fname, 0, lengthOf(fname)-4)+"_combined.tif");*/
            //runMacro("S:/micro/asa/cpa/smc/20210727_3PO_Sizes/Quantify_DAPI.ijm",fname);
            /*run("Cellpose Infer old", "source=["+fname+"] diameter=20 normalize=-1 normalize_0=-1 type=fish_20");
            roiManager("Save", substring(fname, 0, lengthOf(fname)-4)+".zip");*/
            //run("SIMR Nd2 Reader", "imagefile="+fname);
            /*open(fname);
            run("Duplicate...", "title=B duplicate channels=2");
			//run("Channels Tool...");
			run("Grays");
			run("Save As Tiff", "save="+substring(fname, 0, lengthOf(fname)-4)+"_CH2.tif");*/
			/*open(fname);
            t=getTitle();
            Stack.getDimensions(width, height, channels, slices, frames);
            run("Duplicate...", "duplicate range=27-52");
			run("Project Best Z Slice");
			//run("Brightness/Contrast...");
			run("Enhance Contrast", "saturated=0.35");
            run("Save As Tiff", "save=[S:/micro/rhn/jgw/20210609_ULT_IMARE-105663_More_mutants_fixed_H2O2/Tiff/DeepLearn/Cellpose/"+t+"_projected.tif]");*/
            //runMacro("/n/core/micro/mg2/cyc/rla/cnidocyte_analysis/Volumes/Macro.ijm");
            /*run("Cellpose Infer", "source=["+fname+"] diameter=200 normalize=-1000 normalize_0=-2000 type=cyto");
            t=getTitle();
            open(substring(fname, 0, lengthOf(fname)-4)+"_mask.tif");
            tt=getTitle();
            run("8-bit");
            run("Merge Channels...", "c2="+tt+" c4="+t+" create");
            saveAs("Tiff", substring(fname, 0, lengthOf(fname)-4)+"_combined.tif");*/
 
        
			//t=getTitle();
			//run("Scale...", "x=.25 y=.25 width=2500 height=2500 interpolation=Bilinear average create");
			

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