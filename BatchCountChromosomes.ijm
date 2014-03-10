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
setBatchMode(false);
source_list = getFileList(source_dir);
//analysis_file=source_dir+"Analysis.csv";
//f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	starting_up=true;
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		my_dir=source_dir+source_list[n]+File.separator;
		my_name=source_list[n];
		my_name=substring(my_name, 0, lengthOf(my_name)-1);
		list=getFileList(my_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(false);
			if (endsWith(list[m],"mask.tif")==0)
			{
				logs=runMacro("ChromosomeCountingv2.ijm", my_dir+list[m]);
				if (starting_up)
				{
					rename(source_list[n]);
					starting_up=false;
				}
				else
				{
					run("Concatenate...", "  title=["+source_list[n]+"] image1=["+source_list[n]+"] image2=Final image3=[-- None --]");
				}
			}
		}
		saveAs("Tiff", source_dir+my_name+".tif");
		close();
	}
}
//File.close(f)
