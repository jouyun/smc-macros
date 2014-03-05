title=getTitle();
name=getArgument;
setBatchMode(true);
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
Stack.getDimensions(width, height, channels, slices, frames);
for (i=1; i<=frames; i++)
{
	run("Duplicate...", "title=tmp duplicate channels=1-"+channels+" slices=1-"+slices+" frames="+i);	
	saveAs("Tiff", source_dir+"Tiffs"+IJ.pad((i-1),4)+".tif");
	close();
}


