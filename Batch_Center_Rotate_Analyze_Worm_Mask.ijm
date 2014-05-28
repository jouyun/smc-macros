source_dir = getDirectory("Source Directory");
source_list = getFileList(source_dir);

for (n=0; n<source_list.length; n++)
{
	worm_dir=source_dir+source_list[n]+"Worms\\";
	list=getFileList(worm_dir);
	run("Clear Results");
	for (m=0; m<list.length; m++) 
	{
		current_file=worm_dir+list[m];
		IJ.log(current_file);
		runMacro("Center_Rotate_Analyze_Worm_MaskvManual.ijm", current_file);
	}
	idx=n;
	if (n<10) idx="0"+idx;
	if (n<100) idx="0"+idx;
	my_file=substring(source_list[n],0, lengthOf(source_list[n])-1);
	saveAs("Results", worm_dir+my_file+".dat");
}
