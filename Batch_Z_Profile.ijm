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
		
		worm_dir=source_dir+source_list[n]+"Worms"+File.separator;
		IJ.log(worm_dir);
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(false);
			
			
			IJ.log(worm_dir+list[m]);
			if (endsWith(list[m],"aligned.tif")==0)
			{
				current_file=worm_dir+list[m];
				open(current_file);
				t=getTitle();
				run("Profile Z Information", " ");
				slide=File.getName(File.getParent(File.getParent(current_file)));
				rename(slide+"_"+File.getName(current_file));
				selectWindow(t);
				close();
			}
		}
	}
}


