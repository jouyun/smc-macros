grid_x=7;
grid_y=3;

/*name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}*/

current_file = File.openDialog("Source Worm");

setBatchMode(false);
run("Close All");

//for (m=0; m<list.length; m++)
{
	if (endsWith(current_file, ".nd2"))
	{
		fname=current_file;
		
		run("Bio-Formats Importer", "open=["+fname+"] color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		ctr=0;
		while (nImages>0)
		{
			selectImage(nImages);
			title=getTitle();
			run("Z Project...", "projection=[Max Intensity]");
			t=getTitle();
			run("Flip Horizontally", "stack");
			run("Flip Vertically", "stack");
			run("Save As Tiff", "save=["+current_file+"_"+IJ.pad(ctr,2)+".tif] imp=["+t+"]");
			ctr++;
			close();
			selectWindow(title);
			close();
		}
		run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+grid_x+" grid_size_y="+grid_y+" tile_overlap=20 first_file_index_i=0 directory="+File.getParent(current_file)+" file_names=["+File.getName(current_file)+"_{ii}.tif] output_textfile_name=TileConfiguration.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		run("Save As Tiff", "save=["+current_file+".tif] imp=["+getTitle()+"]");
		close();
	}
}
