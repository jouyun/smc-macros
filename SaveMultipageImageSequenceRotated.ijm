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
x_dim=3;
y_dim=3;
idx=0;
//For Vertical worms
//v=newArray(1, 6, 7, 2, 5, 8, 3, 4, 9);
//For horizontal worms
v=newArray(1, 2, 3, 6, 5, 4, 7, 8, 9);
for (f=0; f<frames/x_dim/y_dim; f++){
for (i=0; i<x_dim; i++)
{
	for (j=0; j<y_dim; j++)
	{
		run("Duplicate...", "title=tmp duplicate channels=1-"+channels+" slices=1-"+slices+" frames="+(f*9+v[idx%9]));	
		saveAs("Tiff", source_dir+"Tiffs"+IJ.pad((idx),4)+".tif");
		idx=idx+1;
		close();	
	}
	
}


}