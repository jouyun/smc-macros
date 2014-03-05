name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	
		idx=lengthOf(list[m])-1;
		list[m]=substring(list[m],0,idx);
		file_path=source_dir+list[m]+"\\";
		current_file=file_path+list[m]+".mvd2";
		IJ.log(current_file);	

		if (File.exists(current_file+".tif"))
		{
			open(current_file+".tif");
			//runMacro("PreProcess.ijm", "");
			tt=getTitle();
		}
		else
		{
			run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
			title=getTitle();
			Stack.getDimensions(width, height, channels, slices, frames)
			run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
			p_title=getTitle();
			selectWindow(title);
			close();
		
			selectWindow(p_title);
			saveAs("Tiff", current_file+".tif");

		}
		
		p_title=getTitle();
		new_directory=file_path+"Worms\\";
		IJ.log(new_directory);
		File.makeDirectory(new_directory);
		//run("merge objects in tiles", "snr=40 hit=1000 border=100 in=200 x=15 y=15 path=["+new_directory+"]");
		//Next worked until 1-28-2013, try 600 hits
		//run("merge objects in tiles", "snr=40 hit=400 border=100 in=20 x=18 y=18 path=["+new_directory+"]");
		//Failed o n2-6
		//run("merge objects in tiles", "snr=40 hit=600 border=100 in=20 x=15 y=15 path=["+new_directory+"]");
		//run("merge objects in tiles", "snr=20 hit=200 border=100 in=10 x=15 y=15 path=["+new_directory+"]");
		//Necessary for blue stitching when some batches are very dim auto
		run("merge objects in tiles", "snr=20 hit=200 border=100 in=10 x=15 y=15 path=["+new_directory+"]");

		selectWindow(p_title);
		close();
}