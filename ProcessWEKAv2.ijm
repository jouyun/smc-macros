
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
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
source_list = getFileList(source_dir);
//run("Trainable Weka Segmentation", "open=/n/projects/smc/public/SMC/WEKA/p53_16h_01/DAPI.tif");
//wait(300);

for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n]))
	{
		IJ.log(source_dir+source_list[n]);
		open(source_dir+source_list[n]+File.separator+"DAPI.tif");
		runMacro("/home/smc/Fiji.app/macros/ClassifierTest.js");
		saveAs("Tiff", source_dir+source_list[n]+File.separator+"Result_fast.tif");
		run("Close All");
	}
}
