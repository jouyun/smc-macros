source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	if (endsWith(list[m], ".tif_Files/") )
	{
		for (k=0; k<2; k++){
		current_directory=source_dir+list[m]+"\\";
		open(current_directory+"Fused.tif");
		title=getTitle();
		if (k==0) makeRectangle(708, 528, 7716, 7428);
		else makeRectangle(12600, 456, 8196, 7452);
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
		if (k==0) saveAs("Text", current_directory+"Results0.txt");	
		else saveAs("Text", current_directory+"Results1.txt");	
		
		}
	}
}


