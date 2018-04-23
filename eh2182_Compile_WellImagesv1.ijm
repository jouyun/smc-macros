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
codes=newArray("A", "B", "C", "D", "E", "F", "G", "H");

for (c=0; c<8; c++)
{
	for (r=0; r<12; r++)
	{
		was_one=false;
		for (i=0; i<400; i++)
		{
			sub_dir=codes[c]+(r+1)+"-Site_"+i;
			if (File.exists(source_dir+File.separator+sub_dir))
			{
				IJ.log(source_dir+File.separator+sub_dir+File.separator+"img_000000000_Default_000.tif");
				open(source_dir+File.separator+sub_dir+File.separator+"img_000000000_Default_000.tif");
				was_one=true;
			}
		}
		if (was_one)
		{
			run("Concatenate...", "all_open title=[Concatenated Stacks]");
			//run("Brightness/Contrast...");
			run("Enhance Contrast", "saturated=0.35");
			rename("t");
			run("Save As Tiff", "save="+source_dir+File.separator+codes[c]+(r+1)+".tif imp=t");
			run("Close All");
		}
	}
}
