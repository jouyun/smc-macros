
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
source_list = getFileList(source_dir);
//run("Trainable Weka Segmentation", "open=/n/projects/smc/public/SMC/WEKA/p53_16h_01/DAPI.tif");
//wait(300);

for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n]))
	{
		IJ.log(source_dir+source_list[n]);
		run("Trainable Weka Segmentation", "open=/n/projects/smc/public/SMC/WEKA/p53_16h_01/DAPI.tif");
		wait(300);

		call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/n/projects/smc/public/SMC/WEKA/RealTrain_Edgesonly.model");
		call("trainableSegmentation.Weka_Segmentation.applyClassifier", source_dir+source_list[n], "DAPI.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
		selectWindow("Classification result");
		saveAs("Tiff", source_dir+source_list[n]+File.separator+"Result.tif");
		run("Close All");
	}
}
