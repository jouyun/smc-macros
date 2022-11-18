name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(false);
first_list = getFileList(source_dir);
for (m=0; m<first_list.length; m++)
{
	first_dir=source_dir+first_list[m];
	IJ.log(first_dir);
	if (File.isDirectory(first_dir)==1)
	{
		second_list = getFileList(first_dir);
		for (n=0; n<second_list.length; n++)
		{
			fname=first_dir+second_list[n];
			IJ.log(fname);
			if (endsWith(fname, ".JPG"))
			{
				//************PROCESS HERE*********************
				open(fname);
				roiManager("reset");
				t=getTitle();
				if (indexOf(t, "0119")>-1)
				{
					run("Multiply...", "value=2.5");
				}
				run("Make Composite");
				//run("Channels Tool...");
				Stack.setDisplayMode("grayscale");
				
				
				//Find worms
				selectWindow(t);
				selectWindow(t);
				run("Duplicate...", "title=asdf duplicate");
				run("Log", "stack");
				run("Invert", "stack");
				run("Subtract Background...", "rolling=100 stack");
				run("Split Channels");
				selectWindow("C3-asdf");
				//run("Subtract...", "value=20");
				imageCalculator("Multiply create 32-bit", "C1-asdf","C3-asdf");
				run("Enhance Contrast", "saturated=0.35");
				setThreshold(550.0000, 44779.0000);
				run("Convert to Mask");
				run("Analyze Particles...", "size=250-Infinity show=Masks exclude");
				run("Invert LUT");
				run("Dilate");
				//run("Dilate");
				run("Analyze Particles...", "size=250-Infinity exclude add");
				selectWindow(t);
				roiManager("Show All");
				
				//Save
				old = nResults;
				roiManager("Deselect");
				roiManager("Save", fname+".zip");
				roiManager("Measure");
				new = nResults;
				for (i=old; i<new; i++)
				{
					setResult("Directory", i, current_file);
				}
				
				run("Close All");
			}
		}

	}

}