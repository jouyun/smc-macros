name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
flag=true;
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (endsWith(fname, ".tif"))
	{
		open(fname);
		if (flag)
		{
			run("Select All");
			roiManager("Add");
			roiManager("Select", 0);
			roiManager("Delete");
			flag=false;			
			roiManager("Show All");
		}
		waitForUser;
		if (roiManager("Count")>0) roiManager("Save", substring(fname, 0, lengthOf(fname)-4)+".zip");
		nRois=roiManager("Count");
		for (i=0; i<nRois; i++)
		{
			roiManager("Select", 0);
			roiManager("Delete");
		}
		run("Close All");
	}
}
