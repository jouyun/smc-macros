
source_dir = getDirectory("Source Directory");
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
saveAs("Tiff", "U:\\smc\\public\\MultiSimple\\SMC\\par1_gfp_010220131_concatenated\\"+substring(list[m],0,lengthOf(list[m])-1));
close();	
}













