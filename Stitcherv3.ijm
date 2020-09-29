channel_for_stitching=2;
//pixel_size=1.56;
pixel_size=0.78;
//pixel_size=0.39;
pixel_size=0.13;

name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}
IJ.log(source_dir);
setBatchMode(false);
list = getFileList(source_dir);
IJ.log(list[0]);

//Cleanup file names
for (m=0; m<list.length; m++)
{
	if (File.isDirectory(source_dir+list[m]))
	{
		IJ.log(source_dir+list[m]);
		sub_list=getFileList(source_dir+list[m]);
		for (n=0; n<sub_list.length; n++)
		{
 		    if (indexOf(sub_list[n],"Channel")>0)
 		    {
 		    	cur_file=source_dir+list[m]+sub_list[n];
 		    	IJ.log(cur_file);
 		    	//IJ.log("NDExp_"+substring(sub_list[n],0,36)+substring(sub_list[n],lengthOf(sub_list[n])-11,lengthOf(sub_list[n])));
 		    	new_file=source_dir+list[m]+File.separator+"NDExp_"+substring(sub_list[n],0,10)+substring(sub_list[n],lengthOf(sub_list[n])-11,lengthOf(sub_list[n]));
 		    	IJ.log(new_file);
 		    	File.rename(cur_file, new_file);
 		    	
 		    }
		}
	}
}
//Actual stitching
for (m=0; m<list.length; m++)
{
    if (File.isDirectory(source_dir+list[m])&&endsWith(list[m], "DL/")==0)
    {
        IJ.log(source_dir+list[m]);
        asdf=source_dir+list[m];
        IJ.log(substring(asdf, 0, lengthOf(asdf)-1)+".tif");

        tlist = getFileList(asdf);

		if (tlist.length>2) 
		{
			
	        run("Prepare Nikon Data v2", "channel="+channel_for_stitching+" fusion=[Max. Intensity] override actual="+pixel_size+" choose="+asdf);
	        run("Duplicate...", "duplicate channels="+channel_for_stitching);
	        run("Z Project...", "projection=[Max Intensity] all");
	        run("Save Multipage Image Sequence", "path="+asdf);
	        run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+asdf+" layout_file=out.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	        //return("");
	        selectWindow("Img");
	        Stack.getDimensions(width, height, channels, slices, frames);
	        run("Hyperstack to Stack");
	        run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels*slices)+" slices=1 frames="+frames+" display=Grayscale");
	        run("Save Multipage Image Sequence", "path="+asdf);
	        run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+asdf+" layout_file=out.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	        run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames=1 display=Grayscale");

			if (channels==5)
			{
		        run("Save As Tiff", "save=["+substring(asdf, 0, lengthOf(asdf)-1)+".tif]");
		        run("Z Project...", "projection=[Max Intensity]");
		        saveAs("Tiff", substring(asdf, 0, lengthOf(asdf)-1)+"_projection.tif");
			}
	        run("Close All");
		}
		else 
		{
			for (n=0; n<tlist.length; n++)
			{
				cur=source_dir+list[m]+tlist[n];
				if (endsWith(cur, "nd2"))
				{
					run("Bio-Formats Importer", "open=["+cur+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
					Stack.getDimensions(width, height, channels, slices, frames);
					if (channels==5)
					{
						run("Save As Tiff", "save=["+substring(asdf, 0, lengthOf(asdf)-1)+".tif]");
				        run("Z Project...", "projection=[Max Intensity]");
				        saveAs("Tiff", substring(asdf, 0, lengthOf(asdf)-1)+"_projection.tif");
					}
					run("Close All");
				}
			}
			
		}

    }
}

