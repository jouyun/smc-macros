number_of_channels=4;

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
	if (endsWith(source_list[n], ".tiff")==1)
	{
		open(source_dir+File.separator+source_list[n]);
		slices=nSlices/number_of_channels;
		run("Stack to Hyperstack...", "order=xyzct channels="+number_of_channels+" slices="+slices+" frames=1 display=Composite");
		setSlice(1);
		run("Green");
		run("Enhance Contrast", "saturated=0.35");
		setSlice(2);
		run("Red");
		run("Enhance Contrast", "saturated=0.35");
		setSlice(3);
		run("Blue");
		run("Enhance Contrast", "saturated=0.35");
		setSlice(4);
		run("Magenta");
		run("Enhance Contrast", "saturated=0.35");
		saveAs("Tiff", source_dir+File.separator+source_list[n]);
		close();
	}
}

