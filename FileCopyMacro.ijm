name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
cell1=source_dir+"flame_cell_3";
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	current_direc=source_dir+source_list[n];
	if (File.isDirectory(current_direc))
	{
		sub_list=getFileList(current_direc);
		for (m=0; m<sub_list.length; m++)
		{
			if (endsWith(sub_list[m],"3/"))
			{
				last_directory=current_direc+sub_list[m];
				my_list=getFileList(last_directory);
				for (i=0; i<my_list.length; i++)
				{
					my_file=last_directory+my_list[i];
					if (endsWith(my_file,".tif"))
					{
						IJ.log(last_directory+my_list[i]);
						File.copy(last_directory+my_list[i],cell1+File.separator+my_list[i]);
					}
				}
				
			}
		}
	}
}
