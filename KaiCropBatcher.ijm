cut_by=3;


name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(true);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (endsWith(fname, ".lsm"))
	{
		IJ.log(fname);
		open(fname);

		t=getTitle();
		Stack.getDimensions(width, height, channels, slices, frames);
		for (x=0; x<cut_by; x++)
		{
			for (y=0; y<cut_by; y++)
			{
				makeRectangle(0+x*floor(width/cut_by), 0+y*floor(height/cut_by), floor(width/cut_by), floor(height/cut_by));
				run("Duplicate...", "title=A duplicate");
				saveAs("Tiff", fname+"_"+x+"_"+y+".tif");
				close();
			}
		}
		run("Close All");
	}
}
