
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
		rna_dir=source_dir+source_list[n]+File.separator;
		list=getFileList(rna_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			movie_dir=rna_dir+list[m]+File.separator;
			if (File.isDirectory(movie_dir)==1)
			{
				parent=rna_dir;
				img_list=getFileList(movie_dir);
				run("Image Sequence...", "open=["+movie_dir+img_list[2]+"] sort");
				run("32-bit");
				t=getTitle();
				saveAs("Tiff", parent+File.separator+t);
				run("Percentile Threshold Stack", "percentile=50 snr=70");
				mask=getTitle();
				run("Analyze Particles...", "size=2000-12000 show=Masks display clear stack");
				part_mask=getTitle();
				run("Invert LUT");
				run("MTrack2 ", "minimum=1 maximum=999999 maximum_=10 minimum_=2 save show save=["+parent+File.separator+t+".csv]");
				selectWindow("Mask of Img labels");
				saveAs("Tiff", parent+File.separator+t+"_mask.tif");
				run("Close All");
			}
		}
	}
}




