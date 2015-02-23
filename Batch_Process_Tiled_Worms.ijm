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
		worm_dir=source_dir+source_list[n]+"Worms"+File.separator;
		//worm_dir=source_dir+source_list[n]+"\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			if (endsWith(list[m],"mask.tif")==0)
			{
				logs=runMacro("ProcessSingleWormFindMaxima.ijm", worm_dir+list[m]);
				//logs=runMacro("Process_Fluorescent_Protonephridia_Wormv4.ijm", worm_dir+list[m]);
				comm=indexOf(logs,",");
				if (comm!=-1)
				{
					peaks=substring(logs,0,comm);
					area=substring(logs, comm+1,lengthOf(logs));
					print(f, worm_dir+","+ list[m]+","+peaks+","+ area);
				}
			}
		}
	}
}
File.close(f)
run("Close All");
run("Quit");