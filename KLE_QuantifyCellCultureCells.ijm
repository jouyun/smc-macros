dir=getDirectory("Choose directory");
list=getFileList(dir);
for (i=0; i<list.length; i++)
{
	cur=dir+File.separator+list[i];
	if (File.isDirectory(cur))
	//if (startsWith(list[i], "Pos")&&endsWith(list[i], ".tif"))
	{
		open(cur+File.separator+"img_000000000_Default_000.tif");
		//open(cur);
		run("Gaussian Blur...", "sigma=5");
		run("Find Maxima...", "noise=200 output=[Count]");
		setResult("Folder", nResults-1, list[i]);
		close();
	}
}
