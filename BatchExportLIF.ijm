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
	if (endsWith(list[m], ".lif"))
	{
		fname=source_dir+list[m];
		run("Bio-Formats Importer", "open=["+fname+"] color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		while (nImages>0)
		{
			selectImage(nImages);
			title=getTitle();
			run("Save As Tiff", "save=["+source_dir+title+".tif] imp=["+title+"]");
			close();
		}
	}
}
