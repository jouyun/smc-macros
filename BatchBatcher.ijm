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
	cur_file=source_dir+source_list[n];
	IJ.log(cur_file);
	if (File.isDirectory(cur_file)==1)
	{
		runMacro("U:\\smc\\Fiji_2016.app\\macros\\Batcher.ijm", cur_file);
		//saveAs("Results", substring(cur_file,0,lengthOf(cur_file)-1)+".csv");
		//IJ.log(substring(cur_file,0,lengthOf(cur_file)-1)+".csv");
		//run("Clear Results");		
	}

}