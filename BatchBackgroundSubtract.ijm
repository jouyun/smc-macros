
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
	cur_file=source_dir+source_list[n];
	if (File.isDirectory(cur_file)==1)
	{
		list=getFileList(cur_file);
		for (m=0; m<list.length; m++) 
		{
			IJ.log(cur_file+list[m]);
			if (endsWith(list[m],"nd2")==true)
			{
				run("SIMR Nd2 Reader", "imagefile="+cur_file+list[m]);
				run("Subtract Background...", "rolling=50");
				save_name = cur_file+list[m];
				save_name = substring(save_name, 0, lengthOf(save_name)-4)+".tif";
				run("Save As Tiff", "save="+save_name);
				run("Close All");
			}
		}
	}
}
