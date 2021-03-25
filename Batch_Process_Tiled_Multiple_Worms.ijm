peak_channel=1;
DAPI_channel=2;

SNR_worm=20;
SNR_peaks=2000;

name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(false);
source_list = getFileList(source_dir);
analysis_file=source_dir+"Analysis.csv";
f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+"Worms\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			if (endsWith(list[m],"mask.tif")==0)
			{
//*****************************************Insert*********************************************************


				current_file=worm_dir+list[m];
				run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
				open(current_file);

				title=getTitle();
				setSlice(peak_channel);
				run("Duplicate...", "title=Peaks channels="+peak_channel);
				selectWindow(title);
				setSlice(DAPI_channel);
				run("Duplicate...", "title=DAPI channels="+DAPI_channel);
				run("32-bit");
				run("Percentile Threshold", "percentile=10 snr="+SNR_worm);
				
				selectWindow(title);
				close();
				selectWindow("Result");
				run("Fill Holes");
				run("Open");
				run("Analyze Particles...", "size=50000-Infinity circularity=0.00-1.00 show=Nothing display exclude clear add");
				rename("duh");
				number_objects=nResults;
				for (j=0; j<number_objects; j++)
				{
					IJ.log(""+nResults);
					run("Clear Results");
					selectWindow("duh");
					roiManager("Select",j);
					run("Duplicate...", "title=Mask");
					run("16-bit");
					selectWindow("DAPI");
					roiManager("Select", j);
					run("Measure");
					Dmax=getResult("Max");
					Dmin=getResult("Min");
					max=0;
					min=0;
		
					selectWindow("Peaks");
					run("Smooth", "slice");
					roiManager("Select", j);
					run("Measure");
					max=getResult("Max");
					min=getResult("Min");
					run("Duplicate...", "title=PeaksCropped");
					run("16-bit");
					run("Find Maxima...", "noise="+SNR_peaks+" output=[Single Points]");
					run("Dilate");
					rename("Spots");
					run("16-bit");
					selectWindow("Mask");
					run("16-bit");
					run("Concatenate...", "  title=[Concatenated Stacks] image1=Mask image2=PeaksCropped image3=Spots image4=[-- None --]");
					setSlice(3);
	
					run("Find Maxima...", "noise="+(100)+" output=Count");
					IJ.log("Counted:  "+ getResult("Count"));
		
					run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
					Stack.setDisplayMode("grayscale");
					setSlice(1);
					run("Enhance Contrast", "saturated=0.35");
					setSlice(2);
					run("Enhance Contrast", "saturated=0.35");
					setSlice(3);
					run("Enhance Contrast", "saturated=0.35");
					setSlice(1);
					run("32-bit");


					print("\\Clear");
					IJ.log(""+getResult("Count",2) +","+getResult("Area",1)+","+max+","+min+","+Dmax+","+Dmin);
					logs=getInfo("log");
					saveAs("Tiff", current_file+"_"+j+"_mask.tif");
					close();
					logs=getInfo("log");
					comm=indexOf(logs,",");
					peaks=substring(logs,0,comm);
					area=substring(logs, comm+1,lengthOf(logs));
					print(f, worm_dir+","+ list[m]+"_"+j+","+peaks+","+ area);
				}
				run("Close All");




//*****************************************End insert***************************************************
				

			}
		}
	}
}
File.close(f);
