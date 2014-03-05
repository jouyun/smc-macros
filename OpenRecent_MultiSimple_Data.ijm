source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	sub_list=getFileList(source_dir+"\\"+list[m]);
	IJ.log(sub_list.length);
	for (j=0; j<sub_list.length; j++)
	{
		tmp=""+sub_list.length+".lsm";
		IJ.log(""+endsWith(sub_list[j], tmp));
		if (endsWith(sub_list[j], tmp))
		{
			IJ.log("Found one");
			open(source_dir+"\\"+list[m]+"\\"+sub_list[j]);
		}
	}
	/*for (j=0; j<list.length; j++)
	{
		
	}*/
}
