dir=getDirectory("Choose");
list=getFileList(dir);
channels=2;
slices=8;
frames=9;
setBatchMode(true);
for (x=0; x<24; x++)
{
	for (y=0; y<24; y++)
	{
		base=IJ.pad(x,3)+IJ.pad(y,3);
		test=dir+File.separator+base+"-1-001001001.tif";
		if (File.exists(test))
		{
			for (f=1; f<frames+1; f++)
			{
				for (s=1; s<slices+1; s++)
				{
					for (c=1; c<slices+1; c++)
					{
						cur=dir+File.separator+base+"-"+f+"-001"+IJ.pad(s,3)+IJ.pad(c,3)+".tif";
						if (File.exists(cur))
						{
							open(cur);
						}
					}
				}
			}
			IJ.log("Good:  "+test);
			run("Concatenate...", "all_open title=[Concatenated Stacks]");
			if (nSlices==channels*slices*frames)
			{
				run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+frames+" display=Grayscale");
				rename(base);
				run("Z Project...", "projection=[Max Intensity] all");
				tt=getTitle();
				run("Duplicate...", "title=B duplicate frames=1");
				selectWindow(tt);
				run("Duplicate...", "title=A duplicate frames=2-5");
				selectWindow(tt);
				run("Duplicate...", "title=C duplicate frames=6-9");
				run("Concatenate...", "  title=ABC image1=A image2=B image3=C image4=[-- None --]");
				rename("Good");
				tmp=dir+File.separator+"tmp"+File.separator;
				File.makeDirectory(tmp);
				run("Save Multipage Image Sequence", "path="+tmp);
				run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=3 grid_size_y=3 tile_overlap=1 first_file_index_i=0 directory="+tmp+" file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
				Stack.setDisplayMode("grayscale");
				saveAs("Tiff", dir+File.separator+base+".tif");
				

			}
			else
			{
				IJ.log(test);

			}
			run("Close All");
			/*run("Bio-Formats Importer", "open="+test+" autoscale color_mode=Default group_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT axis_1_number_of_images=9 axis_1_axis_first_image=1 axis_1_axis_increment=1 axis_2_number_of_images=8 axis_2_axis_first_image=1 axis_2_axis_increment=1 axis_3_number_of_images=3 axis_3_axis_first_image=1 axis_3_axis_increment=1 contains=[] name="+dir+File.separator+IJ.pad(x,3)+IJ.pad(y,3)+"-<1-9>-00100<1-8>00<1-3>.tif");
			run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
			Stack.setDisplayMode("grayscale");
			Stack.getDimensions(w,h,c,s,f);
			IJ.log(""+c+","+s+","+f);
			run("Z Project...", "projection=[Max Intensity] all");
			waitForUser;
			run("Close All");*/
		}
	}
}
