name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite");
if (File.exists(source_dir)) {
    setBatchMode(false);
    output_path=source_dir+File.separator+"output"+File.separator;
    File.makeDirectory(output_path);
    list = getFileList(source_dir);
    for (i=0; i<list.length; i++) {
        if (endsWith(list[i], ".avi") )
        {
        	file_output_path=output_path+list[i]+File.separator;
        	File.makeDirectory(file_output_path);
        	
		full_path_name=source_dir+list[i];
		len=File.length(full_path_name);
		IJ.log(full_path_name);
		run("AVI...", "select=["+full_path_name+"] first=2250 last=11250 convert");
		for (m=0; m<30; m++) run("Delete Slice");
		getDimensions(width, height, channels, slices, frames);
		run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
		rename("Project");
		imageCalculator("Subtract create 32-bit stack", list[i],"Project");
		selectWindow("Result of "+list[i]);
		selectWindow(list[i]);
		close();
		selectWindow("Project");
		close();
		selectWindow("Result of "+list[i]);
		run("Invert", "stack");
		setAutoThreshold("Otsu dark");
		getThreshold(L,U);
		setThreshold(L, 65535);
		run("Convert to Mask", "stack");	

		orig_idx=getImageID();
		title=getTitle();
		IJ.log("\\Clear");
		//run("MTrack2 smc ", "minimum=5 maximum=999999 maximum_=30 minimum_=2 pixels=30 min=14 frames=1");
		//Kas code has 30 pixels, each well 144 pixels, our rig has 100 pixels per well so need 21 pixels instead of 30
		//Kas code is designed for 30fps, ours is only 15fps, changed to 14
		//
		run("Invert", "stack");
		run("MTrack2 smc ", "minimum=5 maximum=999999 maximum_=30 minimum_=2 pixels=30 min=14 frames=1");

		last_idx=getImageID();
		
		/*for (j=orig_idx-1; j>last_idx-1; j--)
		{
   			selectImage(j);
   			current_title=getTitle();
   			//run("AVI... ", "compression=Uncompressed frame=15 save=[C:\\Data\\AMM\\First Real Data\\tmp\\"+current_title+".avi]");
   			run("AVI... ", "compression=Uncompressed frame=15 save=["+file_output_path+current_title+".avi]");
   			close();
		}*/
		names=newArray(nImages);
		ids=newArray(nImages);
		for (j=0; j<ids.length-1; j++)
		{
			//if (isOpen(i+1))
			{
				selectImage(2);
				current_title=getTitle();
   				run("AVI... ", "compression=Uncompressed frame=15 save=["+file_output_path+current_title+".avi]");
   				close();
			}

		}
		selectWindow("Log");
		saveAs("Text", file_output_path+"Log.txt");
		selectWindow(title);
		close();
        }
    }
}
