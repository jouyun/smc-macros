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
		close();
}
