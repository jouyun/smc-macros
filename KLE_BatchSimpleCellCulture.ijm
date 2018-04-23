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

list = getFileList(source_dir);
ctr=0;
for (m=0; m<list.length; m++)
{
	cur_dir=source_dir+list[m];
	if (File.isDirectory(cur_dir))
	{
		run("Image Sequence...", "open="+cur_dir+" sort");
		run("32-bit");
		run("Histogram Normalize Percentile", "sample=1 percentile_max=99 percentile_min=10 mymax=255 mymin=0 whole");
		run("Save As Tiff", "save=["+source_dir+(ctr)+"_Screen.tif] imp="+getTitle());
		ctr++;
		close();
	}
}
