name=getArgument;
if (name=="")
{
    source_dir = getDirectory("Source Directory");
}
else
{
    source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
count=0;
roiManager("reset");
pos_array=newArray(1+floor(source_list.length/2));
pos_array[0]=0;
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".tif"))
    {
        rname=substring(fname, 0, lengthOf(fname)-4)+".zip";
    	run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    	//rename("A");
    	open(rname);
    	pos_array[count+1]=roiManager("count");
    	count=count+1;
    }
}
run("Concatenate...", "all_open open");
for (f=0; f<count; f++)
{
	for (r=pos_array[f]; r<pos_array[f+1]; r++)
	{
		roiManager("Select", r);
		Stack.setFrame(f+1);
		roiManager("Update");        	
	}
}
