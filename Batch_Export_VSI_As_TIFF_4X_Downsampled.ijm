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
setBatchMode(true);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		
		worm_dir=source_dir+source_list[n];
		IJ.log(worm_dir);
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			IJ.log(worm_dir+list[m]);
			if ((endsWith(list[m],".vsi")==1) && (endsWith(list[m], "Overview.vsi")==false))
			{
				IJ.log("open="+worm_dir+list[m]+" color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
				run("Bio-Formats Importer", "open="+worm_dir+list[m]+" color_mode=Default view=Hyperstack stack_order=XYCZT series_3");
				a=getTitle();
				run("Stack to RGB");
				b=getTitle();
				saveAs("Tiff", substring(worm_dir, 0, lengthOf(worm_dir)-1)+".tif");
				close();
				selectWindow(a);
				close();
			}
		}
	}
}
run("Close All");

