source_dir = getDirectory("Source Directory");
if (File.exists(source_dir)) {
    //setBatchMode(true);
    output_path=source_dir+"\\output\\";
    File.makeDirectory(output_path);
    list = getFileList(source_dir);
    for (i=0; i<list.length; i++) {
        if (endsWith(list[i], ".avi") )
        {
        	file_output_path=output_path+list[i]+"\\";
        	File.makeDirectory(file_output_path);
        	
		full_path_name=source_dir+list[i];
		len=File.length(full_path_name);
		IJ.log(full_path_name);
		run("AVI...", "select=["+full_path_name+"] first=1 last=100000 convert");
		//open(full_path_name);
		ttl=getTitle();
		run("Slice Keeper", "first=4481 last=22407 increment=1");
		run("Smooth", "stack");	
		tt2=getTitle();
		selectWindow(ttl);
		close();
		selectWindow(tt2);	
		rename(ttl);
		getDimensions(width, height, channels, slices, frames);
		run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
		imageCalculator("Subtract create 32-bit stack", list[i],"MAX_"+list[i]);
		selectWindow("Result of "+list[i]);
		selectWindow(list[i]);
		close();
		selectWindow("MAX_"+list[i]);
		saveAs("Tiff", file_output_path+"Background.tif");
		close();
		selectWindow("Result of "+list[i]);
		setAutoThreshold("Otsu");
		run("Convert to Mask", " ");
		orig_idx=getImageID();
		title=getTitle();
		IJ.log("\\Clear");
		//run("MTrack2 smc ", "minimum=5 maximum=999999 maximum_=30 minimum_=2 pixels=30 min=14 frames=1");
		//Kas code has 30 pixels, each well 144 pixels, our rig has 100 pixels per well so need 21 pixels instead of 30
		//Kas code is designed for 30fps, ours is only 15fps, changed to 14
		run("MTrack2 smc ", "minimum=5 maximum=999999 maximum_=30 minimum_=2 pixels=30 min=29 frames=1");

		last_idx=getImageID();
		
		for (j=orig_idx-1; j>last_idx-1; j--)
		{
   			selectImage(j);
   			current_title=getTitle();
   			//run("AVI... ", "compression=Uncompressed frame=15 save=[C:\\Data\\AMM\\First Real Data\\tmp\\"+current_title+".avi]");
   			run("AVI... ", "compression=Uncompressed frame=15 save=["+file_output_path+current_title+".avi]");
   			close();
		}
		selectWindow("Log");
		saveAs("Text", file_output_path+"Log.txt");
		selectWindow(title);
		close();
        }
    }
}
