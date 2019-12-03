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
	if (endsWith(fname, "output.raw"))
	{
		IJ.log(fname);
		{
			run("Raw...", "open="+fname+" width=512 height=512 number=1000000 little-endian");
			run("32-bit");
			run("Hyperstack to Stack");
			run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=49 display=Grayscale");
			makeRectangle(64, 64, 384, 384);
			setBackgroundColor(0, 0, 0);
			run("Clear Outside", "stack");
			run("Make Image From Windows", "width=2048 height=2048 slices=1 staggered?");
			run("Duplicate...", "title=A duplicate channels=2");
			run("Save As Tiff", "save="+source_dir+source_list[n]+".tif"+" imp=A");
		}
		run("Close All");
	}
	//close();
}
