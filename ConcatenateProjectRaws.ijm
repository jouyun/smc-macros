channels=2;
slices=50;
max_frames=3;
frames=0;
source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
base_mask=substring(list[0], 0, lengthOf(list[0])-5);
current_mask=base_mask+"1.raw";
IJ.log(current_mask);
run("Raw...", "open=["+source_dir+"\\"+current_mask+"] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number="+(max_frames*channels*slices)+" gap=0 little-endian");
rename(base_mask);
Stack.getDimensions(width, height, bchannels, bslices, tframes);
IJ.log(""+bchannels+" "+bslices+" "+tframes);
frames=frames+bslices/slices/channels;
for (m=1; m<list.length; m++) {
	current_mask=base_mask+(m+1)+".raw";
	IJ.log(current_mask);
	run("Raw...", "open=["+source_dir+"\\"+current_mask+"] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number="+(max_frames*channels*slices)+" gap=0 little-endian");
	tmp_title=getTitle();
	Stack.getDimensions(width, height, bchannels, bslices, tframes);
	frames=frames+bslices/slices/channels;

	run("Concatenate...", "  title="+base_mask+" image1="+base_mask+" image2="+tmp_title+" image3=[-- None --]");
}
IJ.log("Frames: "+frames);

run("Stack to Hyperstack...", "order=xyzct channels="+channels+" slices="+slices+" frames="+frames+" display=Composite");
run("Magenta");
saveAs("Tiff", source_dir+"\\"+base_mask+".tif");
run("Z Project...", "start=1 stop=50 projection=[Max Intensity] all");
run("Reduce Dimensionality...", "  frames");
saveAs("Tiff", source_dir+"\\"+base_mask+"_MAX.tif");

