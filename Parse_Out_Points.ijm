//rename("tiffs");
grid_x=15;
grid_y=15;


name=getArgument;
if (name=="")
{
	source_directory=getDirectory("Source Directory");
}
else
{
	source_directory=name;
}
list = getFileList(source_directory);
number_points=list.length/grid_x/grid_y;

parent_directory=File.getParent(source_directory);
for (i=0; i<number_points; i++)
{
	run("Image Sequence...", "open=["+source_directory+"XY point 1 (raw tile 1).tif] number=1350 starting=1 increment=1 scale=100 file=[point "+(i+1)+"] or=[] sort");	
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+(frames*channels*slices/grid_x/grid_y)+" frames="+(grid_x*grid_y)+" display=Grayscale");
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Duplicate...", "title=blue duplicate slices="+slices+" frames=1-"+(grid_x*grid_y));
	selectWindow("tiffs");
	run("Duplicate...", "title=reds duplicate slices=1-"+(slices-1)+" frames=1-"+(grid_x*grid_y));
	
	Stack.getDimensions(width, height, channels, slices, frames);
	IJ.log(""+channels+","+slices+","+frames);
	run("Z Project...", "start=1 stop="+(slices)+" projection=[Max Intensity] all");
	rename("red");
	selectWindow("tiffs");
	close();
	selectWindow("reds");
	close();
	run("Concatenate...", "  title=combined image1=blue image2=red image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xytcz channels=2 slices=1 frames="+(grid_x*grid_y)+" display=Grayscale");
	my_name=File.getName(parent_directory)+"_Point"+(i+1);
	new_directory=parent_directory+"\\"+my_name;
	File.makeDirectory(new_directory);
	saveAs("Tiff", new_directory+"\\"+my_name+".mvd2.tif");
	close();
}



