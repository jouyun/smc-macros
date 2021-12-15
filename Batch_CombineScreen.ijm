name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	cur_file=source_dir+source_list[n];
	if (File.isDirectory(cur_file)==1)
	{
		list=getFileList(cur_file);
		for (m=0; m<list.length; m++) 
		{
			run("Close All");
			setBatchMode(false);
			IJ.log(cur_file+list[m]);
			if (endsWith(list[m],"_aligned.tif")==false&&endsWith(list[m],"_projection.tif")==true&&endsWith(list[m], ".tif")==true&&startsWith(list[m], "Plate"))
			{
				logs=runMacro("U:\\smc\\Fiji_2016.app\\macros\\Align_3D_Worms.ijm", cur_file+list[m]);
				//logs=runMacro("/n/projects/smc/Fiji_2016.app/macros/Align_3D_Worms.ijm", cur_file+list[m]);
			}
		}
		runMacro("U:\\smc\\Fiji_2016.app\\macros\\CombineScreens.ijm", cur_file);
		//logs=runMacro("/n/projects/smc/Fiji_2016.app/macros/CombineScreens.ijm", cur_file);
	}
}
run("Close All");
//run("Quit");