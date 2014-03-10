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
analysis_file=source_dir+"Analysis.csv";
third_channel_file=source_dir+"SizeAnalysis.csv";
f = File.open(third_channel_file); 
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+"Worms\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			if (endsWith(list[m],"mask.tif")==0)
			{
				runMacro("ProcessThirdChannelWorm.ijm", worm_dir+list[m]);
				logs=getInfo("log");
				comm=indexOf(logs,",");
				blobs=substring(logs,0,comm);
				avg_area=substring(logs, comm+1,lengthOf(logs));
				print(f, worm_dir+","+ list[m]+","+blobs+","+ avg_area);
			}
		}
	}
}
File.close(f)
