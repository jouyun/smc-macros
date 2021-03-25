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
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+"Worms"+File.separator;
		//worm_dir=source_dir+source_list[n]+"\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			if (endsWith(list[m],"mask.tif")==0&&endsWith(list[m],"composite.tif")==0&&endsWith(list[m],".xml")==0&&endsWith(list[m],"project.tiff")==0&&endsWith(list[m],".tif"))
			{
				current_file=worm_dir+list[m];
				open(current_file);
				t=getTitle();
				run("Z Project...", "projection=[Max Intensity]");
				saveAs("Tiff", current_file+"_max_project.tiff");
				close();
				selectWindow(t);
				close();
			}
		}
	}
}
run("Close All");
run("Quit");