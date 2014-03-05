
source_dir = getDirectory("Source Directory");
target_dir = getDirectory("Target Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	sub_list=getFileList(source_dir+"\\"+list[m]);
	IJ.log(sub_list.length);

	current_file=source_dir+"\\"+list[m]+"\\"+sub_list[0];
	for (i=0; i<6; i++)
	{
		idx=lengthOf(current_file)-4-i;
		IJ.log(substring(current_file,idx, idx+1));
		if (substring(current_file,idx, idx+1)=="T")
		{
			t_pos=i;
		}
	}
	base_file=substring(current_file,0,lengthOf(current_file)-t_pos-3);
	IJ.log(base_file);
	
	//open(source_dir+"\\"+list[m]+"\\"+sub_list[0]);
	open(base_file+"1.lsm");
	IJ.log(base_file+"1.lsm");
	title=getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);
	if (Stack.isHyperstack) hyper=true;
	else hyper=false;
	if (slices>1||channels>1) stk=true;
	else stk=false;
	if (hyper) run("Hyperstack to Stack");
	for (j=1;j<sub_list.length; j++)
	{
		//open(source_dir+"\\"+list[m]+"\\"+sub_list[j]);
		open(base_file+(j+1)+".lsm");
		tmp_title=getTitle();
		if (hyper) run("Hyperstack to Stack");
		run("Concatenate...", "  title="+title+" image1="+title+" image2="+tmp_title+" image3=[-- None --]");
	}
	if (stk) run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+sub_list.length+" display=Grayscale");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setDisplayMode("composite");
	run("Grays");
	Stack.setChannel(1);
	run("Green");
	saveAs("Tiff", target_dir+substring(list[m],0,lengthOf(list[m])-1));

	max=0;
	best_idx=0;
	for (i=0; i<slices; i++)
	{
		Stack.setSlice(i+1);
		run("Clear Results");
		run("Set Measurements...", "area mean standard min centroid center fit integrated display redirect=None decimal=3");
		run("Select All");
		run("Measure");
		val=getResult("StdDev", 0);
		if (val>max) 
		{
			max=val;
			best_idx=i;
		}
	}
	IJ.log("Max index at:"+best_idx);
	Stack.setSlice(best_idx+1);
	my_title=getTitle();
	Stack.getDimensions(my_width, my_height, my_channels, my_slices, my_frames);
	Stack.setChannel(2);
	run("Reduce Dimensionality...", "  frames keep");
	rename("T");
	selectWindow(my_title);
	Stack.setChannel(1);
	run("Reduce Dimensionality...", "  slices frames");
	run("Z Project...", "start=1 stop="+my_slices+" projection=[Max Intensity] all");
	rename("G");
	selectWindow(my_title);
	close();
	run("Concatenate...", "  title="+my_title+" image1=G image2=T image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xytzc channels=2 slices=1 frames="+my_frames+" display=Composite");
	run("Channels Tool...");
	Stack.setChannel(1);
	run("Green");
	Stack.setChannel(2);
	run("Grays");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", target_dir+substring(list[m],0,lengthOf(list[m])-1)+"_projected");
	close();
}













