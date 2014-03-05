name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(true);
source_list = getFileList(source_dir);
analysis_file=source_dir+"Analysis.csv";
f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	worm_dir=source_dir+source_list[n]+"Worms\\";
	list=getFileList(worm_dir);
	for (m=0; m<list.length; m++) 
	{
		current_file=worm_dir+list[m];
		if (endsWith(current_file,"mask.tif"))
		{
			open(current_file);
			title=getTitle();
			if (nSlices==4) 
			{
				run("Duplicate...", "title=Mask");
				setAutoThreshold("Default dark");
				setOption("BlackBackground", true);
				run("Convert to Mask");
				run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear");
				area=getResult("Area", 0);
				selectWindow("Mask");
				close();
				selectWindow(title);
				setSlice(4);
				run("Duplicate...", "title=Peaks");
				setAutoThreshold("Default dark");
				run("Convert to Mask");
				run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear");
				number_peaks=nResults;
				selectWindow("Peaks");
				close();
				selectWindow(title);
				close();
				print(f, worm_dir+","+ list[m]+","+number_peaks+","+ area);
				//IJ.log("Had " + area+" area and " +number_peaks+" peaks.");
			}
		}
	}
}