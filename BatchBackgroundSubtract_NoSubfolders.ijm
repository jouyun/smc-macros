
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
for (n=0; n<source_list.length; n++)
{
	cur_file=source_dir+source_list[n];
	//if (File.isDirectory(cur_file)==1)
	{
		//list=getFileList(cur_file);
		//for (m=0; m<list.length; m++) 
		{
			//IJ.log(cur_file+list[m]);
			if (endsWith(cur_file,"nd2")==true)
			{
				IJ.log(cur_file);
				run("SIMR Nd2 Reader", "imagefile="+cur_file);
				run("Gaussian Blur 3D...", "x=1 y=1 z=0.2");
				run("Subtract Background...", "rolling=50");
				save_name = cur_file;
				save_name = substring(save_name, 0, lengthOf(save_name)-4)+".tif";
				run("Save As Tiff", "save="+save_name);
				run("Close All");
			}
		}
	}
}
