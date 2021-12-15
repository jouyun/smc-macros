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
analysis_file=source_dir+"Analysis.txt";
f = File.open(analysis_file); // display file open dialog
print(f, "Folder"+","+ "File"+","+"Spots1,Spots2,Spots3,Area,DMax,Dmin,Smax,Smin");
//print(f, "Folder"+","+ "File"+","+"Spots1,Area,Intensity");
for (n=0; n<source_list.length; n++)
{
	cur_file=source_dir+source_list[n];
	if (File.isDirectory(cur_file)==1)
	{
		list=getFileList(cur_file);
		for (m=0; m<list.length; m++) 
		{
			run("Close All");
			setBatchMode(true);
			IJ.log(cur_file+list[m]);
			if (endsWith(list[m],"_projection.tif")==true&&endsWith(list[m], "mask.tif")==0&&endsWith(list[m],".tif")==1&&endsWith(list[m], "aligned.tif")==0&&endsWith(list[m], "combined.tif")==0&&endsWith(list[m], "ummary.tif")==0)
			{
				//if (!File.exists(cur_file+list[m]+"_processed.tif"))	runMacro("U:\\smc\\Fiji_2016.app\\macros\\SpotFinderv3.ijm", cur_file+list[m]);
				//else IJ.log("Skipped: "+cur_file+list[m]);
				//runMacro("/home/smc/Fiji.app/macros/SpotFinderv3.ijm", cur_file+list[m]);
				//logs=runMacro("ProjectSingleWorm.ijm", worm_dir+list[m]);
				logs=runMacro("/n/projects/smc/Fiji_2016.app/macros/ProcessSingleWormFindMaximaMultipleChannels.ijm", cur_file+list[m]);
				//logs=runMacro("U:\\smc\\Fiji_2016.app\\macros\\ProcessSingleWormFindMaximaMultipleChannels.ijm", cur_file+list[m]);
				//logs=runMacro("/n/projects/smc/Fiji_2016.app/macros/SpotFinderv3.ijm", cur_file+list[m]);
				//logs=runMacro("ProcessSingleWormFindMaximav2.ijm", worm_dir+list[m]);
				//logs=runMacro("Process_Fluorescent_Protonephridia_Wormv4.ijm", worm_dir+list[m]);
				comm=indexOf(logs,",");
				if (comm!=-1)
				{
					peaks=substring(logs,0,comm);
					area=substring(logs, comm+1,lengthOf(logs));
					print(f, cur_file+","+ list[m]+","+peaks+","+ area);
				}
			}
		}
	}
}
File.close(f)
run("Close All");
//run("Quit");