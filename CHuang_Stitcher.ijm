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
list = getFileList(source_dir);
for (m=0; m<list.length; m++)
{
    if (File.isDirectory(source_dir+list[m]))
    {
	    run("Collect Garbage");
	    IJ.log(source_dir+list[m]);
	    asdf=source_dir+list[m];
	    IJ.log(substring(asdf, 0, lengthOf(asdf)-1)+".tif");

		//Cleanup file names
		
		sub_list=getFileList(source_dir+list[m]);
		for (n=0; n<sub_list.length; n++)
		{
 		    if (indexOf(sub_list[n],"Channel")>0)
 		    {
 		    	cur_file=source_dir+list[m]+sub_list[n];
 		    	IJ.log(cur_file);
 		    	//IJ.log("NDExp_"+substring(sub_list[n],0,36)+substring(sub_list[n],lengthOf(sub_list[n])-11,lengthOf(sub_list[n])));
 		    	p_start=0;
 		    	s_start=indexOf(sub_list[n], "Seq");
 		    	new_file=source_dir+list[m]+"NDExp_"+substring(sub_list[n],p_start,10+p_start)+substring(sub_list[n],s_start,s_start+7)+".nd2";
 		    	IJ.log(new_file);
 		    	File.rename(cur_file, new_file);
 		    	
 		    }
		}

	    
		run("Stitch Nikon Data v2", "channel=1 fusion=[Linear Blending]  override actual=0.39 choose=["+source_dir+list[m]+"]");
	    run("Save As Tiff", "save=["+substring(asdf, 0, lengthOf(asdf)-1)+".tif]");
	    run("Z Project...", "projection=[Max Intensity]");
	    saveAs("Tiff", substring(asdf, 0, lengthOf(asdf)-1)+"_MAX.tif");
	    run("Close All");
    }
}

 