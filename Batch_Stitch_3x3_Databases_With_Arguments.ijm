arg=getArgument;
if (arg=="")
{
	source_dir = getDirectory("Source Directory");
	setBatchMode(false);
	base_filename=source_dir;
	IJ.log(base_filename);
	first_frame=0;
	source_dir=base_filename;
	source_list = getFileList(source_dir);
	last_frame=source_list.length-1;
}
else
{
	setBatchMode(true);
	uend=lastIndexOf(arg, "_");
	dend=lastIndexOf(arg, "-");
	base_filename=substring(arg, 0, uend);
	IJ.log(base_filename);
	first_frame=parseInt(substring(arg, uend+1, dend));
	last_frame=parseInt(substring(arg, dend+1, lengthOf(arg)));
	IJ.log(""+first_frame+" "+last_frame);
	source_dir=base_filename;
	source_list = getFileList(source_dir);

}

Array.sort(source_list);





for (n=first_frame; n<=last_frame; n++)
{

	my_dir=source_dir+source_list[n];
	runMacro("StitchSingleWorm3x3Database.ijm", my_dir);
}

