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
	file_path=source_dir+list[m]+File.separator;
	if (File.isDirectory(file_path))
	{
		worm_directory=file_path+"Worms"+File.separator;
		File.delete(worm_directory);
		File.makeDirectory(worm_directory);
		IJ.log(file_path);
		open(file_path+"Fused.tif");
	
		run("32-bit");
		selectWindow("Fused.tif");
		run("Duplicate...", "duplicate channels=4 slices=1");
		run("Percentile Threshold", "percentile=10 snr=30");
		run("Fill Holes");
		run("Open");
		run("Analyze Particles...", "size=100000-Infinity display clear add");
		num=roiManager("count");
		for (i=0; i<num; i++)
		{
			selectWindow("Fused.tif");
			roiManager("Select", i);
			run("Duplicate...", "title=Worm"+(i+1)+".tif duplicate channels=1-4");
			saveAs("Tiff", worm_directory+"Worm"+(i+1)+".tif");
			close();
			
		}
		run("Close All");
	}
	
}
run("Quit");

