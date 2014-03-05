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
f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	/*if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+"Worms\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{*/
			if (endsWith(source_list[n],"mask.tif")==0&&(endsWith(source_list[n],".tif")==1))
			{
				logs=runMacro("Process_Fluorescent_Protonephridia_Wormv3.ijm", source_dir+source_list[n]);
				comm=indexOf(logs,",");
				if (comm!=-1)
				{
					peaks=substring(logs,0,comm);
					area=substring(logs, comm+1,lengthOf(logs));
					print(f, source_dir+","+ source_list[n]+","+peaks+","+ area);
				}
			}
		//}
	//}
}
File.close(f)
