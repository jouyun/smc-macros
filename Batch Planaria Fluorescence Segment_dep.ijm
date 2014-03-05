source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
f = File.open("C:\\Data\\Processed\\"+"bogussssss"+".csv"); // display file open dialog
for (m=0; m<list.length; m++) {
	//if (endsWith(list[m], "spectra.lsm") )
	{
		current_file=source_dir+list[m];
		IJ.log(current_file);
		open(current_file);
		/*setAutoThreshold("Triangle dark");
		run("Convert to Mask");
		run("Dilate");*/
		
		/*setAutoThreshold("Percentile dark");
		run("Convert to Mask");
		run("Open");*/
		
		//run("Fill Holes");
		orig_title=getTitle();
		run("Duplicate...", "title=Duh");

		setThreshold(160.2000, 4095.0000);
		run("Convert to Mask");
		run("Fill Holes");
		run("Open");
		title=getTitle();
		run("Set Measurements...", "area mean standard min centroid center fit integrated display redirect=None decimal=3");
		//run("Analyze Particles...", "size=140000-Infinity circularity=0.00-1.00 show=Masks display exclude");
		run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=Masks display exclude");
		rename("Mask");
		mask_title=getTitle();
		selectWindow(title);
		close();
		selectWindow(orig_title);

		run("Smooth");
		run("Subtract Background...", "rolling=10");
		run("Percentile Threshold With Mask", "region="+mask_title+" percentile=30 snr=20");
		tmp_title=getTitle();
		selectWindow(orig_title);
		run("Duplicate...", "title=Duh");
		selectWindow(orig_title);
		close();
		run("Images to Stack", "name=Stack title=[] use");
		
		
		run("Next Slice [>]");
		run("Next Slice [>]");
		run("Invert LUT");
		run("Enhance Contrast", "saturated=0.35");
		Stack.getDimensions(width, height, channels, slices, frames)
		if (channels*slices*frames==3)
		{		
			print("\\Clear");
			run("Process Peaked Worm Mask", "number=100");
			logs=getInfo("log");
			comm=indexOf(logs,",");
			peaks=substring(logs,0,comm);
			area=substring(logs, comm+1,lengthOf(logs));
      			print(f, source_dir+","+ list[m]+","+peaks+","+ area);
		}
      		saveAs("Tiff", current_file+"_mask.tif");
		close();
	}
}
File.close(f)
//saveAs("Results", source_dir+"\\Results.csv");