name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	dir_name=source_dir+source_list[n]+File.separator;
	IJ.log(dir_name);
	if (File.isDirectory(dir_name))
	{
		IJ.log(dir_name);
		runMacro("U:\\smc\\Fiji_2016.app\\macros\\HC2185_StitchBrain.ijm", dir_name);
	}
	run("Close All");
	//close();
}
