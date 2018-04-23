source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
setBatchMode(true);
for (m=0; m<list.length; m++) {
	sub_list=getFileList(source_dir+File.separator+list[m]);
	IJ.log(sub_list.length);

	current_file=source_dir+File.separator+list[m]+File.separator+sub_list[0];
	IJ.log(current_file);
	for (i=0; i<6; i++)
	{
		idx=lengthOf(current_file)-4-i;
		IJ.log(substring(current_file,idx, idx+1)+" "+idx);
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
	for (j=1;j<sub_list.length-1; j++)
	//for (j=1;j<500; j++)
	{
		//open(source_dir+"\\"+list[m]+"\\"+sub_list[j]);
		open(base_file+(j+1)+".lsm");
		IJ.log(base_file+(j+1)+".lsm");
		tmp_title=getTitle();
		if (hyper) run("Hyperstack to Stack");
		run("Concatenate...", "  title="+title+" image1="+title+" image2="+tmp_title+" image3=[-- None --]");
	}
	if (stk) run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+(sub_list.length-1)+" display=Grayscale");
	tt=getTitle();
	saveAs("Tiff", source_dir+File.separator+tt+".tif");
	ttt=getTitle();

	run("Duplicate...", "title=A duplicate channels=1");
	run("Z Project...", "projection=[Max Intensity] all");
	selectWindow("A");
	close();
	selectWindow(ttt);
	run("Duplicate...", "duplicate channels=2 slices=10");
	tttt=getTitle();
	selectWindow(ttt);
	close();
	run("Merge Channels...", "c2=MAX_A c4="+tttt+" create");
	rename(ttt);
	run("Green");
	Stack.setChannel(2);
	run("Grays");
	Stack.setDisplayMode("composite");
	
	run("Enhance Contrast", "saturated=0.35");
	//setMinAndMax(0, 50000);
	saveAs("Tiff", source_dir+File.separator+"MAX_"+tt+".tif");
	run("Close All");
	
	//close();
	//selectWindow(ttt);
	//close();

}
