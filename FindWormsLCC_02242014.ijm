name=getArgument;
//setBatchMode(true);
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
parent_dir=File.getParent(source_dir);
worm_dir=parent_dir+File.separator+"Worms"+File.separator;
File.makeDirectory(worm_dir);
source_list = getFileList(source_dir);
ctr=0;
for (n=0; n<source_list.length; n++)
{
	open(source_dir+source_list[n]);
	t=getTitle();
	selectWindow(t);
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Z Project...", "start=1 stop=1 projection=[Max Intensity]");
	rename("dapi");
	selectWindow(t);
	run("Z Project...", "start=2 stop="+slices+" projection=[Max Intensity]");
	rename("h3p");
	run("Concatenate...", "  title=Both image1=dapi image2=h3p image3=[-- None --]");
	run("32-bit");
	selectWindow(t);
	close();
	selectWindow("Both");
	run("Percentile Threshold", "percentile=10 snr=20");
	run("Fill Holes");
	roiManager("reset")
	run("Analyze Particles...", "size=600000-Infinity circularity=0.00-1.00 show=Nothing add");
	close();
	for (i=0; i<roiManager("count"); i++)
	{
		selectWindow("Both");
		roiManager("Select", i);
		run("Duplicate...", "title=Worm duplicate range=1-2");	
		saveAs("Tiff", worm_dir+"Worm"+(ctr+1)+".tif");
		ctr++;
		close();
	}	
	selectWindow("Both");
	close();
}
