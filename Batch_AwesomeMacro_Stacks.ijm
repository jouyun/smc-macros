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
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		tiff_dir=source_dir+source_list[n]+"tiffs"+File.separator;
		//worm_dir=source_dir+source_list[n]+"\\";
		list=getFileList(tiff_dir);
		IJ.log(tiff_dir);
		runMacro("AwesomeMacrov2.ijm", tiff_dir+list[2]);
	}
}
run("Close All");
run("Quit");