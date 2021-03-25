name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	cur_file=source_dir+source_list[n];
	if (File.isDirectory(cur_file)==1)
	{
		list=getFileList(cur_file);
		for (m=0; m<list.length; m++) 
		{
			run("Close All");
			setBatchMode(false);
			//IJ.log(cur_file+list[m]);
			//if (endsWith(list[m],"_aligned.tif")==false&&endsWith(list[m],"_mask.tif")==true&&endsWith(list[m], ".tif")==true&&startsWith(list[m], "Plate"))
			if (endsWith(list[m], "aligned.tif")==true)
			{
				//runMacro("u:\\smc\\Fiji_2016.app\\macros\\FGM_Align_Worms_QuantifyAxis.ijm", cur_file+list[m]);
				
				open(cur_file+list[m]);
				waitForUser("Hold shift to flip");
				if (isKeyDown("shift"))
				{
					run("Flip Horizontally", "stack");
				}
				run("Save");
				run("Close All");
			}
		}
	}
}
