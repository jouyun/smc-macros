source_dir = getDirectory("Source Directory");
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) {
	if (endsWith(list[m], "spectra.lsm") )
	{
		current_file=source_dir+list[m];
		open(current_file);
		Stack.getDimensions(width, height, channels, slices, frames);
		run("32-bit");
		run("MakeNormalizedSpectra ");
		for (i=0; i<channels; i++)
		{
			Stack.setChannel(i);
			run("Enhance Contrast", "saturated=0.35");
		}
		saveAs("Tiff", current_file+".tif");
		close();
	}
}