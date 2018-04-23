name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	IJ.log(fname);

	if (endsWith(fname, ".tif"))
	{
		open(fname);	

		setTool("wand");
		run("Wand Tool...", "tolerance=16 mode=Legacy");
		t=getTitle();
		while (roiManager("Count")<4)
		{
			wait(500);
		}
		roiManager("Measure");
		roiManager("Save", fname+t+".zip");
		for (i=0; i<4; i++)
		{
			roiManager("Select", 0);
			roiManager("Delete");
		}
		close();
	}
}





