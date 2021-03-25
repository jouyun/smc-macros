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
first_list = getFileList(source_dir);
for (m=0; m<first_list.length; m++)
{
	first_dir=source_dir+first_list[m];
	IJ.log(first_dir);
	if (File.isDirectory(first_dir)==1)
	{
		second_list = getFileList(first_dir);
		for (n=0; n<second_list.length; n++)
		{
			second_dir=first_dir+second_list[n];
			IJ.log(second_dir);
			if (File.isDirectory(second_dir)==1)
			{
				runMacro("U:\\smc\\Fiji_2016.app\\macros\\Batcher.ijm", second_dir);
			}
		}

	}

}