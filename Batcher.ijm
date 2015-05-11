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
for (n=0; n<source_list.length; n++)
{
	fname=source_dir+source_list[n];
	if (endsWith(fname, ".tif"))
	{
		IJ.log(fname);
		open(fname);
		//runMacro("Process_ZYU_EM_Data.ijm");

setSlice(1);		
run("Blue");
run("Enhance Contrast", "saturated=0.35");
setSlice(2);		
run("Green");
run("Enhance Contrast", "saturated=0.35");
setSlice(3);		
run("Red");
run("Enhance Contrast", "saturated=0.35");
		
		saveAs("Tiff", fname);
		close();
	}
}
