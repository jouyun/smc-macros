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
setBatchMode(false);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	if (endsWith(list[m],".tif"))
	{
		open(source_dir+list[m]);
		Stack.setChannel(2);
		t=getTitle();
		run("Profile Z Information");
		selectWindow(t);
		close(t);
	}
}
