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
	if (endsWith(fname, ".tiff"))
	{
		IJ.log(fname);
		open(fname);
		runMacro("ProcessWidefieldFRETv2.ijm");

		
		//saveAs("Tiff", fname);
		//close();
		run("Close All");
	}
}
