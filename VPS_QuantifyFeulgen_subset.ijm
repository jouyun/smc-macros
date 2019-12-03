
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
    if (endsWith(fname, ".zip"))
    {
        
        img_name=source_dir+substring(source_list[n], 4, lengthOf(source_list[n])-4)+".tif";

        IJ.log(fname);
        IJ.log(img_name);
        open(img_name);
        open(fname);
        
        t=getTitle();

		
		ct=roiManager("count");
		for (c=0; c<ct; c++)
		{
			selectWindow(t);
			roiManager("Select", c);
			run("Duplicate...", "title="+t+"_"+c+" duplicate");
			setBackgroundColor(0, 0, 0);
			run("Clear Outside");
		}
		
		rois=roiManager("count");
		for (i=0; i<rois; i++)
		{
			roiManager("Select", 0);
			roiManager("Delete");
		}
		m_t=t;
		for (c=0; c<ct; c++)
		{
			t=m_t+"_"+c;
			selectWindow(t);
			run("Select All");
			run("Duplicate...", "title=A duplicate channels=1");
			selectWindow(t);
			run("Duplicate...", "title=B duplicate channels=2");
			//if (c==2) return("a");
			imageCalculator("Subtract create", "A","B");
			setMinAndMax(0, 255);
			run("Invert");
			
			proc=t+"_processed";
			rename(proc);
			
			run("32-bit");
			run("Divide...", "value=255");
			run("Log");
			run("Multiply...", "value=-1");
			run("Properties...", "channels=1 slices=1 frames=1 unit=pixels pixel_width=1 pixel_height=1 voxel_depth=1.0000000");
			run("Enhance Contrast", "saturated=0.35");
			run("Grays");
			
			run("Duplicate...", "title=Threshold");
			run("Gaussian Blur...", "sigma=1");
			//setThreshold(0.04, 1);
			//setAutoThreshold("IsoData dark");
			run("Threshold...");
			waitForUser;
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Fill Holes");
			run("Erode");
			
			run("Extended Particle Analyzer", "area=100-Infinity pixel show=Nothing solidity=0.75-1.00 redirect=None keep=None add");
			selectWindow(proc);
			roiManager("Measure");
			selectWindow(proc);
		
			//if (roiManager("count")>0) roiManager("Save", direc+t+".zip");
			rois=roiManager("count");
		
			for (i=0; i<rois; i++)
			{
				roiManager("Select", 0);
				roiManager("Delete");
			}
			saveAs("Results", source_dir+t+".csv");
			run("Clear Results");
			selectWindow(proc);
			close();
			selectWindow("A");
			close();
			selectWindow("B");
			close();
			selectWindow("Threshold");
			close();
			//return("a");
		}

    }
    run("Close All");
}




