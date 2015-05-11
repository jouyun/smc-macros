name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
IJ.log(source_dir);
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	file_path=source_dir+list[m];
	if (File.isDirectory(file_path))
	{
		worm_directory=file_path+"Worms"+File.separator;
		File.delete(worm_directory);
		File.makeDirectory(worm_directory);
		IJ.log(file_path);

		sub_list=getFileList(file_path);
		tile_file="";
		for (n=0; n<sub_list.length; n++)
		{
			if (endsWith(sub_list[n],"ome.tiff"))
			{
				tile_file=file_path+sub_list[n]+File.separator;
			}
		}
		IJ.log(tile_file);
		open(tile_file);
		t=getTitle();
		run("Max Project With Reference", "channels=3 frames=1");
		tt=getTitle();
		selectWindow(t);
		close();
		selectWindow(tt);
		rename(t);

		run("32-bit");
		run("Duplicate...", "duplicate range="+1);
		run("Percentile Threshold", "percentile=10 snr=30");
		run("Fill Holes");
		run("Open");
		run("Analyze Particles...", "size=100000-Infinity display clear add");
		num=roiManager("count");
		for (i=0; i<num; i++)
		{
			selectWindow(t);
			roiManager("Select", i);
			run("Duplicate...", "title=Worm"+(i+1)+".tif duplicate channels=1-4");
			saveAs("Tiff", worm_directory+"Worm"+(i+1)+".tif");
			close();
			
		}
		run("Close All");
	}
	
}
run("Quit");

