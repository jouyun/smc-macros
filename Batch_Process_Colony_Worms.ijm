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
analysis_file=source_dir+"Analysis.csv";
f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+substring(source_list[n],0,lengthOf(source_list[n])-1)+"_tif"+File.separator;
		IJ.log(worm_dir);
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			if (endsWith(list[m],"composite.tif")==0)
			{
				IJ.log(worm_dir+list[m]);
				logs=runMacro("Process_LiChun_Colonies.ijm", worm_dir+list[m]);
				{
					peaks=logs;
					print(f, worm_dir+","+ list[m]+","+peaks);
				}
			}
		}
	}
}
File.close(f)
