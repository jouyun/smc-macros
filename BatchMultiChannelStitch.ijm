grid_x=3;
grid_y=3;
overlap=40;
channel_to_stitch=2;

Dialog.create("BatchMultiStitch");
Dialog.addNumber("X grid size (0 assumes square):", 0);
Dialog.addNumber("Y grid size (0 assumes square):", 0);
Dialog.addNumber("Percent overlap:  ", 20);
Dialog.addChoice("Channel to use for stitching: ", newArray("1", "2", "3","4"));
Dialog.addChoice("Border merging strategy:  ", newArray("Max. Intensity", "Linear Blending"));
Dialog.show();
grid_x = Dialog.getNumber();
grid_y = Dialog.getNumber();
overlap=Dialog.getNumber();
channel_to_stitch=Dialog.getChoice();
blend_method=Dialog.getChoice();


source_dir = getDirectory("Source Directory");
setBatchMode(false);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	idx=lengthOf(list[m])-1;
	list[m]=substring(list[m],0,idx);
	file_path=source_dir+list[m]+"\\";
	current_file=file_path+list[m]+".mvd2_all.tif";
	IJ.log(current_file);	
	open(current_file);
	//run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
	title=getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);

	//Comment next two lines out if you want to 
	if (grid_x==0)
	{
		grid_x=sqrt(frames*slices);
		grid_y=grid_x;
	}
		


	my_directory=File.getParent(current_file);
	temp_folder=my_directory+"\\tmp\\";
	File.makeDirectory(temp_folder);
	

	compute_overlap=" compute_overlap";

	reg_file="TileConfiguration.registered.txt";
	/*Silly nonsense for no overlap cases, better to do another way
	compute_overlap="";
	overlap=0;
	reg_file="TileConfiguration.txt";*/
	
	//AIM
	//arrangement="[Grid: row-by-row] order=[Right & Down                ]";
	//Spinning Disk
	arrangement="[Grid: snake by rows] order=[Right & Up]";
	

	Stack.setChannel(channel_to_stitch);
	title=getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);
	Stack.getPosition(channel, slice, frame);
	
	
	run("Reduce Dimensionality...", "  frames keep");
	rename("Img");
	run("Image Sequence... ", "format=TIFF name=Img start=0 digits=4 save=["+temp_folder+"Img0000.tif]");
	close();
	run("Grid/Collection stitching", "type="+arrangement+" grid_size_x="+grid_x+" grid_size_y="+grid_y+" tile_overlap="+overlap+" first_file_index_i=0 directory=["+temp_folder+"] file_names=Img{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=["+blend_method+"] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50"+compute_overlap+" computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	rename("C"+channel+"Z"+slice);
	
	for (k=1; k<=slices; k++)
	{
		for (i=1; i<=channels; i++)
		{
			if (!(channel==i&&slice==k))
			{
				selectWindow(title);
				Stack.setChannel(i);
				Stack.setSlice(k);
				run("Reduce Dimensionality...", "  frames keep");
				run("Image Sequence... ", "format=TIFF name=Img start=0 digits=4 save=["+temp_folder+"Img0000.tif]");
				close();
				run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=["+temp_folder+"] layout_file="+reg_file+" fusion_method=["+blend_method+"] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
				rename("C"+i+"Z"+k);
			
			}	
		}
	}
	for (i=2; i<=channels; i++)
	{
		run("Concatenate...", "  title=C1Z1 image1=C1Z1 image2=C"+i+"Z1 image3=[-- None --]");
	}

	for (k=2; k<=slices; k++)
	{
		for (i=1; i<=channels; i++)
		{
			run("Concatenate...", "  title=C1Z1 image1=C1Z1 image2=C"+i+"Z"+k+" image3=[-- None --]");
		}
	}
	
	//Stack.setDimensions(channels,1,1);
	//Stack.setChannel(channel);
	//run("Make Composite", "display=Grayscale");
	rename("Fused");
	selectWindow(title);
	close();
	selectWindow("Fused");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames=1 display=Grayscale");

	Stack.setDisplayMode("composite");
	Stack.setChannel(1);
	run("Green");
	Stack.setChannel(2);
	run("Blue");
	Stack.setChannel(1);

	Stack.setDisplayMode("grayscale");
	
	saveAs("Tiff", current_file+".tif");

	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(1);
	saveAs("Tiff", current_file+"_contrasted.tif");
	title=getTitle();
	Stack.getDimensions(wid, hei, channels, slices, frames);
	run("Scale...", "x=.75 y=.75 z=1.0 width="+round(0.75*wid)+" height="+round(0.75*hei)+" depth=2 interpolation=Bilinear average title="+title);
	
	saveAs("Jpeg", current_file+".jpg");
	close();
	selectWindow(title);
	close();
}