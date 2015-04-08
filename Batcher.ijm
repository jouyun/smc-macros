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
	if (endsWith(fname, ".tif"))
	{
		open(fname);
		runMacro("ContrastColors.ijm");
		saveAs("Tiff", fname);
		close();
	}
}
