number_channels=4;

name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(true);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n];
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			if (endsWith(list[m],"mask.tif")==0&&endsWith(list[m],"composite.tif")==0&&endsWith(list[m],".xml")==0&&endsWith(list[m],"tiff")==1)
			{
				current_file=worm_dir+list[m];
				open(current_file);
				Stack.getDimensions(width, height, channels, slices, frames);
				total=channels*slices*frames;
				run("Stack to Hyperstack...", "order=xyczt(default) channels="+number_channels+" slices="+(total/number_channels)+" frames=1 display=Color");
				saveAs("Tiff", current_file);
				close();
			}
		}
	}
}
