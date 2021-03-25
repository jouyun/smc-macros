channel_for_stitching=2;
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
setBatchMode(false);
list = getFileList(source_dir);
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
			
	        run("Prepare Nikon Data For Stitch", "channel="+channel_for_stitching+" fusion=[Max. Intensity] override actual="+pixel_size+" choose="+asdf);
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
