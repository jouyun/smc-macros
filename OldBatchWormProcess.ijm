source_dir = getDirectory("Source Directory");
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	if (endsWith(list[m], ".tif_Files/") )
	{
		for (k=0; k<3; k++){
		current_directory=source_dir+list[m]+"\\";
		open(current_directory+"Fused.tif");
		title=getTitle();
		if (k==0) makeRectangle(0,0,7843,10300);
		else if (k==1) makeRectangle(7844, 0, 7843, 10300);
			else makeRectangle(15687, 0, 7843, 10300);
		run("Crop");
		print("\\Clear");
		//runMacro("S:\Microscopy\USERS\SMC\Fiji.app\macros\ProcessWormPlugin.ijm");	
		runMacro("ProcessWormPluginv2.ijm");
		selectWindow(title);
		close();	
		selectWindow("TempImg");
		saveAs("Tiff", current_directory+"Image"+k+".tif");
		close();
		selectWindow("Log");
		saveAs("Text", current_directory+"Results"+k+".txt");	
		}
	}
}


