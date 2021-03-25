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
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".vsi"))
    {
        IJ.log(fname);
        idx=8;
        ctr=1;
        while (idx<500)
        {
        	run("Bio-Formats Importer", "open="+fname+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_list="+(idx));
        	if (isOpen(1)==0)
        	{
        		idx=1000;
        	}
        	else 
        	{

	        	t=getTitle();
	        	if (indexOf(t,"20x_")>1)
	        	{
	        		close();
	        		idx = idx +1*0;
	        		run("Bio-Formats Importer", "open="+fname+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_list="+(idx));
	        		if (isOpen(1))
					{
						run("Save As Tiff", "save="+fname+"."+IJ.pad(ctr,3)+".tif");
						ctr=ctr+1;
						close();
					}
					else 
					{
						idx=1000;
					}
					idx = idx + 4;
	        	}
	        	else
	        	{
	        		close();
	        		idx=idx+1;
	        	}
	        }
        }
    }
}

