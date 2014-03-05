my_file=File.openDialog("");
my_name=File.getName(my_file);
my_directory=File.getParent(my_file);
temp_folder=my_directory+"\\tmp\\";
File.makeDirectory(temp_folder);

Dialog.create("Batch Stitch");
Dialog.addNumber("Start with sample:", 1);
Dialog.addNumber("End with sample:", 1);
Dialog.addNumber("X grid size:", 3);
Dialog.addNumber("Y grid size:", 1);
Dialog.addNumber("Overlap percentage:  ",20);
Dialog.show();
startn=Dialog.getNumber();
endn=Dialog.getNumber();
grid_x = Dialog.getNumber();
grid_y = Dialog.getNumber();
overlap_percentage=Dialog.getNumber();
tiles_per_sample=grid_x*grid_y;

for (i=(startn-1); i<endn; i++)
{
	
	for (j=0; j<tiles_per_sample; j++)
	{
		series_name=" series_"+(i*tiles_per_sample+j+1);	
		//run("Bio-Formats Importer", "open=["+my_file+"] color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack"+series_name);
		run("Bio-Formats Importer", "open=["+my_file+"] color_mode=Default view=Hyperstack stack_order=XYCZT"+series_name);
		saveAs("Tiff", temp_folder+"A0"+j+".tif");	
		close();
	}
	this_directory=my_directory+"\\spot"+(i+1)+"\\";
	File.makeDirectory(this_directory);
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+grid_x+" grid_size_y="+grid_y+" tile_overlap=20 first_file_index_i=0 directory=["+temp_folder+"] file_names=A{ii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap use_virtual_input_images computation_parameters=[Save memory (but be slower)] image_output=[Write to disk] output_directory=["+this_directory+"]");
	source_list = getFileList(this_directory);
	for (n=0; n<source_list.length; n++)
	{
		path1=this_directory+source_list[n];
		File.rename(path1, path1+".tif");
	}
}
