arg=getArgument;
overlap=15;

temp_folder= getDirectory("temp");
File.makeDirectory(temp_folder);
//blend_method="Linear Blending";
blend_method="Max. Intensity";

compute_overlap=" compute_overlap";

reg_file="TileConfiguration.registered.txt";
/*Silly nonsense for no overlap cases, better to do another way
compute_overlap="";
overlap=0;
reg_file="TileConfiguration.txt";*/

//AIM
//arrangement="[Grid: row-by-row] order=[Right & Down                ]";
//Spinning Disk
arrangement="[Grid: column-by-column] order=[Up & Right]";

//setBatchMode(true);
title=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
Stack.getPosition(channel, slice, frame);



run("Reduce Dimensionality...", "  frames keep");
rename("Img");
run("Image Sequence... ", "format=TIFF name=Img start=0 digits=4 save=["+temp_folder+"Img0000.tif]");
close();
run("Grid/Collection stitching", "type="+arrangement+" "+arg+" tile_overlap="+overlap+" first_file_index_i=0 directory=["+temp_folder+"] file_names=Img{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=["+blend_method+"] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50"+compute_overlap+" computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
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
