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
		
		worm_dir=source_dir+source_list[n]+File.separator;
		IJ.log(worm_dir);
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(false);
			
			
			IJ.log(worm_dir+list[m]);
			if (endsWith(list[m],"aligned.tif")==0&&endsWith(list[m], "projection.tif")==1)
			{
				runMacro("U:\\smc\\Fiji_2016.app\\macros\\Align_3D_Worms.ijm", worm_dir+list[m]);
			}
			run("Close All");
		}
	}
}
