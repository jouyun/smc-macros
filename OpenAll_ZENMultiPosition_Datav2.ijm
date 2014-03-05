source_dir = getDirectory("Source Directory");
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
IJ.log(""+list.length);
for (m=0; m<list.length; m++) {
	if (File.isDirectory(source_dir+"\\"+list[m]))
	{
	sub_list=getFileList(source_dir+"\\"+list[m]);
	IJ.log(sub_list.length);

	current_file=source_dir+"\\"+list[m]+"\\"+sub_list[0];
	IJ.log(current_file);
	for (i=0; i<6; i++)
	{
		pad_to=lengthOf(sub_list[0])-5;
		current_file=source_dir+"\\"+list[m]+"\\t"+IJ.pad(1,pad_to)+".lsm";
	}
	IJ.log(current_file);
	run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	Stack.getDimensions(width, height, channels, slices, frames);
	rename("A");
	base_file=source_dir+"\\"+list[m]+"\\t";
	for (j=1;j<sub_list.length; j++)
	{
		//open(source_dir+"\\"+list[m]+"\\"+sub_list[j]);
		open(base_file+IJ.pad(j+1,pad_to)+".lsm");
		rename("B");
		run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
	}
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+(sub_list.length)+" display=Grayscale");
	Stack.setDisplayMode("grayscale");
	saveAs("Tiff", source_dir+substring(list[m], 0, lengthOf(list[m])-1)+".tif");
	close();
	}
}
