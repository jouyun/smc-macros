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
	cur_file=source_dir+source_list[n];
	if (File.isDirectory(cur_file)==1)
	{
		list=getFileList(cur_file);
		for (m=0; m<list.length; m++) 
		{
			run("Close All");
			setBatchMode(false);
			IJ.log(cur_file+list[m]);
			if (endsWith(list[m], "mask.tif")==0&&endsWith(list[m],"_projection.tif")==0&&endsWith(list[m], "processed.tif")==0&&endsWith(list[m],".tif")==1)
			{
				//if (!File.exists(cur_file+list[m]+"_processed.tif"))	runMacro("U:\\smc\\Fiji_2016.app\\macros\\SpotFinderv3.ijm", cur_file+list[m]);
				//else IJ.log("Skipped: "+cur_file+list[m]);
				//runMacro("/home/smc/Fiji.app/macros/SpotFinderv3.ijm", cur_file+list[m]);
				//logs=runMacro("ProjectSingleWorm.ijm", worm_dir+list[m]);
				
				runMacro("/home/smc/Fiji.app/macros/ProcessSingleWorm3D.ijm", cur_file+list[m]);
				//logs=runMacro("U:\\smc\\Fiji_2016.app\\macros\\ProcessSingleWormFindMaximaMultipleChannels.ijm", cur_file+list[m]);
				//logs=runMacro("/n/projects/smc/Fiji_2016.app/macros/SpotFinderv3.ijm", cur_file+list[m]);
				//logs=runMacro("ProcessSingleWormFindMaximav2.ijm", worm_dir+list[m]);
				//logs=runMacro("Process_Fluorescent_Protonephridia_Wormv4.ijm", worm_dir+list[m]);
				run("Close All");
			}
		}
	}
}
run("Close All");
//run("Quit");