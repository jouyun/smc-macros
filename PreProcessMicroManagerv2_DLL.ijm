starting_mag=2.5;
starting_pix_size=2.4747;
final_mag=20;
overlap=20;
frame_size=2048;
pixel_threshold=0;
auto_threshold=100;


run("Colors...", "foreground=white background=black selection=yellow");
if (isOpen("Segmented"))
{
	selectWindow("Segmented");
	close();
}
//base_folder="C:\\Data\\";
base_folder="U:\\smc\\public\\SMC\\DLL_Test\\";
list=getFileList(base_folder);
source_dir=base_folder+"Untitled_"+list.length+File.separator;
sub_list=getFileList(source_dir);
good_idx=0;
for (n=0; n<sub_list.length; n++)
{
	if (indexOf(sub_list[n], "000_000")>0) 
	{
		good_idx=n;
	}
}

IJ.log(source_dir+sub_list[good_idx]);

run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by image metadata] multi_series_file="+source_dir+sub_list[good_idx]+" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 increase_overlap=0 invert_x invert_y computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
//run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by image metadata] multi_series_file="+"C:\\Data\\Untitled_44\\Untitled_44_MMStack_Pos0.ome.tif"+" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 increase_overlap=0 invert_x invert_y computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");

run("Flip Horizontally");
run("Flip Vertically");
run("32-bit");

//Segmentation code, can separate this out into own macro in future
run("Percentile Threshold", "percentile=10 snr=20");
setOption("BlackBackground", true);
run("Dilate");
//run("Analyze Particles...", "size=10000-Infinity show=Masks display exclude clear add");
run("Analyze Particles...", "size=100000-Infinity show=Masks display exclude clear add");

selectWindow("Mask of Result");
rename("Segmented");
run("Invert LUT");
selectWindow("Fused");
close();
selectWindow("Result");
close();
selectWindow("Segmented");
//End separable segmentation code

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
	IJ.log("Scale: "+scale);
	big_pixel_size=frame_size*(1-overlap/100)*starting_pix_size*starting_mag/final_mag;
	IJ.log("Big pixel_size: "+big_pixel_size);
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
	IJ.log("maxes: "+x_blocks+","+y_blocks);

	//Find max spots, remove it and the window around	
	run("Duplicate...", "title=C");
	flag=true;
	first_pass=true;
	while (flag)
	{
		maxer=0;
		for (x=0; x<x_blocks; x++)
		{
			for (y=0; y<y_blocks; y++)
			{
				makeRectangle(floor(x*small_pixels_per_big_pixel), floor(y*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
				getStatistics(area, mean, min, max, std, histogram);
				if (mean>maxer)
				{
					x_max=x;
					y_max=y;
					maxer=mean;
					IJ.log("New max: "+x_max+","+y_max+","+mean);
				}
			}
		}
		IJ.log("Maxer: "+maxer);
		if (!first_pass&&(maxer<auto_threshold))
		{
			flag=false;
			continue;
		}
		else
		{
		first_pass=false;
		setResult("X",ctr,x_array[i]+(x_max+0.5+random/3)*big_pixel_size);
		setResult("Y",ctr,y_array[i]+(y_max+0.5+random/3)*big_pixel_size);
		ctr++;
		IJ.log("Ctr: "+ctr);
		//Now clear out the area around it
		for (x=-2; x<3; x++)
		{
			for (y=-2; y<3; y++)
			{
				makeRectangle(floor((x+x_max)*small_pixels_per_big_pixel), floor((y+y_max)*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel)+1, floor(small_pixels_per_big_pixel)+1);
				run("Clear", "slice");				
			}
		}
		}
	}
	
	selectWindow("C");
	close();
	setResult("X",ctr,-1);
	setResult("Y",ctr,-1);
	ctr++;
	selectWindow("A");
	for (x=0; x<x_blocks; x++)
	{
		for (y=0; y<y_blocks; y++)
		{
			makeRectangle(floor(x*small_pixels_per_big_pixel), floor(y*small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel), floor(small_pixels_per_big_pixel));
			getStatistics(area, mean, min, max, std, histogram);
			if (mean>pixel_threshold)
			{
				setResult("X",ctr,x_array[i]+(x+0.5)*big_pixel_size);
				setResult("Y",ctr,y_array[i]+(y+0.5)*big_pixel_size);
				ctr++;
			}

		}
	}
	selectWindow("A");
	close();
	setResult("X",ctr,0);
	setResult("Y",ctr,0);
	ctr++;
}
selectWindow("Segmented");
run("Properties...", "channels=1 slices=1 frames=1 unit=�m pixel_width=2.4747 pixel_height=2.4747 voxel_depth=2.4747");

//Useful helper function for viewing the tiles
overlap=0;
scale=final_mag/starting_mag/frame_size/(1-overlap/100);
	IJ.log("Scale: "+scale);
	big_pixel_size=frame_size*(1-overlap/100)*starting_pix_size*starting_mag/final_mag;
	IJ.log("Big pixel_size: "+big_pixel_size);
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
saveAs("Results", base_folder+"Results.csv");
run("Quit");
