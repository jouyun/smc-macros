name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
	plate=0;
	well=1;
}
else
{
	dE=indexOf(name, "-");
	IJ.log(""+dE);
	source_dir=substring(name, 0, dE)+File.separator;
	pE=indexOf(name, "-", dE+1);
	plate=parseFloat(substring(name, dE+1, pE));
	wE=indexOf(name, "-", pE+1);
	well=parseFloat(substring(name, pE+1, wE));
	IJ.log(source_dir+"..."+well);
}
//Parse plate and well

setBatchMode(false);
source_list = getFileList(source_dir);
saved_dir=source_dir+File.separator+"tiffs"+File.separator;
IJ.log(saved_dir);
File.makeDirectory(saved_dir);
tile_file=File.open(saved_dir+"TileConfig.txt");
print(tile_file, "dim = 2");

//bogus, will be reset later
minX=1000000000;
minY=1000000000;
low_mag_pixel_size=2.4;  
width=0;
height=0;
//CPA slides from 3-31 work well with low mag PFS 6200 and Highmag 6533, 12x20 rectange in well works
//Kristin slides with 20X:  5816/8231, with 60X:  5816/5451

//*******************BLOCK 1:  Open, export, catalog for stitching******************/
IJ.log("Am working on plate,well: "+plate+","+well);
well_name="Plate"+IJ.pad(plate,3)+"_Well"+well;
IJ.log("Guessing well name: "+well_name);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (indexOf(source_list[n],well_name)>-1&&endsWith(source_list[n], ".nd2"))
	{
		IJ.log(fname);
		run("Bio-Formats Importer", "open=["+fname+"] color_mode=Default view=Hyperstack stack_order=XYCZT");
		getPixelSize(unit, pw, ph, pd);
		run("Flip Horizontally");
		run("Flip Vertically");

		//Get out the X/Y positions of the center
		info=getImageInfo();
		x_label="m_dXYPositionX0 = ";
		y_label="m_dXYPositionY0 = ";
		z_label="m_dZPosition0";
		Xsidx=indexOf(info, x_label)+lengthOf(x_label);
		Xeidx=indexOf(info, y_label)-1;
		Ysidx=indexOf(info, y_label)+lengthOf(y_label);
		Yeidx=indexOf(info, z_label)-1;
		myX=parseFloat(substring(info, Xsidx, Xeidx));
		myY=parseFloat(substring(info, Ysidx, Yeidx));
		IJ.log("X,Y: "+myX+","+myY);

		//fixer=1.247;
		fixer=1;
		pixX=myX/pw/fixer;
		pixY=myY/ph/fixer;
		my_file=source_list[n]+".tif";
		print(tile_file, my_file+"; ; ("+pixX+", "+pixY+")");

		if (myX<minX) minX=myX;
		if (myY<minY) minY=myY;
		starting_pix_size=pw*fixer;
		width=getWidth();
		height=getHeight();

		
		saveAs("Tiff", saved_dir+my_file);
		close();
	}
}
File.close(tile_file);
run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=["+saved_dir+"] layout_file=TileConfig.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
//run("Flip Horizontally");
//run("Flip Vertically");
//return("");
//*******************BLOCK 2:  Segment******************/
runMacro("SegmentRobot.ijm");

//*******************BLOCK 3:  Create point list of areas to go back to, dump to file/directory******************/

//Configure settings
top_left_x=minX-width/2*starting_pix_size;
top_left_y=minY-height/2*starting_pix_size;
starting_mag=4;
final_mag=10;
overlap=20;
frame_size=2048;
pixel_threshold=0;
//10X correction
x_correction=233;
y_correction=-366;
//20X corrections
//x_correction=233;
//y_correction=-366-75-77;

//60X corrections
//x_correction=468;
//y_correction=-650;


IJ.log("Top left: "+top_left_x+","+top_left_y);

run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
run("Set Measurements...", "area mean min centroid center perimeter bounding fit redirect=None decimal=3");
run("Analyze Particles...", "size=0-Infinity show=Nothing display clear add");
number_results=nResults;
x_array=newArray(number_results);
y_array=newArray(number_results);
for (i=0; i<number_results; i++)
{
	//should probably multiply by starting_pix_size
	x_array[i]=(getResult("BX",i))*starting_pix_size;
	y_array[i]=(getResult("BY",i))*starting_pix_size;
	IJ.log("X,Y: "+x_array[i]+","+y_array[i]);
}
run("Clear Results");
ctr=0;
File.saveString(""+number_results, source_dir+"Count.txt");
for (i=0; i<number_results; i++)
{
	selectWindow("Segmented");
	roiManager("Deselect");
	run("Duplicate...","title=Seg");
	roiManager("Select",i);
	run("Clear Outside");
	run("Duplicate...", "title=A");
	selectWindow("Seg");
	close();
	selectWindow("A");
	scale=final_mag/starting_mag/frame_size/(1-overlap/100);
	//IJ.log("Scale: "+scale);
	big_pixel_size=frame_size*(1-overlap/100)*starting_pix_size*starting_mag/final_mag;
	//IJ.log("Big pixel_size: "+big_pixel_size);
	getDimensions(width, height, channels, slices, frames);
	small_pixels_per_big_pixel=1/scale;
	x_blocks=floor(width/small_pixels_per_big_pixel)+2;
	y_blocks=floor(height/small_pixels_per_big_pixel)+2;
	new_x=(x_blocks)*small_pixels_per_big_pixel;
	new_y=(y_blocks)*small_pixels_per_big_pixel;
	run("Canvas Size...", "width="+new_x+" height="+new_y+" position=Top-Left zero");
	maxer=0;
	x_max=0;
	y_max=0;
	//IJ.log("maxes: "+x_blocks+","+y_blocks);

	//Find max spots, remove it and the window around	
	run("Duplicate...", "title=C");
	flag=true;
	first_pass=true;
	
	//pixel_config_file=object_directory+"PixelConfig.csv";
	stage_config_file=source_dir+"Plate"+IJ.pad(plate,3)+"_Well"+well+"_Object"+(i)+"_StageConfig.csv";
	
	//File.open(stage_config_file);
	selectWindow("C");
	close();
	selectWindow("A");

	//Run one loop to count
	hits=0;
	for (x=0; x<x_blocks; x++)
	{
		for (y=0; y<y_blocks; y++)
		{
			makeRectangle(floor(x*small_pixels_per_big_pixel), floor(y*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
			getStatistics(area, mean, min, max, std, histogram);
			if (mean>pixel_threshold)
			{
				hits++;
			}
		}
	}

	xArray=newArray(hits);
	yArray=newArray(hits);
	tmp=0;
	//Run one loop for stage_config_file
	for (x=0; x<x_blocks; x++)
	{
		for (y=0; y<y_blocks; y++)
		{
			makeRectangle(floor(x*small_pixels_per_big_pixel), floor(y*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
			getStatistics(area, mean, min, max, std, histogram);
			if (mean>pixel_threshold)
			{
				tx=x_array[i]+(x+0.5)*big_pixel_size;
				ty=y_array[i]+(y+0.5)*big_pixel_size;
				setResult("X",ctr,tx);
				setResult("Y",ctr,ty);
				ctr++;

				//print(stage_config_file, ""+tx+","+ty);
				xArray[tmp]=tx+top_left_x+x_correction;
				yArray[tmp]=ty+top_left_y+y_correction;
				tmp++;				
			}

		}
	}
	Array.show(xArray,yArray);
	selectWindow("Arrays");
	saveAs("Results", stage_config_file);
	close("Arrays");
	IJ.log(stage_config_file);
	
	//File.close(stage_config_file);

	//Run one loop for pix_config_file
	/*tmp=0;
	for (x=0; x<x_blocks; x++)
	{
		for (y=0; y<y_blocks; y++)
		{
			makeRectangle(floor(x*small_pixels_per_big_pixel), floor(y*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
			getStatistics(area, mean, min, max, std, histogram);
			if (mean>pixel_threshold)
			{
				tx=x_array[i]+(x+0.5)*big_pixel_size;
				ty=y_array[i]+(y+0.5)*big_pixel_size;

			}

		}
	}*/

	//return("");
	selectWindow("A");
	close();
}
selectWindow("Segmented");
run("Properties...", "channels=1 slices=1 frames=1 unit=�m pixel_width="+starting_pix_size+" pixel_height="+starting_pix_size+" voxel_depth=2.4747");

//Useful helper function for viewing the tiles
overlap=0;
scale=final_mag/starting_mag/frame_size/(1-overlap/100);
//IJ.log("Scale: "+scale);
big_pixel_size=frame_size*(1-overlap/100)*starting_pix_size*starting_mag/final_mag;
//IJ.log("Big pixel_size: "+big_pixel_size);
getDimensions(width, height, channels, slices, frames);
small_pixels_per_big_pixel=1/scale;


num=nResults;

for (i=0; i<num; i++)
{
	x=parseFloat(getResult("X",i))/starting_pix_size-small_pixels_per_big_pixel/2;
	y=parseFloat(getResult("Y",i))/starting_pix_size-small_pixels_per_big_pixel/2;
	makeRectangle(floor(x), floor(y), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
	roiManager("Add");
}

run("Quit");

