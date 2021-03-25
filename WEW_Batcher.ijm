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
	sub_dir=source_dir+File.separator+source_list[n];
	if (File.isDirectory(sub_dir))
	{
		s_list=getFileList(sub_dir);
		for (m=0; m<s_list.length; m++)
		{
			fname=sub_dir+File.separator+s_list[m];
			if (endsWith(fname, ".vsi"))
			{
				IJ.log(fname);
				runMacro("WEW_Finder.ijm", fname);
			}
		}
	}
}
