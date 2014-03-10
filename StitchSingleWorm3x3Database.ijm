grid_size=3;
channel_to_stitch_to=2;
stitch_channel_blend="[Linear Blending]";
//stitch_channel_blend="[Max. Intensity]";
//other_channel_blend="[Linear Blending]";
other_channel_blend="[Max. Intensity]";

if (channel_to_stitch_to==2) other_channel=1;
else other_channel=2;

x_dim=grid_size;
y_dim=grid_size;

//Set the file_paths here
file_path=getArgument;

if (file_path=="")
{
	file_path = getDirectory("Source Directory");;
}
else
{
	//current_file=name;
}


current_file=file_path+File.getName(file_path)+".mvd2";
IJ.log(current_file);	

if (File.exists(current_file+".tif"))
{
	open(current_file+".tif");
}
else
{
	run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");

	//Silly fix for Volocity/LOCI bug that will have a single tile show up as separate from the rest
	v=newArray(10,1000);
	number_imgs=0;
	main_idx=0;
	number_images=nImages;
	for (i=1; i<=number_images; i++) {
        	selectImage(i);
        	v[i-1]=getTitle();
        	number_imgs++;
        	if (Stack.isHyperStack) 
        	{
        		main_idx=i-1;
        		print(v[i-1]);
        	}
	}
	selectWindow(v[main_idx]);
	Stack.getDimensions(width, height, channels, slices, frames);
	selectWindow(v[main_idx]);
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
	rename("LR");
	selectWindow(v[main_idx]);
	close();
	selectWindow("LR");
	number_added=0;
	if (number_imgs>1)
	{
		for (i=0; i<number_imgs; i++)
		{
			if (i!=main_idx) 
			{
				selectWindow(v[i]);
				print(v[i]);
				mtitle=getTitle();
				gtitle=getTitle();
				gstart=indexOf(gtitle, "point")+6;
				gend=indexOf(substring(gtitle,gstart)," ")+gstart;
				point=parseInt(substring(gtitle, gstart, gend));
				gstart=indexOf(gtitle, "tile")+5;
				gend=indexOf(substring(gtitle,gstart),")")+gstart;
				tilenum=parseInt(substring(gtitle, gstart, gend));
				run("Duplicate...", "title=BB");
				selectWindow(mtitle);
				run("Delete Slice");
				run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
				rename("AA");
				selectWindow(mtitle);
				close();
				run("Concatenate...", "  title=[M] open image1=AA image2=BB image3=[-- None --]");
				Stack.setDimensions(2,1,1);
				insert_idx=(point-1)*x_dim*y_dim+tilenum-1+number_added;
				selectWindow("LR");
				run("Duplicate...", "title=[L] duplicate channels=1-2 frames=1-"+insert_idx);
				selectWindow("LR");
				run("Duplicate...", "title=[R] duplicate channels=1-2 frames="+(insert_idx+1)+"-"+(frames+number_added));
				selectWindow("LR");
				close();
				run("Concatenate...", "  title=LR open image1=L image2=M image3=R image4=[-- None --]");
				number_added++;
			}
		}
	}
	p_title=getTitle();
	//END Silly fix for Volocity/LOCI bug
			
		
	selectWindow(p_title);
	saveAs("Tiff", current_file+".tif");
	}
Stack.getDimensions(width, height, channels, slices, frames);
p_title=getTitle();
new_directory=file_path+"Worms\\";
tmp_directory=file_path+"tmp\\";
IJ.log(new_directory);
File.makeDirectory(new_directory);
File.makeDirectory(tmp_directory);
run("Duplicate...", "title="+p_title+"_tmp duplicate channels="+channel_to_stitch_to+" frames=1-"+frames);
chan_title=getTitle();
run("Image Sequence... ", "format=TIFF name="+chan_title+" start=0 digits=4 save=["+tmp_directory+chan_title+"0000.tif]");
selectWindow(chan_title);
close();
number_worms=frames/grid_size/grid_size;
for (j=1; j<=number_worms; j++)
{
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+grid_size+" grid_size_y="+grid_size+" tile_overlap=20 first_file_index_i="+((j-1)*grid_size*grid_size)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	rename("Worm"+j+".tif");
}

selectWindow(p_title);
run("Duplicate...", "title="+p_title+"_tmp duplicate channels="+other_channel+" frames=1-"+frames);
chan_title=getTitle();
run("Image Sequence... ", "format=TIFF name="+chan_title+" start=0 digits=4 save=["+tmp_directory+chan_title+"0000.tif]");
selectWindow(chan_title);
close();
for (j=1; j<=number_worms; j++)
{
	run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=["+tmp_directory+"] layout_file=TileConfiguration_"+j+".registered.txt fusion_method="+other_channel_blend+" regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	run("Concatenate...", "  title=[W] image1=Worm"+j+".tif image2=Fused image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=1 display=Grayscale");
	saveAs("Tiff", new_directory+"Worm"+j+".tif");
	close();
}
selectWindow(p_title);
close();