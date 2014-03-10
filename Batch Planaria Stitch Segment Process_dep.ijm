source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
f = File.open(source_dir+"\\Analysis.csv"); // display file open dialog
for (m=0; m<list.length; m++) 
{
		idx=lengthOf(list[m])-1;
		list[m]=substring(list[m],0,idx);
		file_path=source_dir+list[m]+"\\";
		current_file=file_path+list[m]+".mvd2";
		IJ.log(current_file);	

		run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
		title=getTitle();
		Stack.getDimensions(width, height, channels, slices, frames)
		run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
		p_title=getTitle();
		selectWindow(title);
		close();
		new_directory=file_path+"Worms\\";
		IJ.log(new_directory);
		File.makeDirectory(new_directory);
		selectWindow(p_title);
		saveAs("Tiff", current_file+".tif");
		p_title=getTitle();
		//run("merge objects in tiles", "snr=40 hit=1000 border=100 in=200 x=15 y=15 path=["+new_directory+"]");
		run("merge objects in tiles", "snr=40 hit=400 border=100 in=20 x=18 y=18 path=["+new_directory+"]");
		selectWindow(p_title);
		close();

//Insert fluorescence segment stuff here
		worm_list=getFileList(new_directory);
		for (j=0; j<list.length;j++)
		{
			current_file=new_directory+worm_list[j];
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